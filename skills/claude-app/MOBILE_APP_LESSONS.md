---
name: mobile-app-lessons
description: "Field-tested gotchas for Vue 3 + Capacitor + Supabase mobile/PWA builds. Read before any mobile app work."
triggers: ["capacitor", "mobile error", "pwa error", "ios", "android", "mobile build", "capacitor sync", "native plugin"]
phase: reference
version: 1.0
status: authoritative
last_updated: "2026-06-08"
---

# Vue Mobile App + Capacitor — Field Lessons

> Append-only. New lessons go at the bottom of the matching section. Never delete.

---

## 1. Viewport Must Be `device-width` — Never Hardcoded

```html
<!-- ✅ Correct -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />

<!-- ❌ Wrong — clips right edge on iPhone SE and narrow Androids -->
<meta name="viewport" content="width=412, initial-scale=1.0" />
```

Real phones range CSS-width 320–430px. `device-width` auto-fits every screen.
Optional: add `max-width: 412px` on `#app` container for desktop framing only.

---

## 2. Capacitor Sync After Every Native Change

After any change to `capacitor.config.ts`, native plugins, or `package.json`:
```bash
npx cap sync
```
Forgetting this causes old native code to run with new JS — symptoms look like random plugin failures.

---

## 3. Supabase Client in Mobile — Use `AsyncStorage` for Session Persistence

Default Supabase client uses `localStorage` which does not persist reliably in Capacitor WebView on iOS. Use `@capacitor/preferences` as the storage adapter:

```ts
import { Preferences } from '@capacitor/preferences'

const supabase = createClient(url, key, {
  auth: {
    storage: {
      getItem: async (key) => (await Preferences.get({ key })).value,
      setItem: (key, value) => Preferences.set({ key, value }),
      removeItem: (key) => Preferences.remove({ key }),
    },
  },
})
```

---

## 4. `safe-area-inset` for iPhone Notch + Home Bar

All fixed bottom elements (tab bars, CTAs, bottom sheets) must account for iPhone safe area:
```css
padding-bottom: env(safe-area-inset-bottom);
```

Without this, buttons sit under the home indicator on iPhone X+.

---

## 5. Camera / File Upload — Capacitor Plugin Required on Native

`<input type="file">` works in browser/PWA but fails silently on native iOS/Android.
Use `@capacitor/camera` for image capture and `@capacitor/filesystem` for file ops on native builds.

---

## 6. CORS Errors Only Appear in Browser, Not Native

Supabase CORS errors will block calls in the browser dev build but will NOT appear on the native device (Capacitor bypasses CORS). Always test API calls on actual device/emulator, not just browser, before declaring them fixed.

---

## 7. `pnpm dev:local` is the Correct Local Dev Command

```bash
pnpm dev:local   # ✅ → --mode development.localhost → Docker Supabase localhost:54321
pnpm dev         # ❌ runs all apps, too heavy
pnpm dev:antd    # ❌ wrong mode
```

---

## 8. PWA Service Worker Caches Old JS After Deploy

After deploying a new build, users on PWA may still see old JS due to service worker cache. Always increment the `version` in `vite-pwa` config on every release, or use `skipWaiting: true` in the SW config to force immediate update.

---

## 9. Bottom Sheet / Modal — Avoid `position: fixed` Inside Scroll Containers

`position: fixed` elements inside a scrollable Capacitor WebView layer will scroll with the content on Android. Use `position: sticky` or restructure the DOM so fixed elements are direct children of `#app`, not inside scroll wrappers.
