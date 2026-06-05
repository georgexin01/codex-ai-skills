---
name: frontend-12-i18n-composables
description: "Step 12 — i18n (vue-i18n + auto-glob locales) + src/composables/ (Capacitor Clipboard/Share pattern, reactive link generators)."
triggers: ["i18n", "vue-i18n", "locale", "translations", "composables", "useInviteLink", "capacitor clipboard", "capacitor share"]
phase: 4-polish
requires: [frontend-09-view-scaffolding]
unlocks: [frontend-13-native-pwa-deploy]
output_format: typescript
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 12 — i18n + Composables

## 🎯 When to Use
When the webApp needs multiple languages, OR when cross-view logic (copy-link, share, deep-link, timer, debounced search) would otherwise get duplicated across `.vue` files.

**Optional**: skip the i18n half if the project is single-language (webApp-LAA-quiz-v2 is EN-only and skips it). Keep the composables half regardless — it's broadly useful.

## ⚠️ Dependencies
- **09-view-scaffolding** — views exist and need translation / composable helpers.

## 📋 Procedure

### Part A — i18n (optional)
1. **Install** vue-i18n: `pnpm add vue-i18n@^9`.
2. **Create `src/i18n/index.ts`** — auto-glob all `./locales/*.json` files (Code Vault §1). No manual imports per locale.
3. **Create `src/i18n/locales/gb.json`** (English), `cn.json` (Chinese), etc. — flat key/value.
4. **Register in `src/main.ts`** — `app.use(i18n)`.
5. **Use in views** — `{{ $t('page.courses.title') }}` in templates; `const { t } = useI18n()` in `<script setup>`.

### Part B — Composables (always)
1. **Create `src/composables/` folder**.
2. **For each reusable cross-view hook**, create `use<Name>.ts` — Code Vault §2 is the `useInviteLink` template (copy-to-clipboard + native share via Capacitor).
3. **Install native plugins** if using: `pnpm add @capacitor/clipboard @capacitor/share`.
4. **Consume in views** — `const { inviteLink, copyInviteLink } = useInviteLink(() => user.phoneNumber);`.

## 📦 Code Vault

### §1. `src/i18n/index.ts` — auto-glob pattern
```ts
import { createI18n } from 'vue-i18n';

/**
 * Auto-glob every JSON file in ./locales/*.json — no manual imports.
 * Add/remove a locale by adding/removing the file; no code change required.
 */
const fileNameToLocaleModuleDict = import.meta.glob<{
  default: Record<string, string>;
}>('./locales/*.json', { eager: true });

const messages: Record<string, Record<string, string>> = {};
Object.entries(fileNameToLocaleModuleDict).forEach(([fileName, localeModule]) => {
  const parts = fileName.split('/');
  const filename = parts[parts.length - 1]!;          // "gb.json"
  const localeName = filename.split('.json')[0]!;      // "gb"
  messages[localeName] = localeModule.default;
});

export default createI18n({
  legacy: false,                // Composition API
  locale: 'gb',                 // default
  fallbackLocale: 'gb',
  warnHtmlMessage: false,
  messages,
});
```

### §2. `src/main.ts` — registration (add to existing Step 01 wiring)
```ts
import { createApp } from 'vue';
import { createPinia } from 'pinia';

import App from '@/App.vue';
import router from '@/router';
import i18n from '@/i18n';               // ← add

const app = createApp(App);
app.use(createPinia());
app.use(router);
app.use(i18n);                           // ← add
app.mount('#root');
```

### §3. Sample `src/i18n/locales/gb.json`
```json
{
  "page.courses.title": "My Courses",
  "page.courses.refresh": "Refresh",
  "page.courses.empty.title": "No courses available",
  "page.courses.empty.sub": "Please check back later or contact your instructor.",
  "page.quiz.submit": "Submit Answer",
  "page.login.submit": "Authorize Login",
  "page.login.loading": "Verifying Identity...",
  "common.logout": "Logout",
  "common.back": "Back"
}
```

### §4. Usage in a view
```vue
<script setup lang="ts">
import { useI18n } from 'vue-i18n';
const { t, locale } = useI18n();

function switchToChinese() { locale.value = 'cn'; }
</script>

<template>
  <button>{{ $t('common.logout') }}</button>
  <p>{{ t('page.courses.empty.sub') }}</p>
</template>
```

### §5. Composable: `src/composables/useInviteLink.ts`
```ts
import { computed } from 'vue';
import { Clipboard } from '@capacitor/clipboard';
import { Share } from '@capacitor/share';

import { useUiStore } from '@/stores';
import { getApiBaseUrl } from '@/api';    // from Step 03

/**
 * Generates an invite link from the given phone/user identifier, and
 * exposes copy-to-clipboard + native-share actions.
 *
 * Works on web (falls back to navigator.clipboard + navigator.share when available)
 * and on Capacitor native (Clipboard + Share plugins).
 */
export function useInviteLink(phoneNo: () => string | undefined) {
  const uiStore = useUiStore();

  const inviteLink = computed(() => {
    const phone = phoneNo();
    return phone ? `${getApiBaseUrl('/invite?phoneNo=')}${phone}` : '';
  });

  const copyInviteLink = async () => {
    if (!inviteLink.value) return;
    await Clipboard.write({ string: inviteLink.value });
    uiStore.addToast('Copied', 'Invite link copied to clipboard.', 'success');
  };

  const shareInviteLink = async () => {
    if (!inviteLink.value) return;
    await Share.share({
      title: 'Join our app!',
      text: 'Check this out:',
      url: inviteLink.value,
    });
  };

  return { inviteLink, copyInviteLink, shareInviteLink };
}
```

### §6. Composable: `src/composables/useCountdown.ts` (generic timer)
```ts
import { ref, onUnmounted } from 'vue';

/**
 * Countdown helper for quiz timers, OTP expiry, etc.
 *
 * Usage:
 *   const { seconds, start, stop, reset } = useCountdown(60);
 *   start();
 *   // seconds.value decrements from 60 → 0, then onComplete fires.
 */
export function useCountdown(initial: number, onComplete?: () => void) {
  const seconds = ref(initial);
  let timer: ReturnType<typeof setInterval> | null = null;

  const start = () => {
    stop();
    timer = setInterval(() => {
      seconds.value--;
      if (seconds.value <= 0) {
        stop();
        onComplete?.();
      }
    }, 1000);
  };

  const stop = () => {
    if (timer) { clearInterval(timer); timer = null; }
  };

  const reset = (n = initial) => { stop(); seconds.value = n; };

  onUnmounted(stop);

  return { seconds, start, stop, reset };
}
```

## 🛡️ Guardrails

- **Auto-glob locales** — `import.meta.glob('./locales/*.json', { eager: true })`. Don't manually import each locale in index.ts; adding a language should be a one-file-drop operation.
- **Legacy: false** — always use Composition API mode (`legacy: false`). `legacy: true` is deprecated and breaks `useI18n()` in `<script setup>`.
- **Flat i18n keys, dotted** — `page.courses.empty.title`, not nested objects. Simpler to audit with grep.
- **Fallback locale = default locale** — if `locale: 'gb'`, `fallbackLocale: 'gb'`. Prevents `{page.x.y}` placeholder leakage when a key is missing in another language.
- **Composables start with `use`** — Vue convention. `useCountdown`, `useInviteLink`, `useDebounce`. Anything else is just a utility, not a composable.
- **Composables are reactive** — return refs/computeds, not plain values. If a composable returns `inviteLink: string`, it should be `inviteLink: ComputedRef<string>`.
- **Native-first when available** — the Capacitor Clipboard/Share plugins fall back to web APIs when running in a browser (web-first implementation inside the plugin). Don't re-implement that fallback in every caller.
- **Toast feedback** — every user-facing composable action (`copyInviteLink`, etc.) should call `useUiStore().addToast()` on success. Silent success = unclear UX.
- **No cross-store imports from a composable** — composables can call stores (they're standalone), but don't create circular deps (store → composable → store).

## ✅ Verify

```bash
# 1. i18n boot
pnpm dev
#    Open the app → no "[intlify] Not found 'xxx' key in ..." warnings in console.

# 2. Locale switch
#    In a view:  locale.value = 'cn';
#    Expect: all translated strings flip to Chinese without a page reload.

# 3. Composable wiring
#    Use useInviteLink in a view → click copy → toast fires, clipboard contains the URL.

# 4. Type-check
pnpm type-check
```

## ♻️ Rollback
```bash
rm -rf src/i18n/
# Remove app.use(i18n) from src/main.ts
# Replace {{ $t('x') }} with raw text in templates (or the tool of your choice).

rm -rf src/composables/
# Inline the logic back into the views that used it.
```

## → Next Step
**[13-native-pwa-deploy](../13-native-pwa-deploy/skill.md)** — Capacitor native wrap + PWA manifest + production deploy.
