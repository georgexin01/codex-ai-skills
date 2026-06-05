---
name: frontend-02-config-hardening
description: "Step 02 — src/config/: typed env wrapper + Supabase dual-client (business schema + public schema). Single read site for VITE_*."
triggers: ["config hardening", "src/config", "env wrapper", "typed env", "dual client", "supabase schema binding"]
phase: 1-foundation
requires: [frontend-01-handshake-genesis]
unlocks: [frontend-03-api-connectivity, frontend-04-auth-architecture, frontend-05-types-foundry]
output_format: typescript
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 02 — Config Hardening (the `src/config/` pillar)

## 🎯 When to Use
Right after Step 01. Before touching stores, views, or the API layer.

This step creates the **ONLY** place in the webApp where `import.meta.env.VITE_*` is read. Every other module reads from `env.*` (the typed wrapper).

## ⚠️ Dependencies
- **01-handshake-genesis** — `src/` folder + `@/*` alias + `env.d.ts` declarations.

## 📋 Procedure

1. **Create `.env`** at project root (add to `.gitignore`). Fill with:
   ```
   VITE_SUPABASE_URL=http://localhost:54321
   VITE_SUPABASE_ANON_KEY=<anon-jwt-from-supabase-status>
   VITE_SUPABASE_SCHEMA=quizLaa
   VITE_PROJECT_ID=<uuid-of-public.project-row>
   VITE_APP_TITLE=LAA Training Quiz
   VITE_PORT=3000
   ```
2. **Create `.env.example`** — same keys, redacted values. Commit this.
3. **Create `src/config/env.ts`** — copy Code Vault §1. Throws at boot if required keys missing.
4. **Create `src/config/supabase.ts`** — copy Code Vault §2. Exports two clients (business schema + public schema).
5. **Create `src/config/index.ts`** (barrel) — copy Code Vault §3. All consumers import from `@/config`, never from `./env` or `./supabase` directly.
6. **Audit rule**: grep the rest of `src/` for `import.meta.env.VITE_` — expected match count: **0** outside `src/config/`. If any match exists, refactor to use `env.*`.

## 📦 Code Vault

### §1. `src/config/env.ts`
```ts
/**
 * Typed environment wrapper — single source of truth for all VITE_* reads.
 *
 * Benefits vs scattered `import.meta.env.VITE_*`:
 *   1. One place to validate required keys at boot
 *   2. Typed access (IDE autocomplete)
 *   3. Easy to mock in tests
 *   4. Clear list of env dependencies for deployment
 */

interface AppEnv {
  /** Supabase REST URL, e.g. http://localhost:54321 */
  SUPABASE_URL: string;
  /** Anon JWT (public — safe to expose) */
  SUPABASE_ANON_KEY: string;
  /** Project schema name, e.g. "quizLaa" */
  SUPABASE_SCHEMA: string;
  /** UUID of public.project row for this project — used by auth flow */
  PROJECT_ID: string;
  /** Optional app title for HTML head / nav */
  APP_TITLE?: string;
}

function readEnv(key: string, required = true): string {
  const val = import.meta.env[`VITE_${key}`] as string | undefined;
  if (required && (!val || val.trim() === '')) {
    throw new Error(`[env] Missing required VITE_${key} — check .env.*`);
  }
  return val ?? '';
}

export const env: AppEnv = {
  SUPABASE_URL: readEnv('SUPABASE_URL'),
  SUPABASE_ANON_KEY: readEnv('SUPABASE_ANON_KEY'),
  SUPABASE_SCHEMA: readEnv('SUPABASE_SCHEMA'),
  PROJECT_ID: readEnv('PROJECT_ID'),
  APP_TITLE: readEnv('APP_TITLE', false) || 'App',
};
```

### §2. `src/config/supabase.ts`
```ts
/**
 * Supabase clients — centralized in src/config/ per project convention.
 *
 * Two clients by design (one client = one schema binding):
 *   - `supabase`      → quizLaa business schema (all business tables)
 *   - `publicClient`  → public schema (auth/role/project RBAC bridge)
 */

import { createClient } from '@supabase/supabase-js';

import { env } from './env';

/** Business schema client — default for all data stores. */
export const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
  },
  db: {
    schema: env.SUPABASE_SCHEMA,
  },
});

/** Public schema client — auth.users / public.user / public.project lookups. */
export const publicClient = createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, {
  db: {
    schema: 'public',
  },
});
```

### §3. `src/config/index.ts` (barrel)
```ts
/**
 * Config barrel — import everything supabase/env-related from `@/config`.
 *
 * Usage:
 *   import { supabase, publicClient, env } from '@/config';
 */

export { env } from './env';
export { supabase, publicClient } from './supabase';
```

## 🛡️ Guardrails

- **Rule #1 (schema isolation)** — `supabase` client is bound to `env.SUPABASE_SCHEMA` (quizLaa for this family). Never swap its schema at runtime. Cross-schema work goes through `publicClient`, and only for `auth.users` / `public.role` / `public.project`.
- **CONFIG FUNNEL** — `import.meta.env.VITE_*` lives in `env.ts` **ONLY**. Everywhere else imports `env` from the barrel. Do not re-read `import.meta.env` in stores, views, components.
- **Two clients on purpose** — one Supabase JS client = one schema binding. Attempting to call `.schema('public')` on the business client fails silently (returns empty). Use `publicClient` for public-schema work.
- **No service-role in client code** — `.env` holds the anon key only. If a step needs service-role power, route through a server-side API (admin panel RPCs or PHP backend).
- **Fail-fast at boot** — `readEnv` throws if required keys are missing. This is intentional. Do NOT soften to `console.warn`.

## ✅ Verify

```bash
# Grep must show ZERO matches outside src/config/
grep -rn "import.meta.env.VITE_" src/ --exclude-dir=config
# Expected: (empty)
```

Sanity in Vue devtools or a temporary `console.log`:
```ts
import { env, supabase } from '@/config';
console.log(env.SUPABASE_SCHEMA); // → "quizLaa"
console.log(env.PROJECT_ID);      // → "<uuid>"
const { data, error } = await supabase.from('lessons').select('id').limit(1);
console.log(data, error);         // data = [{id: ...}] OR error (if RLS blocks before auth — expected)
```

## ♻️ Rollback
```bash
rm -rf src/config/
# If .env was committed by mistake:
git rm --cached .env
```

## → Next Step
**[03-api-connectivity](../../claude/analyze-schema/skill.md)** — platform-aware `apiClient.ts` + optional `capacitorClient.ts` for native apps.
Parallel: **[05-types-foundry](../../claude/analyze-schema/skill.md)** (TS contracts) can start after this too.
