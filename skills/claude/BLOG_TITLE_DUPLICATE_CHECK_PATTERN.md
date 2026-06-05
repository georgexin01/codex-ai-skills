---
name: blog-title-duplicate-check-pattern
description: "Complete pattern for real-time title uniqueness checking in Vben Admin blog forms: debounced Supabase query, inline spinner, Alert error placement, form schema split, edit exclusion, submit guard. Reuse for any entity with a unique-name constraint."
triggers: ["blog title check", "duplicate title", "title exists", "unique title", "title validation", "blog post form", "debounced check", "real-time uniqueness"]
version: 1.0
date_updated: "2026-06-03"
project: angel-interior (admin-panel-angel)
status: ACTIVE — implemented and tested
---

# Blog Title Duplicate-Check Pattern

> **Reuse this pattern** for any Vben Admin form field that must be unique in a Supabase table (resource title, category name, URL slug, etc.).

---

## 1. What Was Built

A real-time title uniqueness check on the Create/Edit Blog Post form with:

| Feature | Detail |
|---|---|
| **Debounced check** | Fires 2s after user stops typing — avoids hammering Supabase on every keystroke |
| **Instant spinner** | `<Spin>` appears immediately on first keystroke (not after 2s), disappears when check completes |
| **Inline Alert** | `<Alert type="error">` sits directly below the Title input (not a floating banner) |
| **Edit exclusion** | When editing, current post's own ID is excluded from the uniqueness query |
| **Submit guard** | Even if debounce hasn't fired yet, submit re-runs the check as a hard gate |
| **Silent on success** | No toast/message when title is unique — zero noise |
| **Auto-clear** | Error clears instantly on next keystroke |
| **Reset on close** | All state (error, spinner, excerpt) reset in `resetAll()` |

---

## 2. Supabase Store — `checkTitleExists`

**File:** `apps/web-antd/src/stores/blog.ts`

```ts
async checkTitleExists(title: string, excludeId?: string): Promise<boolean> {
  let query = supabase
    .from('blog_posts')
    .select('id')
    .eq('project_id', PROJECT_ID)
    .is('deleted_at', null)
    .ilike('title', title.trim());  // case-insensitive match
  if (excludeId) query = query.neq('id', excludeId);  // exclude self on edit
  const { data } = await query;
  return (data ?? []).length > 0;
},
```

**Key rules:**
- `.ilike()` — case-insensitive, so "My Post" and "my post" are treated as duplicates
- `.is('deleted_at', null)` — soft-deleted posts don't block new posts with same title
- `excludeId` — always pass `props.post?.id` on edit, else the user can't save their own unchanged title

---

## 3. Form Component Refs

**File:** `apps/web-antd/src/views/blog/blog-post-form.vue`

```ts
const duplicateTitleError = ref('');   // drives the Alert visibility
const isTitleChecking = ref(false);    // drives the Spin visibility
const excerptValue = ref<null | string>(null); // manual (see §5 why)
```

---

## 4. Debounce Function

```ts
import { useDebounceFn } from '@vueuse/core'; // already in project

const checkTitleDebounced = useDebounceFn(async (title: string) => {
  const trimmed = title.trim();
  if (!trimmed) { isTitleChecking.value = false; return; }
  try {
    const exists = await blogStore.checkTitleExists(trimmed, props.post?.id);
    if (exists) {
      duplicateTitleError.value = $t('page.blog.post.form.duplicateTitleError');
    }
    // silent on success — no toast, no green tick
  } finally {
    isTitleChecking.value = false; // always hide spinner when done
  }
}, 2000); // 2 seconds — enough to feel responsive, not spammy
```

**Why 2s not 3s:** Original was 3s. Reduced to 2s for better responsiveness while still preventing per-keystroke Supabase calls.

---

## 5. onInput Handler in Schema

```ts
const formSchema = computed(() => [
  {
    component: 'Input',
    componentProps: {
      id: 'blog-post-form-title-input',
      placeholder: $t('page.blog.post.form.titlePlaceholder'),
      onInput: (e: Event) => {
        const val = (e.target as HTMLInputElement).value;
        duplicateTitleError.value = '';         // clear error immediately
        urlPreview.value = titleToUrl(val);     // sync URL slug preview
        if (val.trim()) isTitleChecking.value = true;   // show spinner instantly
        else isTitleChecking.value = false;             // clear spinner if input emptied
        checkTitleDebounced(val);               // arm 2s timer
      },
    },
    fieldName: 'title',
    label: $t('page.blog.post.form.title'),
    rules: 'required',
  },
  // ⚠️ DO NOT add excerpt here — see §6
]);
```

---

## 6. Why Excerpt is Rendered Manually (Critical)

**Problem:** The Vben `<Form />` renders ALL schema fields as one block. If both Title and Excerpt are in the schema, the duplicate-title Alert would appear *after* the Excerpt field — far from the Title input, confusing UX.

**Solution:** Remove Excerpt from the schema. Render it manually in the template between the Alert and the URL slug preview. This gives layout order:

```
Title input
  ↓ [Spinner overlaid on right side]
Alert (error, directly below Title)
Description/Excerpt (manual Textarea)
URL Slug preview
Content (HTML) editor
```

**Manual excerpt in emptyValues:** Remove `excerpt` from `useEntityForm` emptyValues, track it in a separate `excerptValue` ref, sync via `watch(() => props.post, ...)`, include in submit payload and `resetAll`.

```ts
// useEntityForm — excerpt excluded
useEntityForm<Omit<BlogPostFormValues, 'content_html' | 'excerpt'>, BlogPost>({
  emptyValues: { title: '', cover_image_url: null },
  ...
})

// Watch to sync on edit
watch(() => props.post, (post) => {
  excerptValue.value = post?.excerpt ?? null;
}, { immediate: true });

// Include in emit
emit('submit', {
  ...values,
  excerpt: excerptValue.value ?? null,
  ...
});

// Reset
excerptValue.value = null;
```

---

## 7. Template — Spinner Overlay

**Why not schema `suffix`:** Vben form schema's `componentProps.suffix` using `h(Spin)` does NOT re-render reactively when a ref changes — Vben caches componentProps. Use an absolute overlay instead.

```vue
<!-- Wrap Form in relative container for spinner positioning -->
<div class="relative">
  <Form />
  <!-- top: label(~22px) + gap(~6px) + half input(~16px) = ~44px -->
  <Spin
    v-if="isTitleChecking"
    size="small"
    class="pointer-events-none absolute right-3 top-[44px] -translate-y-1/2"
  />
</div>
```

**Position math for AntD form item:**
- Label height ≈ 22px
- Label-to-input gap ≈ 6px
- Input height = 32px → center = 16px
- Total: `top-[44px]` with `-translate-y-1/2`

If theme/density changes, adjust `top-[44px]` in 2px increments.

---

## 8. Template — Alert Error

```vue
<Alert
  v-if="duplicateTitleError"
  type="error"
  show-icon
  banner
  class="-mt-2 mb-3 rounded-md text-sm"
  :message="duplicateTitleError"
  closable
  @close="duplicateTitleError = ''"
/>
```

**Why `banner`:** Removes the default alert border-radius and padding so it reads as an inline form validation message, not a floating notification.  
**Why `-mt-2`:** Pulls the alert up to reduce gap between Title input and error.  
**Why `closable`:** Lets user dismiss the error manually without retyping.

---

## 9. Submit Hard Guard

Even if the user submits faster than 2s, the check runs again on submit:

```ts
const titleExists = await blogStore.checkTitleExists(values.title, props.post?.id);
if (titleExists) {
  duplicateTitleError.value = $t('page.blog.post.form.duplicateTitleError');
  return; // blocks submit
}
```

This is the safety net for fast-paste / keyboard-submit edge cases.

---

## 10. i18n Keys

**File:** `apps/web-antd/src/locales/langs/en-US/page.json`

```json
"duplicateTitleError": "This title is already used by another post. Please choose a different title.",
"contentHtmlRequired": "Content is required."
```

**File:** `apps/web-antd/src/locales/langs/zh-CN/page.json`

```json
"duplicateTitleError": "此标题已被其他文章使用，请选择不同的标题。",
"contentHtmlRequired": "内容不能为空。"
```

---

## 11. Imports Required

```ts
import { computed, ref, watch } from 'vue';
import { useDebounceFn } from '@vueuse/core';           // already in project
import { Alert, message, Spin, Textarea, Upload } from 'ant-design-vue';
```

---

## 12. Reset Checklist

`resetAll()` must clear ALL title-check state:

```ts
const resetAll = () => {
  resetSingleFlight();
  resetForm();
  resetImageAttachment();
  duplicateTitleError.value = '';   // ← clear error
  isTitleChecking.value = false;    // ← stop spinner
  excerptValue.value = null;        // ← clear manual excerpt
};
```

---

## 13. Applying This Pattern to Other Fields

To reuse for a different entity (e.g. SketchUp resource title, category name):

1. Add `async checkTitleExists(title, excludeId?)` to the relevant Pinia store using `.ilike()` + `.neq()` for the right table
2. Copy the 3 refs (`duplicateTitleError`, `isTitleChecking`, `fieldValue` if manual)
3. Copy `checkTitleDebounced` — change `blogStore` to the new store
4. Add `onInput` handler to the schema field's `componentProps`
5. Wrap `<Form />` in `<div class="relative">` with the `<Spin>` overlay
6. Place `<Alert>` after `</div>` (after the Form wrapper)
7. If the error field is not the last schema field, extract lower fields from schema and render manually (see §6)
8. Add submit guard after `submitForm()`
9. Add i18n keys in both locale files
10. Clear all 3 refs in `resetAll()`
