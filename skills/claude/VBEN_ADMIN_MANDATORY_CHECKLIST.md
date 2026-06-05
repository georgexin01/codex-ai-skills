---
name: vben-admin-mandatory-checklist
description: "MANDATORY AI checklist for every Vben Admin panel project. Auto-check all critical rules before shipping any feature: double-submit, sort defaults, image reset, crop tool, Pica min width, HTML editor CSS."
triggers: ["vben admin", "admin panel", "vben checklist", "mandatory check", "before ship", "what to check", "vben rules", "angel interior admin"]
version: 1.0
date_updated: "2026-05-28"
status: MANDATORY — AI must auto-check on every Vben Admin project
---

# Vben Admin — Mandatory Checklist

> **AI Rule:** On ANY Vben Admin panel task, scan this checklist. If items are missing, fix them as part of the task. Do not wait for the user to report symptoms.

---

## 1. Anti-Double Submit (Create & Edit)

**Symptom:** Multiple identical rows created in Supabase, stacked "Created successfully" toasts.

**Must have in `useCreateDrawer.ts` AND `useEditDrawer.ts`:**

```ts
let _confirmLock = false; // plain JS, not Vue ref

onConfirm: async () => {
  if (_confirmLock || isSubmitting.value) return;
  _confirmLock = true;
  // ... rest of handler
}

onClosed: () => {
  _confirmLock = false; // always reset on close
}
```

**Must have in every form with async submit pipeline:**
```ts
const handleSubmit = async () => {
  await runSingleFlight(async () => { ... });
};
```

→ Full detail: `ANTI_DOUBLE_SUBMIT_PATTERN.md`

---

## 2. Image Attachment Reset After Creation

**Symptom:** After first create, drawer resets text fields but old image thumbnail stays. Second create fails with `null value in column "image_path" violates not-null constraint` (Supabase code `23502`).

**Must have in `useSingleImageAttachment.ts`:**
```ts
const resetAttachment = () => {
  fileList.value = [];
  originalPaths.value = [];
  pendingUploadFiles.value.clear();
};
```

**Must call in every form's `resetAll`:**
```ts
const resetAll = () => {
  resetSingleFlight();
  resetForm();
  resetImageAttachment(); // ← required
};
defineExpose({ resetForm: resetAll, ... });
```

→ Full detail: `ANTI_DOUBLE_SUBMIT_PATTERN.md` § Layer 3

---

## 3. VXE Table Default Sort — created_at DESC + sort DESC

**Symptom:** Tables show data in random order or don't sort correctly on load. Clicking sort header toggles but both ASC and DESC look the same.

**Rules:**
1. Every VXE table defaults to `created_at DESC`
2. Tables with a `sort` column use dual sort: `ORDER BY created_at DESC, sort DESC` (both directions always match)
3. Sort params must be sent **unconditionally** — never conditional

**In every list view `query` handler:**
```ts
// ✅ CORRECT — always send sort
params.sortBy = sort?.field || 'created_at';
params.sortOrder = sort?.order || 'desc';
```

**In every store's fetch function:**
```ts
const primaryField = params?.sortBy || 'created_at';
const ascending = params?.sortOrder !== 'desc';

query = query.order(primaryField, { ascending });

// For tables with sort column:
if (primaryField === 'sort') {
  query = query.order('created_at', { ascending }); // same direction
} else {
  query = query.order('sort', { ascending }); // same direction
}
```

**Why both same direction:** `ORDER BY created_at DESC, sort DESC` — secondary always matches primary. If user clicks ASC: both become ASC. Never hardcode secondary as `ascending: false`.

**Exceptions (no `sort` column):** users, attachments, contact_submissions — single sort only.

→ Full detail: `.codex/skills/claude-app/vben-table-sort/skill.md`

---

## 4. Image Upload — Minimum 360px Width (Pica)

**Symptom:** Uploaded images look too small or blurry when the original image is narrow.

**Rule:** Never produce an image narrower than 360px. Never upscale beyond original width.

**In html-content-editor.vue Pica resize:**
```ts
const MIN_WIDTH = 360;
const effectiveWidth = Math.max(MIN_WIDTH, Math.min(targetWidth, img.width));
const scale = effectiveWidth / img.width;
canvas.width = Math.round(img.width * scale);
canvas.height = Math.round(img.height * scale);
```

→ Full detail: `.codex/skills/claude-app/image-crop-tool/skill.md`

---

## 5. Crop Tool — freeHeight Mode (Portrait Images)

**Used for:** SketchUp resources (800×1422), any portrait/variable-height image.

**Critical rules:**
1. **NEVER use `stencil-size` for freeHeight** — it locks resize, user cannot drag height
2. **Use `default-size` as a function** (not object) — objects use image pixels, look tiny
3. **Display height = 520px fixed** — never derive from `spec.height` (1422px makes canvas microscopic)
4. **Initial stencil at spec ratio** — portrait orientation matching output aspect ratio

```ts
// calcFrameSize for freeHeight:
const FREEHEIGHT_DISPLAY_H = 520;
if (props.spec.freeHeight) {
  const widthScale = Math.min(1, maxW / props.spec.width);
  frameSize.value = {
    width: Math.round(props.spec.width * widthScale),
    height: Math.min(FREEHEIGHT_DISPLAY_H, maxH),
  };
}

// Cropper binding for freeHeight:
v-bind="spec.freeHeight
  ? {
      'default-size': ({ imageSize }: any) => {
        const ar = spec.width / spec.height; // e.g. 800/1422
        const byH = imageSize.height * ar;
        if (byH <= imageSize.width) {
          return { width: byH, height: imageSize.height };
        }
        return { width: imageSize.width, height: imageSize.width / ar };
      }
    }
  : { 'stencil-size': { width: frameSize.width, height: frameSize.height } }"

// Handlers for freeHeight — corners + top/bottom, NO east/west (lock width):
handlers: {
  eastNorth: true, north: true, westNorth: true,
  east: false, west: false,
  eastSouth: true, south: true, westSouth: true,
}
image-restriction="stencil"
```

**Angel Interior specs:**
| Module | Spec | Ratio |
|--------|------|-------|
| SketchUp Resources | `width: 800, height: 1422, freeHeight: true` | 800:1422 portrait |
| Material Resources | `width: 600, height: 600` | 1:1 square |
| Blog Posts | `width: 1200, height: 630` | OG landscape |
| Slideshow | `width: 1600, height: 900` | 16:9 landscape |

→ Full detail: `.codex/skills/claude-app/image-crop-tool/skill.md`

---

## 6. HTML Content Editor — CSS Import Fix

**Symptom:** `[plugin:vite:import-analysis] Failed to resolve import 'quill/dist/quill.snow.css'`

**Fix:**
```ts
// ❌ WRONG
import 'quill/dist/quill.snow.css';

// ✅ CORRECT
import '@vueup/vue-quill/dist/vue-quill.snow.css';
```

**And styles MUST be non-scoped** — scoped CSS loses to globally-imported Quill CSS. Use a wrapper class:
```vue
<div class="angel-quill-wrap">
  <QuillEditor ... />
</div>

<style> /* NOT scoped */
.angel-quill-wrap .ql-toolbar.ql-snow { ... }
</style>
```

---

## 7. Dummy / Seed Data — Staggered Timestamps

**Rule:** When inserting multiple rows of test/seed data, each row's `created_at` must differ by 1–5 seconds so sort order is deterministic.

```sql
-- ✅ CORRECT
INSERT INTO slides (title, created_at) VALUES
  ('Slide 1', NOW() - INTERVAL '5 seconds'),
  ('Slide 2', NOW() - INTERVAL '3 seconds'),
  ('Slide 3', NOW());
```

---

## 8. Required Field Labels — `*` Must Be Red

**Symptom:** Required field asterisks (`*`) render in plain white/grey text instead of red, making them invisible or confusing.

**Rule:** Every `*` required marker in any form label MUST use `<span class="text-red-500">*</span>`. Never write `* FieldName` as a plain text string.

**✅ CORRECT:**
```vue
<div class="mb-1.5 text-sm font-medium text-foreground/80">
  <span class="text-red-500">*</span> Download URL
</div>
```

**❌ WRONG:**
```vue
<div class="mb-1.5 text-sm font-medium text-foreground/80">* Download URL</div>
```

**Applies to ALL form templates:** create drawers, edit drawers, inline forms, modal forms — every module across the entire admin panel.

**Affected modules confirmed:** SketchUp Resources, Material Resources, Blog Posts — and any future module.

---

## Quick Audit Script (run mentally on every Vben project)

```
DOUBLE SUBMIT:
[ ] useCreateDrawer.ts — let _confirmLock = false present?
[ ] useEditDrawer.ts — let _confirmLock = false present?
[ ] All form components — useSingleFlightSubmit imported + used?
[ ] useSingleImageAttachment.ts — resetAttachment() exported?
[ ] All forms with images — resetImageAttachment() in resetAll?

SORT:
[ ] All list view query handlers send sortBy/sortOrder unconditionally?
[ ] All stores with sort column use dual-sort (same direction)?

IMAGES:
[ ] html-content-editor — MIN_WIDTH = 360 in Pica resize?
[ ] html-content-editor — CSS import from @vueup/vue-quill?
[ ] freeHeight crop specs — using default-size function, not stencil-size?

REQUIRED LABELS:
[ ] All form * labels use <span class="text-red-500">*</span>, not plain "* text"?
[ ] Applies to: create drawers, edit drawers, inline form labels, modal forms?

UNIQUE FIELD CHECK (when any field must be unique):
[ ] Store has checkXxxExists(value, excludeId?) using .ilike() + .neq()?
[ ] onInput: clears error, sets isTitleChecking=true immediately, arms debounce?
[ ] Debounce: 2000ms, sets isTitleChecking=false in finally block?
[ ] Spinner: absolute overlay on Form wrapper (NOT schema suffix — not reactive)?
[ ] Alert: type="error" banner closable, placed directly after Form wrapper?
[ ] Fields below error field: extracted from schema, rendered manually?
[ ] Submit guard: re-checks before emit, returns if duplicate?
[ ] resetAll: clears error ref, checking ref, and any manual field ref?
[ ] i18n keys added in both en-US and zh-CN?
→ Full pattern: BLOG_TITLE_DUPLICATE_CHECK_PATTERN.md
```
