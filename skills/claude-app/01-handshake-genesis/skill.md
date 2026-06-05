---
name: frontend-01-handshake-genesis
description: "Step 01 — project genesis: package.json, vite.config.ts, tsconfig.json, index.html (viewport=device-width), main.ts. Boots Vue 3 + Pinia + router with zero scaffolding."
triggers: ["new webapp", "vue bootstrap", "handshake", "project genesis", "vite init"]
phase: 1-foundation
requires: []
unlocks: [frontend-02-config-hardening]
output_format: mixed
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 01 — Handshake Genesis (Project Plumbing)

## 🎯 When to Use
Standing up a brand-new Vue 3 webApp in the quizLaa family. This step produces a running dev server with Pinia + Router wired in, nothing more.

## ⚠️ Dependencies
None — this is Step 1.

## 📋 Procedure

1. **Create project root** folder (e.g., `webApp-<name>/`). All paths below are relative to it.
2. **Create `package.json`** — copy from Code Vault §1. Pins Vue 3.5, Pinia 3, vue-router 5, Supabase JS 2, Capacitor Core 8, Tailwind 4, Vite 6.
3. **Run** `pnpm install` (or npm/yarn).
4. **Create `vite.config.ts`** — copy from Code Vault §2. Port default 3000, `@/*` alias to `./src/*`, proxy `/api` → `http://localhost:5321` (admin panel fallback).
5. **Create `tsconfig.json`** — copy from Code Vault §3. Strict mode, bundler resolution, `@/*` path, ESNext target.
6. **Create `index.html`** — copy from Code Vault §4. **⚠️ viewport MUST be `width=device-width`** (user global rule — responsive to every phone size; `width=412` clips narrower devices). Swap the SEO / Open Graph / JSON-LD blocks with project-specific copy before launch.
7. **Create `src/env.d.ts`** — copy from Code Vault §5. Declares `ImportMetaEnv` keys for typed `import.meta.env.VITE_*`.
8. **Create `src/main.ts`** — copy from Code Vault §6. Mounts App to `#root` with Pinia + Router.
9. **Create `src/App.vue`** — minimal stub with `<router-view />` (Code Vault §7).
10. **Create empty folders** — `src/{api,config,stores,router,types,views,composables,i18n}/` so subsequent steps have anchor points.
11. **Verify** (§Verify below) — `pnpm dev` should start on port 3000 without errors.

## 📦 Code Vault

### §1. `package.json`
```json
{
  "name": "<webapp-name>",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vue-tsc --noEmit && vite build",
    "preview": "vite preview",
    "type-check": "vue-tsc --noEmit"
  },
  "devDependencies": {
    "@types/node": "^22.14.0",
    "@vitejs/plugin-vue": "^6.0.4",
    "autoprefixer": "^10.5.0",
    "postcss": "^8.5.9",
    "tailwindcss": "^4.2.2",
    "typescript": "~5.8.2",
    "vite": "^6.2.0",
    "vue-tsc": "^3.2.5"
  },
  "dependencies": {
    "@capacitor/core": "^8.3.1",
    "@supabase/supabase-js": "^2.103.0",
    "axios": "^1.15.0",
    "pinia": "^3.0.4",
    "vue": "^3.5.29",
    "vue-router": "^5.0.3"
  }
}
```

### §2. `vite.config.ts`
```ts
import path from 'path'
import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, '.', '')
  return {
    server: {
      port: Number(env.VITE_PORT) || 3000,
      host: '0.0.0.0',
      proxy: {
        '/api': {
          target: 'http://localhost:5321',
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, '/api'),
          configure: (proxy) => {
            proxy.on('error', (err) => console.error('[PROXY ERROR]', err));
          },
        },
      },
    },
    publicDir: 'favicon',
    plugins: [vue()],
    resolve: {
      alias: { '@': path.resolve(__dirname, './src') },
    },
  }
})
```

### §3. `tsconfig.json`
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "skipLibCheck": true,
    "types": ["node"],
    "moduleResolution": "bundler",
    "isolatedModules": true,
    "moduleDetection": "force",
    "allowJs": true,
    "jsx": "preserve",
    "paths": { "@/*": ["./src/*"] },
    "allowImportingTsExtensions": true,
    "noEmit": true,
    "strict": true,
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src/**/*.ts", "src/**/*.vue", "src/env.d.ts", "vite.config.ts"]
}
```

### §4. `index.html` (essentials — replace PROJECT placeholders)
```html
<!DOCTYPE html>
<html lang="en" class="light">
<head>
  <meta charset="UTF-8">
  <meta name="robots" content="noindex,nofollow">
  <meta name="description" content="PROJECT_DESCRIPTION">

  <!-- ⚠️ MANDATORY: width=device-width (responsive to every phone size) -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">

  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <meta name="theme-color" content="#PRIMARY_HEX">
  <link rel="canonical" href="https://PROJECT_URL/">
  <link rel="manifest" href="/site.webmanifest">
  <title>PROJECT_TITLE</title>
</head>
<body class="antialiased text-slate-900">
  <div id="root" role="main"></div>
  <script type="module" src="/src/main.ts"></script>
  <script>if('serviceWorker' in navigator)navigator.serviceWorker.register('/sw.js');</script>
</body>
</html>
```

> Full production `index.html` also includes SEO meta block, Open Graph, Twitter cards, JSON-LD `WebApplication` schema, PWA install banner stub, fullscreen-on-click. See Cookbook §SEO-Head `(file removed)` for the full template.

### §5. `src/env.d.ts`
```ts
/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<Record<string, unknown>, Record<string, unknown>, unknown>
  export default component
}

interface ImportMetaEnv {
  readonly VITE_SUPABASE_URL: string
  readonly VITE_SUPABASE_ANON_KEY: string
  readonly VITE_SUPABASE_SCHEMA: string
  readonly VITE_PROJECT_ID: string
  readonly VITE_APP_TITLE: string
  readonly VITE_PORT: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
```

### §6. `src/main.ts`
```ts
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from '@/App.vue'
import router from '@/router'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.mount('#root')
```

### §7. `src/App.vue` (stub)
```vue
<script setup lang="ts">
</script>

<template>
  <router-view />
</template>
```

## 🛡️ Guardrails

- **Rule #1 (schema isolation)** — this step makes no DB calls yet; honored by omission.
- **Viewport device-width (user global rule)** — always use `width=device-width`. Never hardcode `width=412` — clips narrower phones.
- **Mount target is `#root`** (not `#app`) — the LAA convention. Do not rename without updating `index.html` + `main.ts` together.
- **Alias is `@/*` → `./src/*`** — keep consistent in both `vite.config.ts` AND `tsconfig.json`. Desyncing the two is the #1 import-resolution bug in this stack.

## ✅ Verify

```bash
pnpm install                  # should succeed with zero peer-dep warnings
pnpm dev                      # expect: "Local: http://localhost:3000/"
```

Open the URL → expect an empty page (no console errors). The 200 response from `/` proves Vue mounted.

```bash
pnpm type-check               # expect: exit code 0
```

## ♻️ Rollback
`rm -rf` the project folder. Nothing else to undo — no DB state touched yet.

## → Next Step
**[02-config-hardening](../../claude/analyze-schema/skill.md)** — create `src/config/{env.ts, supabase.ts, index.ts}` so `VITE_*` has a single read site.
