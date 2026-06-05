---
name: clean-module
description: "Clean all project-specific modules from a copied Vben Admin panel, leaving only shared infrastructure. Run BEFORE building new modules for a new project."
triggers: ["clean modules", "remove angel modules", "clean admin", "clear modules", "reset admin modules", "clean old modules", "remove old modules"]
phase: 0-pre-build
requires: []
unlocks: [create-module]
version: 1.0
status: authoritative
last_updated: "2026-06-04"
---

# Clean Module (clean-module)

Remove all project-specific modules from a copied Vben Admin (e.g. when reusing angel-interior as a base for a new project). Leaves shared infrastructure intact. Run this BEFORE building any new modules.

## 🎯 When to Use
- You have copied admin-panel-angel (or any previous project) to create a new admin panel
- You need to remove all the previous project's modules (views, stores, routes, types, locales)
- You want a clean slate before building new project modules

## ⚠️ What to Keep (NEVER delete these)
```
src/views/_core/            ← auth, profile, fallback pages
src/views/attachments/      ← image album (reusable across projects)
src/views/users/            ← admin user management
src/views/workflow-test/    ← workflow test framework
src/stores/attachments.ts
src/stores/auth.ts
src/stores/users.ts
src/stores/workflow-test.ts
src/stores/types.ts
src/router/routes/modules/attachments.ts
src/router/routes/modules/users.ts
src/router/routes/modules/workflow-test.ts
src/types/attachments.ts
src/types/users.ts
src/types/workflow-test.ts
src/api/supabase.ts         ← Supabase client (keep, update env vars)
src/composables/            ← ALL (useEntityForm, useCreateDrawer, useEditDrawer, etc.)
src/components/             ← ALL (image-crop-modal, etc.)
src/adapter/                ← ALL (VXE table adapters)
src/locales/                ← base keys (auth, common, modal, table, users, attachments, imageProcessor, workflowTest)
```

## 📋 Procedure

### Step 1 — Identify angel/old modules
List what exists:
```powershell
ls "apps\web-antd\src\views"
ls "apps\web-antd\src\stores"
ls "apps\web-antd\src\router\routes\modules"
ls "apps\web-antd\src\types"
```

Note which are project-specific vs shared infrastructure.

### Step 2 — Clean stores/index.ts
Remove exports for all old project stores. Keep:
```ts
// Only keep shared infrastructure + new project modules
export * from './attachments';
export * from './auth';
export * from './data-refresh';
export * from './types';
export * from './users';
export * from './workflow-test';
```

### Step 3 — Rewrite data-refresh.ts
Remove all old project version refs. Keep only infrastructure (`attachmentsVersion`, `usersVersion`).
Add new project TABLE_IDS and version refs for all planned new modules.

```ts
export const TABLE_IDS = {
  // ── New project modules ────────────────────────────────────
  NEW_MODULE_LIST: 'new-module-list',
  // ── Shared infrastructure ──────────────────────────────────
  ATTACHMENT_LIST: 'attachment-list',
  USER_LIST: 'user-list',
} as const;
```

### Step 4 — Delete old module files (PowerShell)
```powershell
$base = "apps\web-antd\src"
$oldModules = @("awards","blog","contact","material","seo","sketchup","slideshow")

# Views
foreach ($f in $oldModules) {
  if (Test-Path "$base\views\$f") { Remove-Item -Recurse -Force "$base\views\$f" }
}
# Stores
foreach ($f in $oldModules) {
  $path = "$base\stores\$f.ts"
  if (Test-Path $path) { Remove-Item -Force $path }
}
# Types
foreach ($f in $oldModules) {
  $path = "$base\types\$f.ts"  # note: singular type name
  if (Test-Path $path) { Remove-Item -Force $path }
}
# Routes
foreach ($f in $oldModules) {
  $path = "$base\router\routes\modules\$f.ts"
  if (Test-Path $path) { Remove-Item -Force $path }
}
```

### Step 5 — Rewrite locale files
Clean `en-US/page.json` and `zh-CN/page.json`:
- Keep base keys: `auth`, `common`, `modal`, `table`, `users`, `attachments`, `imageProcessor`, `workflowTest`
- Remove all old project module keys
- Add new project module keys (currencies, services, vehicles, etc.)

### Step 6 — Update base .env files
```
VITE_APP_TITLE=<New Project> Admin
VITE_SUPABASE_SCHEMA=<new_schema>
VITE_SUPABASE_STORAGE_BUCKET=<new_bucket>
VITE_PROJECT_ID=<confirmed_uuid>
```

### Step 7 — Update CLAUDE.md in admin folder
Replace old project context with new project:
- Project name, schema, paired website path
- Build order for new modules
- DB access pattern reminder
- Reference folder (READ-ONLY)

### Step 8 — Verify clean state
```powershell
ls "apps\web-antd\src\views"
# Expect: _core, attachments, users, workflow-test, (+ new modules)

ls "apps\web-antd\src\stores"
# Expect: attachments.ts, auth.ts, data-refresh.ts, index.ts, types.ts, users.ts, workflow-test.ts, (+ new stores)

ls "apps\web-antd\src\router\routes\modules"
# Expect: attachments.ts, users.ts, workflow-test.ts, (+ new routes)
```

### Step 9 — Try TypeScript compile
```bash
pnpm tsc --noEmit
```
Or just run dev and check terminal for errors:
```bash
pnpm dev:local
```
Fix any remaining import errors from deleted modules.

## 🛡️ Guardrails
- **Never delete `_core/`** — login, profile, and 404 pages live here
- **Never delete `composables/`** — `useEntityForm`, `useCreateDrawer`, etc. are shared
- **Never delete `components/`** — `image-crop-modal.vue`, etc. are shared
- **Never delete `adapter/`** — VXE table adapters, form adapters are shared
- **Angel modules as reference** — the original angel project at `angel-interior/` is READ-ONLY reference; do not clean it, only clean the NEW project's admin folder

## ✅ Verify Complete
- [ ] `src/views/` shows only `_core`, `attachments`, `users`, `workflow-test`, new modules
- [ ] `src/stores/index.ts` exports only infrastructure + new modules
- [ ] `src/stores/data-refresh.ts` has only new project TABLE_IDS and versions
- [ ] `src/locales/` page.json has only base + new project keys
- [ ] `.env` files updated with new project values
- [ ] `CLAUDE.md` in admin folder updated with new project context
- [ ] TypeScript compiles without errors

## 🔗 Next Step
→ `create-module/skill.md` — build your first module (start with simplest: Currencies)
