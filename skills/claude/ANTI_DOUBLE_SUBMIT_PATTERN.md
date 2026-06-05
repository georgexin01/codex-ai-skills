---
name: anti-double-submit-pattern
description: "MANDATORY for every Vben Admin project. Prevents duplicate create/update Supabase rows from double-clicks. Covers _confirmLock plain JS flag, useSingleFlightSubmit, image attachment reset, and request-level cooldown."
triggers: ["double submit", "duplicate create", "prevent double click", "anti duplicate form", "single flight submit", "created twice", "duplicate rows", "image not reset after create"]
version: 2.0
date_updated: "2026-05-28"
status: MANDATORY — apply to every Vben Admin project
---

# Anti Double Submit Pattern (MANDATORY)

> **AI Rule:** When building or auditing any Vben Admin panel, ALWAYS verify these protections exist before shipping any create/edit form. Do not skip.

---

## Why It Happens

In Vben-style drawers, the confirm button calls a child form method. That form does async work (validation → image upload → processImage → emit). Vue's reactivity batches ref updates — two rapid clicks in the same render frame **both pass the `isSubmitting.value` check before it updates**, firing two API calls and creating two rows.

---

## 4-Layer Protection Stack

| Layer | File | Mechanism |
|-------|------|-----------|
| **1. Plain JS lock** | `useCreateDrawer.ts` / `useEditDrawer.ts` | `_confirmLock` boolean — set synchronously, immune to Vue batching |
| **2. Vue ref lock** | same | `isSubmitting` ref — belt-and-suspenders |
| **3. Single-flight form guard** | every form `.vue` | `useSingleFlightSubmit` wraps entire pipeline |
| **4. Content-hash cooldown** | `useCreateDrawer.ts` | 2500ms dedup by payload fingerprint |

---

## Layer 1 — `_confirmLock` Plain JS Boolean (THE CRITICAL FIX)

**Why plain JS, not a Vue ref?** Vue refs are subject to reactivity batching — two synchronous clicks before the next render tick both see the old value. A plain `let` variable is set/read in the same JS engine tick with zero delay.

Add to **both** `useCreateDrawer.ts` and `useEditDrawer.ts`:

```ts
// Declare alongside other refs
let _confirmLock = false;

// In onClosed — reset so next open is fresh
onClosed: () => {
  _confirmLock = false;
  // ... other resets
},

// In onConfirm — first two lines, no exceptions
onConfirm: async () => {
  if (_confirmLock || isSubmitting.value) return;
  _confirmLock = true;

  setSubmitState(true); // sets isSubmitting + confirmDisabled + confirmLoading

  try {
    await formRef.value?.submitForm?.();
  } catch (error) {
    _confirmLock = false;       // release on error
    setSubmitState(false);
    throw error;
  }

  if (!hasActiveRequest.value && !isSubmitSuccess.value) {
    _confirmLock = false;       // release on no-request path
    setSubmitState(false);
  }
  // Success path: drawer closes → onClosed → _confirmLock = false
},
```

**Reset points for `_confirmLock`:**
- `onClosed` — drawer fully closed (success + cancel)
- `catch` block — request failed, user can retry
- No-active-request path — form validation failed, nothing sent

---

## Layer 2 — `useSingleFlightSubmit` in Every Form

Every form component that does async work before emitting must use this:

```ts
// composable: src/composables/useSingleFlightSubmit.ts
export function useSingleFlightSubmit() {
  const isRunning = ref(false);

  const runSingleFlight = async <T>(task: () => Promise<T>) => {
    if (isRunning.value) return;
    isRunning.value = true;
    try {
      return await task();
    } finally {
      isRunning.value = false;
    }
  };

  const resetSingleFlight = () => { isRunning.value = false; };
  return { isRunning, resetSingleFlight, runSingleFlight };
}
```

**Apply in every form that has image uploads:**

```ts
const { resetSingleFlight, runSingleFlight } = useSingleFlightSubmit();

const handleSubmit = async () => {
  await runSingleFlight(async () => {
    const values = await submitForm();
    if (!values) return;

    const imagePath = await resolveSubmittedPath(); // async upload
    await cleanupRemovedPaths(imagePath);

    emit('submit', { ...values, image_path: imagePath });
  });
};
```

---

## Layer 3 — Image Attachment Reset After Successful Creation

**The bug:** After create success, the drawer calls `resetForm()` which clears text fields but NOT the image `fileList`. On the next create attempt:
- Old image thumbnail still shows
- `resolveSubmittedPath()` returns `null` (no pending upload, no valid URL)
- Supabase throws `null value in column "image_path" violates not-null constraint` (code `23502`)

**Fix in `useSingleImageAttachment.ts`** — add `resetAttachment`:

```ts
const resetAttachment = () => {
  fileList.value = [];
  originalPaths.value = [];
  pendingUploadFiles.value.clear();
};

return {
  // ...existing exports
  resetAttachment,
};
```

**Call in every form's `resetAll`:**

```ts
const {
  cleanupRemovedPaths,
  resetAttachment: resetImageAttachment,
  // ...
} = useSingleImageAttachment({ ... });

const resetAll = () => {
  resetSingleFlight();
  resetForm();
  resetImageAttachment(); // ← MUST include this
  // any other local state resets (downloadType, etc.)
};

defineExpose({ resetForm: resetAll, submitForm: handleSubmit, ... });
```

**Affected forms in Angel Interior:**
- `slideshow-form.vue`
- `material-resource-form.vue`
- `sketchup-resource-form.vue`
- `blog-post-form.vue`

---

## Layer 4 — Content-Hash Cooldown (useCreateDrawer only)

```ts
const recentSubmissionKeys = new Map<string, number>();
const SUBMISSION_COOLDOWN_MS = 2500;

// In handleSubmit (the @submit event handler):
const submissionKey = buildSubmissionKey(`create:${title}`, values);
const lastAt = recentSubmissionKeys.get(submissionKey);
if (typeof lastAt === 'number' && Date.now() - lastAt < SUBMISSION_COOLDOWN_MS) {
  return; // same payload within 2.5s — ignore
}
```

---

## Verification Checklist

After implementation, test in browser:

- [ ] Open create drawer → fill form → **double-click Create rapidly** → confirm only 1 row in DB
- [ ] Open create drawer → submit successfully → reopen → image field is empty (not showing old image)
- [ ] Open create drawer → submit fails → button re-enables → can retry
- [ ] Close drawer without submitting → reopen → button works normally
- [ ] Repeat above for **edit drawer**

---

## Audit Checklist — Run on Every Vben Admin Project

```
[ ] useCreateDrawer.ts has _confirmLock (let _confirmLock = false)
[ ] useEditDrawer.ts has _confirmLock (let _confirmLock = false)
[ ] Every form with image upload uses useSingleFlightSubmit
[ ] Every form's resetAll calls resetImageAttachment()
[ ] useSingleImageAttachment exports resetAttachment
```
