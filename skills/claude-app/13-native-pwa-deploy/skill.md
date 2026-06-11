---
name: frontend-13-native-pwa-deploy
description: "Step 13 — Capacitor Android/iOS wrap + PWA manifest + service worker + production deploy (render.yaml / Vercel / static host). Final step before ship."
triggers: ["capacitor config", "android build", "ios build", "pwa manifest", "service worker", "render yaml", "staging deploy", "production deploy"]
phase: 4-polish
requires: [frontend-12-i18n-composables]
unlocks: []
output_format: mixed
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 13 — Native + PWA + Deploy

## 🎯 When to Use
Last step before shipping. Covers three deployment targets that can coexist:

1. **PWA** (installable web app) — `manifest.json` + service worker. Every webApp gets this.
2. **Native** (Android / iOS) — Capacitor wrap. Optional; skip for web-only apps.
3. **Static host** — Render / Vercel / Netlify / Cloudflare Pages. Target is `dist/` after `pnpm build`.

## ⚠️ Dependencies
- **12-i18n-composables** — finalize composables that use native plugins (`@capacitor/clipboard`, `@capacitor/share`) before native builds are wrapped.

## 📋 Procedure

### Part A — PWA (always)
1. **Create `favicon/site.webmanifest`** — Code Vault §1. `start_url`, icons, theme colors.
2. **Create `favicon/sw.js`** — minimal service worker (Code Vault §2). Already registered by `index.html` from Step 01.
3. **Generate icon set** — 192×192 + 512×512 PNG minimum. Place in `favicon/assets/favicon/`.
4. **Apple touch icon** — 180×180 PNG linked from `index.html`.
5. **Test install** — Chrome desktop → address-bar install prompt appears. iOS Safari → Share → Add to Home Screen → app launches without browser chrome.

### Part B — Native (optional — skip if web-only)
1. **Install** Capacitor: `pnpm add @capacitor/core @capacitor/cli @capacitor/android @capacitor/ios`.
2. **Create `capacitor.config.ts`** — Code Vault §3.
3. **Initialize platforms**: `npx cap add android`, `npx cap add ios`.
4. **Build web**: `pnpm build` → produces `dist/`.
5. **Sync to native**: `npx cap sync`.
6. **Open native project**: `npx cap open android` (or `ios`). Build + deploy from Android Studio / Xcode.

### Part C — Static deploy
1. **Choose host**. For Render: `render.yaml` (Code Vault §4). For Vercel: Git integration, zero config.
2. **Set env vars** in the host dashboard — every `VITE_*` key from Step 02 `.env` (no anon key in git).
3. **Build command**: `pnpm install && pnpm build`.
4. **Publish directory**: `dist`.
5. **SPA fallback** — every host needs a rewrite rule so deep links don't 404: `/* → /index.html`.

## 📦 Code Vault

### §1. `favicon/site.webmanifest`
```json
{
  "name": "LAA Training Quiz",
  "short_name": "LAA Quiz",
  "description": "Professional agent training platform featuring course selection, video training, interactive quizzes, and performance tracking.",
  "start_url": "/",
  "scope": "/",
  "display": "standalone",
  "orientation": "portrait",
  "background_color": "#f8f6f6",
  "theme_color": "#d52b1e",
  "icons": [
    {
      "src": "/assets/favicon/web-app-manifest-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "/assets/favicon/web-app-manifest-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any maskable"
    }
  ],
  "categories": ["education", "productivity"],
  "lang": "en"
}
```

### §2. `favicon/sw.js` — minimal service worker
```js
/**
 * Minimal network-first service worker.
 * Registered from index.html:
 *   if ('serviceWorker' in navigator) navigator.serviceWorker.register('/sw.js');
 */

const CACHE_NAME = 'app-v1';
const ASSETS = ['/', '/index.html'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS)),
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))),
    ),
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request)),
  );
});
```

### §3. `capacitor.config.ts`
```ts
import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.laa.trainingquiz',          // reverse-DNS; must match play/app store listing
  appName: 'LAA Training Quiz',
  webDir: 'dist',                          // where Vite outputs
  bundledWebRuntime: false,
  plugins: {
    SplashScreen: { launchShowDuration: 0 },    // hide immediately; Vue handles splash
    CapacitorHttp: { enabled: true },            // native HTTP bypasses WebView CORS
    PushNotifications: { presentationOptions: ['badge', 'sound', 'alert'] },
    Keyboard: { resizeOnFullScreen: true },      // WebView shrinks when keyboard opens
  },
  // Uncomment for live-reload during dev from a real device:
  // server: { url: 'http://192.168.x.x:3000', cleartext: true },
};

export default config;
```

### §4. `render.yaml` — static deploy
```yaml
services:
  - type: web
    name: laa-training-quiz
    runtime: static
    buildCommand: pnpm install && pnpm build
    staticPublishPath: ./dist
    envVars:
      - key: VITE_SUPABASE_URL
        sync: false                 # set in dashboard, never committed
      - key: VITE_SUPABASE_ANON_KEY
        sync: false
      - key: VITE_SUPABASE_SCHEMA
        sync: false
      - key: VITE_PROJECT_ID
        sync: false
      - key: VITE_APP_TITLE
        value: LAA Training Quiz
    routes:
      - type: rewrite              # SPA fallback — every unmatched route → index.html
        source: /*
        destination: /index.html
    headers:
      - path: /sw.js
        name: Cache-Control
        value: no-cache            # SW must update immediately
      - path: /assets/*
        name: Cache-Control
        value: public, max-age=31536000, immutable
```

### §5. Alternative: `vercel.json`
```json
{
  "buildCommand": "pnpm install && pnpm build",
  "outputDirectory": "dist",
  "framework": "vite",
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ],
  "headers": [
    {
      "source": "/sw.js",
      "headers": [{ "key": "Cache-Control", "value": "no-cache" }]
    },
    {
      "source": "/assets/(.*)",
      "headers": [{ "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }]
    }
  ]
}
```

### §6. Build + deploy cheat sheet
```bash
# Local PWA preview
pnpm build && pnpm preview                  # open http://localhost:4173

# Android (debug APK on connected device)
pnpm build && npx cap sync android && npx cap run android

# iOS (requires macOS + Xcode)
pnpm build && npx cap sync ios && npx cap open ios

# Render / Vercel — push to git, auto-deploy.
```

## 🛡️ Guardrails

- **PWA viewport is width=device-width** — responsive to every phone width. Matches the global rule from Step 01.
- **Icons must be maskable** — PWA icons on Android get cropped to a circle/squircle. Use `purpose: "any maskable"` and leave the inner 40% safe-area around the logo.
- **SW cache version bump** — every deploy, bump `CACHE_NAME` in `sw.js` (e.g., `app-v1` → `app-v2`). Users with the old SW get the new one on next visit; without the bump they stay stale.
- **SPA fallback is required** — without `/* → /index.html` rewrite, deep links to `/courses/<uuid>` return 404 from the static host. #1 post-deploy bug.
- **Env vars never in git** — `sync: false` on Render, `.env*` in `.gitignore`. Set in the dashboard.
- **Capacitor `server.url` is dev-only** — never leave it uncommented in prod builds; apps would phone home to your LAN IP.
- **Minimum icon set** — 192×192 + 512×512 for PWA. 180×180 for Apple touch. 1024×1024 for App Store. Don't ship without them.
- **HTTPS required** for service worker registration in production. Most hosts give it automatically (Render, Vercel, Netlify, Cloudflare Pages). Localhost is exempt.
- **Supabase RLS verified against prod** — staging RLS must match prod RLS. If prod uses a different schema (`quizLaa` everywhere), double-check before the first live deploy.

## ✅ Verify

```bash
# 1. Build passes with no TS errors
pnpm build
# Expected: dist/ created, no red output.

# 2. PWA Lighthouse audit
#    Chrome DevTools → Lighthouse → PWA category
#    Expected: Installable ✓, Offline works ✓, Manifest present ✓.

# 3. SPA fallback
#    Deploy → visit https://your-host/courses/some-deep-uuid directly
#    Expected: app loads normally (not a 404 page).

# 4. Service worker
#    DevTools → Application → Service Workers
#    Expected: activated, controlling the page. Version-bump + reload → new SW takes over.

# 5. Native (if Capacitor)
#    npx cap sync + open Xcode/Android Studio → build to simulator/device
#    Expected: app launches, Supabase reads work (check CapacitorHttp plugin active).
```

## ♻️ Rollback
```bash
# PWA:
rm favicon/site.webmanifest favicon/sw.js
# Remove <link rel="manifest"> + SW register block from index.html.

# Native:
npx cap sync                        # re-sync after reverting capacitor.config.ts

# Deploy:
# Render/Vercel dashboard → Deploys → pick last known-good commit → Redeploy.
```

## → Finish
Skill protocol complete. The webApp should now:
- Boot locally (`pnpm dev`) with auth + data + navigation working end-to-end.
- Build (`pnpm build`) with zero TS errors.
- Install as a PWA on desktop + mobile.
- (If native) deploy to Android + iOS stores.
- Deploy to a static host with env vars safely in the dashboard.

Update [`LAA_PROJECT_SNAPSHOT.md`](../../../memories/3_domains/claude/LAA_PROJECT_SNAPSHOT.md) with the production URL and seed credentials for the record.
