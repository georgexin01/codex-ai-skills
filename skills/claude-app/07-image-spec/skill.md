---
name: frontend-07-image-spec
description: "Step 07 — Image handling: AppImage component with fallback, Supabase Storage upload helper, ui-avatars.com on-the-fly avatar fallback. No broken image icons, ever."
triggers: ["image spec", "app image", "image fallback", "supabase storage", "upload image", "ui-avatars", "avatar fallback"]
phase: 2-scaffold
requires: [frontend-06-industrial-stores]
unlocks: [frontend-09-view-scaffolding]
output_format: mixed
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 07 — Image Spec (storage + fallback)

## 🎯 When to Use
Any view that renders images sourced from DB rows (course cover, user avatar, agent profile, etc.). The rule: **no raw `<img>` tags**. Always `<AppImage>`.

## ⚠️ Dependencies
- **06-industrial-stores** — stores expose image URLs (`course.image`, `user.avatar`) on App-type rows.

## 📋 Procedure

1. **Create `src/components/AppImage.vue`** — wrapper with fallback (Code Vault §1). Triggers fallback on null/empty/404.
2. **Create `src/utils/storage.ts`** — Supabase Storage upload helper for cases where the webApp itself uploads (Code Vault §2). Most webApps just consume URLs written by the admin panel — upload is optional.
3. **Default avatar convention** — when `user.avatar` is empty, fall back to `ui-avatars.com` URL generated from the user's name. Already wired in `src/stores/auth.ts` (Step 04). Don't duplicate; just consume `user.avatar`.
4. **Empty-image placeholder** — use the "no image available" pattern (Code Vault §1 inline). Gray bg + centered micro-text, never a broken-image icon.
5. **Replace any `<img>` usage** — grep for `<img ` across `src/views/` and swap to `<AppImage>`.

## 📦 Code Vault

### §1. `src/components/AppImage.vue`
```vue
<script setup lang="ts">
import { ref, computed } from 'vue';

interface Props {
  src?: string | null;
  alt?: string;
  customClass?: string;
  /** Background-image style instead of <img> — useful for aspect-ratio boxes */
  asBg?: boolean;
}
const props = withDefaults(defineProps<Props>(), {
  src: '',
  alt: '',
  customClass: '',
  asBg: false,
});

const failed = ref(false);

const isEmpty = computed(() => {
  const s = props.src;
  if (!s) return true;
  if (typeof s !== 'string') return true;
  return s.trim() === '';
});

const showFallback = computed(() => isEmpty.value || failed.value);

function onError() {
  failed.value = true;
}
</script>

<template>
  <div
    v-if="showFallback"
    :class="[
      'flex items-center justify-center bg-gray-200 dark:bg-gray-900',
      customClass,
    ]"
    role="img"
    :aria-label="alt || 'no image available'"
  >
    <span class="text-[10px] uppercase tracking-widest font-medium text-gray-500 dark:text-gray-600">
      no image available
    </span>
  </div>

  <div
    v-else-if="asBg"
    :class="['bg-center bg-no-repeat bg-cover', customClass]"
    :style="{ backgroundImage: `url('${src}')` }"
    role="img"
    :aria-label="alt"
  />

  <img
    v-else
    :src="src ?? ''"
    :alt="alt"
    :class="customClass"
    loading="lazy"
    decoding="async"
    @error="onError"
  />
</template>
```

### §2. `src/utils/storage.ts` — Supabase Storage upload
```ts
/**
 * Upload a file to Supabase Storage. Returns the public URL.
 * Bucket must exist and have an anon-insert RLS policy (or a signed-URL token flow).
 *
 * Usage:
 *   const url = await uploadToBucket('course-covers', file, `${courseId}/cover.jpg`);
 */
import { supabase } from '@/config';

export async function uploadToBucket(
  bucket: string,
  file: File,
  path: string,
  options: { upsert?: boolean } = {},
): Promise<string> {
  const { error } = await supabase.storage
    .from(bucket)
    .upload(path, file, {
      cacheControl: '3600',
      upsert: options.upsert ?? false,
      contentType: file.type,
    });
  if (error) throw error;

  const { data } = supabase.storage.from(bucket).getPublicUrl(path);
  return data.publicUrl;
}

/** Delete a previously uploaded object. Best-effort — no throw on 404. */
export async function deleteFromBucket(bucket: string, path: string): Promise<void> {
  const { error } = await supabase.storage.from(bucket).remove([path]);
  if (error && !error.message.toLowerCase().includes('not found')) throw error;
}
```

### §3. Avatar fallback pattern (already in auth store — reference only)
```ts
// Inside fetchUser() in src/stores/auth.ts — already wired up in Step 04:
avatar:
  userData.avatar ||
  `https://ui-avatars.com/api/?name=${encodeURIComponent(userData.name)}&background=d52b1e&color=fff`,
```

> This gives every user a deterministic fallback avatar from their name — no broken circles, no grey silhouettes.

### §4. Usage in a view
```vue
<!-- Background-image box (aspect-ratio safe) -->
<AppImage
  :src="course.image"
  alt="Course cover"
  custom-class="w-24 h-24 rounded-lg flex-shrink-0"
/>

<!-- Avatar circle -->
<AppImage
  :src="authStore.user?.avatar"
  alt="Agent avatar"
  custom-class="h-20 w-20 rounded-full border-2 border-primary/10"
/>
```

## 🛡️ Guardrails

- **No raw `<img>` in views** — every image wraps in `<AppImage>`. The grep in Verify catches regressions.
- **Fallback must not break layout** — the placeholder inherits the parent's width/height via `customClass`. If you pass `customClass="w-24 h-24 rounded-lg"`, the fallback matches exactly.
- **`lazy` loading by default** — `<img>` has `loading="lazy"` so off-screen images don't block first paint. If you need an above-the-fold image to preload, set `loading="eager"` explicitly (rare).
- **Null-safe props** — `src` can be `null | undefined | '' | valid-url`. The component handles all four without throwing.
- **Storage RLS** — Supabase Storage requires an RLS policy on the bucket. For anon-readable (public) buckets, configure `SELECT` for `public` role. For upload-on-behalf-of-admin, route through the admin panel's RPC, not the webApp.
- **Bucket naming** — lowercase, hyphenated (`course-covers`, `agent-avatars`). Do not use spaces, periods, or uppercase; PostgREST URL-encoding gets flaky.
- **Cache control** — `cacheControl: '3600'` = 1 hour. Adjust only if content changes frequently AND you invalidate URLs (append `?v=<ts>` or use `upsert` semantics).

## ✅ Verify

```bash
# 1. No raw <img> tags outside AppImage.vue itself
grep -rn "<img " src/views/ src/components/ --include="*.vue" \
  | grep -v "AppImage.vue" \
  | grep -v "^.*:.*<!--"
# Expected: empty

# 2. Type-check + runtime
pnpm type-check
pnpm dev
# - Render a view with a row whose image field is '' → expect "no image available" card.
# - Render a view with a broken URL → expect fallback appears on image error.
# - Render a view with a valid URL → image loads normally.
```

## ♻️ Rollback
```bash
rm -f src/components/AppImage.vue src/utils/storage.ts
# Revert views to raw <img> tags (or keep the fallback pattern manually inline).
```

## → Next Step
**[08-ui-standardization](../08-ui-standardization/skill.md)** — Tailwind theme tokens + Material Symbols + loading/empty state conventions.

## Free Visual Sourcing Extension

When an app or webApp needs images but the agent cannot generate raster images directly, apply:

`C:\Users\user\.codex\skills\normal\design\FREE_VISUAL_ASSET_SOURCING.md`

Rules for Claude/frontend work:

1. Treat stock/CDN images as prototype data, not as real client-owned media.
2. Wrap every sourced image in `<AppImage>` or the project image component so 404s fall back cleanly.
3. For lists/catalogs, store a small reusable array of image URLs or local asset paths in mock data and cycle them across records.
4. Prefer local cached files for production-like demos; remote URLs are acceptable only for quick MVP templates.
5. Keep `loading="lazy"`, `decoding="async"`, fixed size/aspect ratio, and `object-fit: cover`.
6. Record source/license metadata in the project blueprint or `IMAGE_SOURCES.md`.
