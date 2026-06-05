---
name: claude-working-progress
description: "Linear task executor for skills/claude — the Vben Admin module builder. 41 numbered micro-tasks: handshake -> build module -> publish. Follow top to bottom, one task at a time. Built for low-effort Claude 4.6 / GPT 5.4."
triggers: ["claude working progress", "build vben module", "ai claude", "new admin module", "create module"]
version: 1.0
date_updated: "2026-05-21"
status: authoritative
---

# 🟦 CLAUDE — WORKING PROGRESS (Vben Admin Module Builder)

**How to run this file:** do ONE task, verify it, then go to the next number. Never skip. Never jump ahead.
Each task tells you exactly what to read — read only that.

## Rules you must follow (read once, keep in mind)

- **Handshake first** — `SHARED_DB_CONTRACT.md` decides schema/bucket/project_id. This skill OWNS the schema (migrations live here).
- **Drift Guard** — every 5 tasks, re-read the user's original request. If you drifted, stop and re-anchor. (`memories/2_governance/DRIFT_GUARD_PROTOCOL.md`)
- **Karpathy** — surgical scope: touch only files the current task names. No drive-by refactors.
- **Locked tables** (`users`, `permissions`, `attachments`) — never alter columns without user approval.
- **Universal table rules** — soft delete (`deleted_at timestamptz`), snake_case columns, UUID PK, timestamps + trigger, RLS, `project_id` FK on every business table. Follow angel-interior pattern exactly.
- **DATABASE.md is source of truth** — any schema change updates it in the same task.
- Code-vault detail lives in [`create-module/skill.md`](create-module/skill.md) — this file points into it; do not duplicate code here.

---

## ⚠️ DATABASE.md SYNC LAW (CRITICAL — READ THIS FIRST)

`DATABASE.md` in the project root is a **live mirror** of the actual Supabase schema. It must be **100% identical** to what is running in the database at all times.

### When AI MUST update DATABASE.md
| Event | Action |
|---|---|
| New table created | Add full SQL block to DATABASE.md + tick ✅ in Migration Index |
| Column added to table | Update that table's SQL block in DATABASE.md |
| Column renamed or removed | Update DATABASE.md + grep codebase for old name |
| RLS policy added or changed | Update the `007_rls.sql` block in DATABASE.md |
| Migration applied to Supabase | Change ⬜ → ✅ in Migration Index |
| Migration rolled back | Change ✅ → ⬜ and restore previous SQL |
| Index added | Add to the table's SQL block |
| Trigger added or changed | Add/update in the table's SQL block |

### DATABASE.md Column Convention (angel-interior pattern)
```
✅ id uuid PRIMARY KEY DEFAULT gen_random_uuid()
✅ project_id uuid NOT NULL REFERENCES public.project(id) ON DELETE RESTRICT   ← every business table
✅ deleted_at timestamptz                                                       ← soft delete (NULL = alive)
✅ status text NOT NULL DEFAULT 'active'                                        ← content tables
✅ sort_order int NOT NULL DEFAULT 0                                            ← sortable tables
✅ created_at timestamptz NOT NULL DEFAULT now()
✅ updated_at timestamptz NOT NULL DEFAULT now()
✅ snake_case column names (no camelCase in project business schema)
✅ JSONB for arrays: images jsonb NOT NULL DEFAULT '[]'::jsonb
✅ Bilingual: title_en text, title_cn text (paired columns)

❌ is_active boolean  →  use status text instead
❌ sort int           →  use sort_order int
❌ deleted boolean    →  use deleted_at timestamptz
❌ camelCase columns  →  snake_case only
❌ FK to public.*     →  only project_id → public.project(id) is allowed
```

### Verify DATABASE.md matches Supabase (run when in doubt)
```sql
-- List all tables in the project schema
SELECT table_name FROM information_schema.tables WHERE table_schema = 'vipbillion' ORDER BY table_name;

-- List all columns for a specific table
SELECT column_name, data_type, column_default, is_nullable
FROM information_schema.columns
WHERE table_schema = 'vipbillion' AND table_name = 'services'
ORDER BY ordinal_position;

-- List indexes
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'vipbillion' ORDER BY tablename, indexname;
```

If the output does not match DATABASE.md → update DATABASE.md immediately before doing anything else.

---

---

## PHASE A — HANDSHAKE (Tasks 1–6)

### Task 1 — Read the DB contract
Do: read the shared contract so schema/bucket/project_id are known.
Read: `../SHARED_DB_CONTRACT.md`
Verify: you can name the schema, bucket, and project_id for this project.
Done? → Task 2

### Task 2 — Confirm the three keys
Do: find the project's env file and confirm schema name, storage bucket, project_id.
File: `apps/web-antd/.env.development.localhost`
Verify: `VITE_SUPABASE_SCHEMA`, `VITE_SUPABASE_STORAGE_BUCKET`, `VITE_PROJECT_ID` all present and match the contract.
Done? → Task 3

### Task 3 — Confirm env files exist
Do: check both env files are present.
Files: `.env.development.localhost` (local), `.env.production` (tunnel).
Verify: both exist; local points to `localhost:54321`, production to the tunnel host.
Done? → Task 4

### Task 4 — Confirm schema ownership
Do: confirm this skill owns the schema (Contract §2 — admin panel = schema owner).
Verify: migrations folder `apps/web-antd/src/sql/migrations/` exists. You WILL write migrations here.
Done? → Task 5

### Task 5 — Read DATABASE.md
Do: read the project's `DATABASE.md` to learn existing tables and the migration index.
File: `<project-root>/DATABASE.md`
Verify: you know the highest existing migration number. If `DATABASE.md` is missing, note it — you will create it at Task 33.
Done? → Task 6

### Task 6 — Get the module spec from the user
Do: confirm module name, field table (Field/Type/Component/Required), FK relationships, money fields, menu placement, image fields.
Read: `create-module/skill.md` → "Pre-Check" section.
Verify: every Pre-Check item is answered. If anything is unclear, ASK before Task 7.
Done? → Task 7

---

## PHASE B — BUILD MODULE (Tasks 7–34)

### Task 7 — Migration: drop statements
Do: create the migration file; write `DROP TABLE IF EXISTS` (children before parent).
File: `apps/web-antd/src/sql/migrations/XXX_{module}_schema.sql` (XXX = highest number + 1)
Read: `create-module/skill.md` → Step 1.
Verify: drop order is child-then-parent.
Done? → Task 8

### Task 8 — Migration: create table + columns
Do: write `CREATE TABLE` with all fields, UUID PK, FK constraints, money `numeric(12,2)`, `isDelete`, `createdAt`, `updatedAt`.
File: same migration file.
Verify: every user-spec field is present; camelCase names.
Done? → Task 9

### Task 9 — Migration: trigger + index + RLS
Do: add the camelCase `updatedAt` trigger, FK indexes, and RLS policies (+ matching `permissions` rows).
File: same migration file.
Verify: `php`/`psql` is not needed yet — just the SQL is complete and re-runnable.
Done? → Task 10

### Task 10 — Storage bucket check (image fields only)
Do: if the module has image/file columns, verify the storage bucket + attachment table exist; create them if missing.
Read: `create-module/skill.md` → Step 1 "If table has image/file path columns".
Verify: bucket exists OR creation SQL added. If no image fields, skip — go straight to Task 11.
Done? → Task 11

### Task 11 — Seed SQL
Do: create the seed file with Malaysian data (Sdn Bhd, +60, .com.my, MY cities); FK via name-JOIN.
File: `apps/web-antd/src/sql/migrations/XXX_{module}_seed.sql`
Verify: all rows reference valid parent records.
Done? → Task 12

### Task 12 — Types file
Do: write the enum, Entity interface, FormValues interface, PageParams, options array.
File: `apps/web-antd/src/types/{module}.ts`
Read: `create-module/skill.md` → Step 3.
Verify: `pnpm tsc` (or editor) shows no type errors in this file.
Done? → Task 13

### Task 13 — Store: CRUD methods
Do: write the Pinia store with `getList`, `getDetail`, `create`, `update`, `softDelete` via `supabase.from('{module}')`.
File: `apps/web-antd/src/stores/{module}.ts`
Read: `create-module/skill.md` → Step 4.
Verify: read ops return empty on error (no throw); write ops throw.
Done? → Task 14

### Task 14 — Store: FK joins + helpers
Do: add FK joins in getList/getDetail (`select('*, parent:parents!parentId(name)')`), flatten FK names, add `fetchOptions()`, status helpers.
File: same store file.
Verify: FK display names are flattened (e.g. `clientName`).
Done? → Task 15

### Task 15 — Update data-refresh.ts
Do: add `{MODULE}_LIST` to TABLE_IDS, add `{module}sVersion` ref + `invalidate{Module}s()`.
File: `apps/web-antd/src/stores/data-refresh.ts`
Verify: the new entries compile.
Done? → Task 16

### Task 16 — Update shared store files
Do: add `export * from './{module}s'` to stores index; add `showDelete{Module}Modal()` to delete-actions.
Files: `stores/index.ts`, `utils/delete-actions.ts`
Verify: both files compile.
Done? → Task 17

### Task 17 — Mock backend: db layer
Do: create the `{module}s-db.ts` wrapper; add interface + generateFn + mockDB entry (Malaysian data).
Files: `apps/backend-mock/utils/{module}s-db.ts`, `apps/backend-mock/utils/mock-db.ts`
Read: `create-module/skill.md` → Step 6.
Verify: mock data is Malaysian.
Done? → Task 18

### Task 18 — Mock backend: API endpoints
Do: create the 5 endpoint files — list, `[id]`, `index.post`, `[id].put`, `[id].delete`.
Folder: `apps/backend-mock/api/{module}s/`
Verify: list has filters + sort + pagination + FK resolution.
Done? → Task 19

### Task 19 — Form: base schema
Do: build the form with `useEntityForm`; ≤3 options → RadioGroup, >3 → Select; money → InputNumber `RM`; textarea autoSize; dates `w-48`.
File: `apps/web-antd/src/views/{module}s/{module}-form.vue`
Read: `create-module/skill.md` → Step 7.
Verify: `formApi` is exposed in `defineExpose`.
Done? → Task 20

### Task 20 — Form: FK ApiSelectCreatable
Do: for each FK field, wire `ApiSelectCreatable` with the parent's create drawer + `__workflow_instantCreate` bridge.
File: same form file.
Verify: every FK select can "+ New" the parent. If no FK fields, skip → Task 21.
Done? → Task 21

### Task 21 — Form: image upload
Do: if image fields exist, add Upload + crop modal OUTSIDE the form schema; wire `__workflow_uploadTargets`.
File: same form file.
Read: `create-module/skill.md` → Step 7 "Image upload fields".
Verify: Upload is above `<Form />`. If no image fields, skip → Task 22.
Done? → Task 22

### Task 22 — Drawers
Do: create the 3 drawers — create, edit, detail.
Folder: `views/{module}s/drawer/`
Verify: detail drawer has `footer: false`.
Done? → Task 23

### Task 23 — List: VxeGrid
Do: build the list with `useVbenVxeGrid`; money/date cell formatters; status cell.
File: `apps/web-antd/src/views/{module}s/{module}-list.vue`
Read: `create-module/skill.md` → Step 9.
Verify: list loads and paginates.
Done? → Task 24

### Task 24 — List: CellFkLink columns
Do: for each FK column add `CellFkLink` (import parent detail drawer, register, handler, `__workflow_fkLinkActions`).
File: same list file.
Verify: FK names render as clickable blue links. If no FK columns, skip → Task 25.
Done? → Task 25

### Task 25 — List: data-refresh watcher
Do: add a `watch` on own version + all parent FK entity versions → re-query the grid.
File: same list file.
Verify: editing a parent refreshes FK names here.
Done? → Task 26

### Task 26 — Detail component
Do: build the detail (dual mode page/drawer) with Descriptions, edit+delete buttons; embed child list if this entity has children.
File: `apps/web-antd/src/views/{module}s/{module}-detail.vue`
Verify: detail renders all fields.
Done? → Task 27

### Task 27 — Parent layer icon (1:N child only)
Do: if this module is a 1:N child, add `lucide:layers` as the first action on the PARENT list + the parent-child top drawer.
Read: `create-module/skill.md` → Step 11.
Verify: layer icon opens the embedded child list. If not a child, skip → Task 28.
Done? → Task 28

### Task 28 — Route module
Do: create/update the route file; list `keepAlive: true`, detail `hideInMenu: true`; correct menu nesting + icon.
File: `apps/web-antd/src/router/routes/modules/{parent}.ts`
Verify: menu shows the module in the right place.
Done? → Task 29

### Task 29 — i18n translations
Do: add all keys to both locale files (title, list, detail, table, form, toolbar, drawer).
Files: `locales/langs/en-US/page.json`, `locales/langs/zh-CN/page.json`
Verify: no missing-key warnings in the UI.
Done? → Task 30

### Task 30 — Workflow test: Type A CRUD
Do: create the standalone CRUD workflow (`query-first` for FK, create/edit/delete steps).
File: `views/workflow-test/configs/{module}-workflows.ts`
Read: `create-module/skill.md` → Step 14 "Type A".
Verify: the CRUD workflow config compiles.
Done? → Task 31

### Task 31 — Workflow test: Type B / C
Do: add Type B (instant, if 1:N child) and Type C (FK link click, if CellFkLink columns).
File: same workflows file.
Verify: only the applicable types are generated. If neither applies, skip → Task 32.
Done? → Task 32

### Task 32 — Register workflows
Do: register all new workflows in the workflow index.
File: `views/workflow-test/configs/index.ts`
Verify: workflows appear in the workflow-test UI list.
Done? → Task 33

### Task 33 — Update the doc-stack
Do: add the new table + migration to `DATABASE.md`; add the entity row to `CROSSWALK.md`.
Files: `<project-root>/DATABASE.md`, `CROSSWALK.md`
Verify: docs and code agree (Contract §4).
Done? → Task 34

### Task 34 — Verification checklist
Do: run the full checklist — compile, menu, list, create, edit, delete, layer icon, workflow run.
Read: `create-module/skill.md` → "Verification Checklist".
Verify: every checklist item passes. Fix before Phase C.
Done? → Task 35

---

## PHASE C — PUBLISH (Tasks 35–41)

### Task 35 — Verify local Supabase healthy
Do: confirm both endpoints respond — `/auth/v1/health` AND `/rest/v1/`.
Verify: both return healthy. `auth = 200` alone is NOT enough (Contract reference / angel-interior lesson).
Done? → Task 36

### Task 36 — Production build
Do: build the admin panel for production.
Command: `pnpm.cmd build:antd` (Windows-safe).
Verify: `apps/web-antd/dist/` is freshly generated, no build errors.
Done? → Task 37

### Task 37 — Bundle hash check
Do: compare the hashed bundle name in local `dist/` against the live site.
Verify: hashes differ → the new build is genuinely newer. If same, the build did not change.
Done? → Task 38

### Task 38 — Cloudflare tunnel
Do: confirm the tunnel proxies the public DB host → `http://127.0.0.1:54321`; `cloudflared` service running.
Read: `vben-local-supabase-cloudflare-publish/SKILL.md` if present.
Verify: the public DB host returns healthy `rest` + `auth` (not 502).
Done? → Task 39

### Task 39 — Deploy
Do: upload the newest `dist.zip` to hosting.
Verify: upload completes; hosting shows the new timestamp.
Done? → Task 40

### Task 40 — Hard-refresh + login test
Do: hard-refresh the live site, log in with the seeded admin account, smoke-test the new module's CRUD.
Verify: login works; module create/edit/delete works live.
Done? → Task 41

### Task 41 — Final report
Do: report what changed, what was verified, what remains uncertain.
Verify: report covers all three (changed / verified / uncertain). Update `STATUS.md` if the project has one.
Done? → ✅ COMPLETE
