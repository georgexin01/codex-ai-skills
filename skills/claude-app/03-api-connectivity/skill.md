---
name: frontend-03-api-connectivity
description: "Step 03 — src/api/: OPTIONAL platform-aware client layer (axios + Capacitor native bridge). Use when you need non-Supabase HTTP or native mobile apps. Not needed for simple Supabase-only webapps."
triggers: ["api connectivity", "src/api", "apiClient", "capacitorClient", "capacitor http", "native platform detect", "axios interceptor"]
phase: 1-foundation
requires: [frontend-02-config-hardening]
unlocks: [frontend-06-industrial-stores]
output_format: typescript
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 03 — API Connectivity (the `src/api/` pillar — conditional)

## 🎯 When to Use

**Use this step when you need ANY of:**
- Non-Supabase HTTP endpoints (custom Laravel/PHP backend, 3rd-party APIs)
- Native mobile app with FormData upload (Capacitor's WebView has CORS + Content-Type quirks for multipart)
- Request/response interceptors (auth header injection, error envelope transformation)
- Mixed backends (Supabase for data + legacy REST for admin ops)

**SKIP this step when:**
- The webApp only talks to Supabase (data goes through `@/config/supabase.ts` directly, per Step 02).
- This is the case for `webApp-LAA-quiz-v2` — it has no `src/api/` folder and calls `supabase.from(...)` from stores.

If you skip, create an empty `src/api/` placeholder so later steps can reference it without breaking.

## ⚠️ Dependencies
- **02-config-hardening** — `env` barrel for base URL config.

## 📋 Procedure

1. **Decide the scope** (see "When to Use" above).
2. **Create `src/api/apiClient.ts`** — axios instance + Capacitor FormData interceptor (Code Vault §1).
3. **Create `src/api/capacitorClient.ts`** — CapacitorHttp wrapper for native-only JSON calls (Code Vault §2).
4. **Move the base URL** to `env.API_BASE_URL` (add to `env.ts` in Step 02 if not present). Never hardcode.
5. **Create `src/api/index.ts`** (barrel) — re-export `apiClient` default + `capacitorClient` named + `getApiBaseUrl()` helper.
6. **Consume from stores** — if a store needs non-Supabase data: `import apiClient from '@/api'`.

## 📦 Code Vault

### §1. `src/api/apiClient.ts` — axios + native FormData handling
```ts
import { Capacitor } from '@capacitor/core';
import axios from 'axios';

import { env } from '@/config';

const apiClient = axios.create({
  baseURL: env.API_BASE_URL,       // add API_BASE_URL to env.ts
});

// ─── Request interceptor ─────────────────────────────────

apiClient.interceptors.request.use(
  async (config) => {
    if (Capacitor.isNativePlatform()) {
      // Native: Capacitor WebView has quirks with multipart/form-data.
      // Re-route FormData through native fetch so the boundary is set correctly.
      if (config.data instanceof FormData) {
        config.headers['Content-Type'] = 'multipart/form-data; charset=utf-8;';

        const formData = new FormData();
        for (const [key, value] of config.data.entries()) {
          formData.append(key, value);
        }
        const resp = await fetch(config.baseURL + config.url!, {
          method: 'post',
          headers: {
            Authorization: config.headers['Authorization']?.toString() ?? '',
          },
          body: formData,
        });
        const json = await resp.json();

        config.adapter = (request) =>
          new Promise((resolve, reject) => {
            if (json.success) {
              resolve({
                data: json,
                status: resp.status,
                statusText: resp.statusText,
                headers: config.headers,
                request,
                config,
              });
            } else {
              reject({
                response: { data: json },
                status: resp.status,
                statusText: resp.statusText,
                headers: config.headers,
                request,
                config,
              });
            }
          });
      }
    } else {
      // Web: axios handles both FormData and JSON natively
      config.headers['Content-Type'] = config.data instanceof FormData
        ? 'multipart/form-data; charset=utf-8;'
        : 'application/json';
    }
    return config;
  },
  (error) => Promise.reject(error),
);

// ─── Response interceptor ────────────────────────────────

apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('[API]', error?.response?.data ?? error);
    return Promise.reject(error?.response?.data?.error ?? error);
  },
);

// ─── Helper for web-shareable links ──────────────────────

import { isHashRouting } from '@/router';

export const getApiBaseUrl = (path: string = ''): string => {
  const baseURL = apiClient.defaults.baseURL || '';
  const base = baseURL.replace(/\/api\/?$/, '');
  const hashPrefix = isHashRouting() ? '/#' : '';
  return `${base}${hashPrefix}${path}`;
};

export default apiClient;
```

### §2. `src/api/capacitorClient.ts` — CapacitorHttp wrapper
```ts
import { CapacitorHttp } from '@capacitor/core';

import { env } from '@/config';

/**
 * Use when you need a pure-native HTTP path (bypasses axios entirely).
 * Useful for: iOS/Android behind picky enterprise proxies, endpoints
 * that require mobile-plugin cookies, or apps with Firebase bridge.
 */
export const capacitorClient = {
  async get(url: string, options: any = {}) {
    return httpRequest('GET', url, options);
  },
  async post(url: string, data: any, options: any = {}) {
    return httpRequest('POST', url, { ...options, data });
  },
  async put(url: string, data: any, options: any = {}) {
    return httpRequest('PUT', url, { ...options, data });
  },
  async delete(url: string, options: any = {}) {
    return httpRequest('DELETE', url, options);
  },
};

async function httpRequest(method: string, url: string, options: any) {
  try {
    const headers = {
      'Content-Type': 'application/json',
      ...options.headers,
    };
    const response = await CapacitorHttp.request({
      method,
      url: env.API_BASE_URL + url,
      headers,
      data: options.data || null,
      params: options.params || {},
    });
    return response.data;
  } catch (error) {
    console.error('[CapacitorHttp]', error);
    throw error;
  }
}
```

### §3. `src/api/index.ts` — barrel
```ts
export { default as apiClient, getApiBaseUrl } from './apiClient';
export { capacitorClient } from './capacitorClient';
```

### §4. Add to `src/config/env.ts` (if using this step)
```ts
// Inside AppEnv interface:
API_BASE_URL: string;

// Inside readEnv calls:
API_BASE_URL: readEnv('API_BASE_URL'),
```

## 🛡️ Guardrails

- **Rule #1 (schema isolation)** — `src/api/` is for NON-Supabase work. All Supabase reads stay in stores (Step 06) via `@/config`. Do not wrap `supabase` calls through `apiClient`.
- **Base URL from env** — never hardcode `https://mybackend.com/api`. Read from `env.API_BASE_URL`. The bakery template had hardcoded URLs; that's a tech-debt mistake.
- **Native-only FormData path** — the multipart interceptor exists because Capacitor's WebView injects boundaries incorrectly. Do not remove it unless you've tested all file uploads on both iOS and Android.
- **Don't swallow errors** — the response interceptor re-rejects with `response.data.error`. If your backend uses a different error envelope, adjust there, not at callsites.
- **One adapter per interceptor** — don't chain `config.adapter = ...` more than once. The current implementation runs once in the native FormData branch; keep it that way.
- **`capacitorClient` is JSON-only** — no multipart. For file uploads on native, use `apiClient` (it routes through native fetch under the hood).

## ✅ Verify

```bash
# 1. Type-check
pnpm type-check                                 # expect: 0

# 2. Sanity test — in a store:
#    import apiClient from '@/api';
#    const { data } = await apiClient.get('/health');
#    console.log(data);                           # expect: backend JSON

# 3. Native test (if Capacitor present):
#    Build + deploy to device → trigger a FormData upload → verify backend
#    receives correct multipart with boundary. Axios-only path will FAIL on
#    Capacitor; native fetch path must handle it.
```

## ♻️ Rollback
```bash
rm -rf src/api/
# Remove API_BASE_URL from env.ts + .env if no longer needed.
```

Stores that consumed `apiClient` will break loudly at import — rewrite them to use Supabase directly (via `@/config`) or a different transport.

## → Next Step
**[04-auth-architecture](../04-auth-architecture/skill.md)** (if not already done) — even apps that skip this step still need auth.
Then **[06-industrial-stores](../06-industrial-stores/skill.md)** for data logic.
