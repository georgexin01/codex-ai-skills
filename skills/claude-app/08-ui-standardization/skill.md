---
name: frontend-08-ui-standardization
description: "Step 08 — UI conventions for webApp stack: Tailwind + Material Symbols + theme CSS vars + loading/empty state patterns + glass/ios-shadow effects. Mobile-first max-w-[480px] shell."
triggers: ["ui standardization", "tailwind config", "material symbols", "theme tokens", "mobile webapp", "loading skeleton", "empty state", "glass liquid", "ios shadow"]
phase: 3-ui
requires: [frontend-07-image-spec]
unlocks: [frontend-09-view-scaffolding]
output_format: mixed
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 08 — UI Standardization (Tailwind + Material Symbols + theme)

## 🎯 When to Use
Before building views (Step 09). Establishes the design tokens and reusable patterns every view will consume.

**Scope clarification:** This step is for the **webApp stack** (Tailwind-first, mobile-first, phone-shaped shell — webApp-LAA-quiz-v2 style). Ant Design conventions apply to the admin panel (`apps/web-antd/`) and live in the project CLAUDE.md — not here.

## ⚠️ Dependencies
- **07-image-spec** — `<AppImage>` fallback component.

## 📋 Procedure

1. **Confirm `index.html` inline Tailwind config** (already in Step 01 Code Vault §4) — primary color, dark background, ge-yellow, ge-orange, Manrope font, Material Symbols CDN.
2. **Use the standard shell** (Code Vault §1) for every top-level page: `max-w-[480px] mx-auto` for phone parity, header + main + bottom nav.
3. **Loading state** — Tailwind `animate-pulse` skeleton (Code Vault §2). No spinners on list views.
4. **Empty state** — icon circle + bold title + sub-text + primary button (Code Vault §3). Never a raw text alert.
5. **Icons** — use Material Symbols Outlined via CDN class `<span class="material-symbols-outlined">icon_name</span>`. Already loaded by `index.html`.
6. **Button conventions** — primary CTA = `bg-primary text-white rounded-xl h-14 shadow-xl shadow-primary/30 active:scale-[0.98]`. Secondary = `text-primary font-bold hover:underline`.
7. **Script block order** in every `.vue` — 1.Imports · 2.Props/Emits · 3.Stores · 4.Local State · 5.Lifecycle · 6.Functions. See Code Vault §4.
8. **Toasts** — via `useUiStore().addToast(title, message, type)`. Never `alert()`, never a stale `error.value` in the DOM as the only feedback.

## 📦 Code Vault

### §1. Standard page shell (mobile-first)
```vue
<template>
  <div class="relative flex min-h-screen w-full flex-col overflow-x-hidden max-w-[480px] mx-auto bg-white dark:bg-background-dark">
    <!-- Sticky header -->
    <header class="sticky top-0 z-50 flex items-center bg-white/80 dark:bg-background-dark/80 backdrop-blur-md p-4 pb-2 justify-between border-b border-gray-100 dark:border-gray-800">
      <div class="flex size-10 shrink-0 items-center">
        <!-- leading slot — logo or back button -->
      </div>
      <h2 class="text-gray-900 dark:text-white text-lg font-bold leading-tight tracking-tight flex-1 text-center">
        Page Title
      </h2>
      <div class="flex w-10 items-center justify-end">
        <!-- trailing slot — logout, settings, etc. -->
      </div>
    </header>

    <!-- Scrollable content -->
    <main class="flex-1 overflow-y-auto pb-24">
      <!-- content -->
    </main>

    <!-- Fixed bottom nav (optional) -->
    <nav class="fixed bottom-0 w-full max-w-[480px] bg-white/90 dark:bg-background-dark/90 backdrop-blur-lg border-t border-gray-100 dark:border-gray-800 flex justify-around items-center h-20 pb-4 z-40">
      <!-- nav items — see Code Vault §5 -->
    </nav>
    <div class="h-6 bg-white dark:bg-background-dark w-full fixed bottom-0 max-w-[480px] z-30"></div>
  </div>
</template>
```

### §2. Loading skeleton (list views)
```vue
<div v-if="loading" class="flex flex-col gap-4 p-4">
  <div
    v-for="i in 3"
    :key="i"
    class="animate-pulse flex items-stretch justify-between gap-4 rounded-xl bg-gray-50 dark:bg-gray-900/40 p-4 border border-gray-100 dark:border-gray-800"
  >
    <div class="flex-1 space-y-3 py-1">
      <div class="h-2 bg-gray-200 rounded w-1/4"></div>
      <div class="h-4 bg-gray-200 rounded w-3/4"></div>
      <div class="h-2 bg-gray-200 rounded w-1/2"></div>
    </div>
    <div class="size-24 bg-gray-200 rounded-lg"></div>
  </div>
</div>
```

### §3. Empty state
```vue
<div v-else class="flex flex-col items-center justify-center py-20 px-10 text-center gap-4">
  <div class="size-20 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
    <span class="material-symbols-outlined text-gray-400 text-4xl">inventory_2</span>
  </div>
  <div class="space-y-1">
    <p class="text-gray-900 dark:text-white font-bold text-lg">No courses available</p>
    <p class="text-gray-500 dark:text-gray-400 text-sm">Please check back later or contact your instructor.</p>
  </div>
  <button @click="reload()" class="text-primary font-bold text-sm mt-2">Refresh</button>
</div>
```

### §4. Script block order (enforced in every `.vue`)
```ts
<script setup lang="ts">
// 1. Imports
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore, useLessonsStore } from '@/stores';
import type { Course } from '@/types';
import AppImage from '@/components/AppImage.vue';

// 2. Define (Props/Emits)
interface Props { embedded?: boolean }
const props = withDefaults(defineProps<Props>(), { embedded: false });

// 3. Stores
const authStore = useAuthStore();
const lessonsStore = useLessonsStore();
const router = useRouter();

// 4. Local State (Ref/Reactive)
const loading = ref(true);

// 5. Lifecycle Hooks
onMounted(async () => {
  // Sequential: fetchUser MUST resolve before any store query
  await authStore.fetchUser();
  if (!authStore.user?.id) return;
  await lessonsStore.getList(authStore.user.id);
  loading.value = false;
});

// 6. Functions / Handlers
function select(id: string) { router.push(`/courses/${id}`); }
</script>
```

### §5. Bottom nav item (active vs inactive)
```vue
<!-- Active -->
<div class="flex-1 flex flex-col items-center justify-center gap-1 text-primary cursor-pointer">
  <span class="material-symbols-outlined font-bold text-[28px]" style="font-variation-settings: 'FILL' 1">menu_book</span>
  <span class="text-xs font-bold">Learning</span>
</div>
<!-- Inactive -->
<div
  class="flex-1 flex flex-col items-center justify-center gap-1 text-gray-400 dark:text-gray-600 cursor-pointer"
  @click="router.push('/history')"
>
  <span class="material-symbols-outlined text-[28px]">history_edu</span>
  <span class="text-xs font-medium">History</span>
</div>
```

### §6. Primary CTA button
```vue
<button
  type="submit"
  :disabled="loading"
  class="flex w-full cursor-pointer items-center justify-center overflow-hidden rounded-xl h-14 px-5 bg-primary text-white text-base font-bold leading-normal tracking-wide shadow-xl shadow-primary/30 active:scale-[0.98] transition-all disabled:opacity-60 disabled:cursor-not-allowed"
>
  <span class="truncate">{{ loading ? 'Verifying...' : 'Authorize Login' }}</span>
</button>
```

### §7. Theme tokens (reference — already in `index.html`)
```js
// Inside <script>tailwind.config = { ... }</script> in index.html
theme: {
  extend: {
    colors: {
      'primary': '#d52b1e',           // project primary — change per brand
      'ge-yellow': '#ffd600',
      'ge-orange': '#ff9900',
      'background-light': '#f8f6f6',
      'background-dark': '#211211',
      'form-bg': '#f5f7fa',
    },
    fontFamily: {
      'display': ['Manrope', 'Noto Sans SC', 'sans-serif'],
    },
    borderRadius: {
      'DEFAULT': '0.25rem',
      'lg': '0.5rem',
      'xl': '0.75rem',
      '2xl': '1rem',
      'full': '9999px',
    },
  },
},
```

### §8. Signature effects (reference — already in `index.html` `<style>`)
```css
/* Material Symbols default weight */
.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}

/* Score gradients (yellow/orange → green/red) */
.score-gradient-text {
  background: linear-gradient(135deg, #ffd600 0%, #ff9900 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.score-gradient-text-red {
  background: linear-gradient(135deg, #ef4444 0%, #b91c1c 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

/* Glass liquid background — modal overlays, floating cards */
.glass-liquid {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(24px) saturate(160%);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
.dark .glass-liquid {
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.05);
}

/* iOS-style soft shadow — cards, nav */
.ios-shadow { box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); }

/* Hide scrollbars */
::-webkit-scrollbar { display: none; }
```

## 🛡️ Guardrails

- **Mobile shell max-width 480px** — every top-level view uses `max-w-[480px] mx-auto`. Desktop browsers see a centered phone-frame, not a full-width stretched UI. This is enforced so the `index.html` viewport=device-width global rule stays visually consistent.
- **Material Symbols over SVG icon libraries** — CDN loaded in `index.html`. Never bundle an icon library unless a specific symbol is unavailable.
- **Toast > alert** — all user feedback routes through `useUiStore().addToast(title, message, type)`. Never `alert()`, never a stale red div as the only error UX.
- **Animate-pulse skeletons, not spinners** — for list views. A spinner on a list is amateur hour; skeletons match the final layout and feel faster.
- **Empty state is its own composition** — icon + bold title + sub-text + refresh button. Do NOT render an empty table or "no data" text alone.
- **Script order enforced** — 1–6 block order (§4). Makes every view diff-friendly. Deviating is a code-review reject.
- **Dark mode via `dark:` prefix** — toggled by `class="dark"` on `<html>`. Every color class should have a `dark:` counterpart for text/bg/border.
- **No Ant Design Vue** — that's admin panel territory. The webApp is Tailwind + custom components. Keep the boundary clean.
- **Primary color is a single CSS var** — `bg-primary`, `text-primary`, `shadow-primary/30`. Changing the brand = change `'primary'` in `index.html` tailwind config; nothing else.

## ✅ Verify

```bash
# 1. No Ant Design imports in webApp
grep -rn "ant-design-vue\|antd" src/ package.json
# Expected: empty (this is a webApp, not admin)

# 2. No raw <img>
grep -rn "<img " src/views/ --include="*.vue" | grep -v AppImage
# Expected: empty

# 3. All top-level views use max-w-[480px]
grep -rn "max-w-\[480px\]" src/views/ --include="*.vue"
# Expected: every list.vue and index.vue matches

# 4. Script block order
#    Open any view → confirm the six numbered comments are present and in order.
```

## ♻️ Rollback
No rollback — this is a conventions step, not a file drop. If a pattern proves wrong for a specific view, fix that view; don't change the convention.

## → Next Step
**[09-view-scaffolding](../09-view-scaffolding/skill.md)** — apply these patterns to generate List/Detail/Form view templates.
