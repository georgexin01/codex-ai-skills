---
name: starting-point
description: "New project bootstrap protocol - PHP website + Vben Admin + Docker Supabase. Full setup flow from customer brief to running dev environment."
triggers: ["new project", "starting point", "bootstrap project", "start new project", "project setup", "ai starting point"]
phase: 0-bootstrap
requires: []
unlocks: [claude-website/01-config-generation, claude/create-module]
output_format: mixed
version: 1.1
status: authoritative
last_updated: "2026-06-04"
---

# Starting Point - New Project Bootstrap Protocol

## When to Use
At the very beginning of any new project with this stack:
- PHP website (Sovereign PHP + Supabase)
- Vben Admin 5.x
- Shared Docker Supabase database

## What AI Must Read First
When the user says "new project" or provides project info:
1. Read the customer brief - `information.md` or equivalent raw brief
2. Read `.codex` startup route - `00_PULSE.md`
3. Read build skills - `claude/WORKING_PROGRESS.md` for admin + `claude-website/WORKING_PROGRESS.md` for website
4. Read the shared DB contract - `skills/SHARED_DB_CONTRACT.md`
5. Read reference projects if available

## Workspace Structure
Every project root should contain:
```text
[ProjectRoot]/
|- admin-[name]/
|- website-[name]/
|- information.md
|- PROJECT_INFO.md
|- PROJECT_RESEARCH.md
|- PROJECT_KNOWLEDGE.md
|- DATABASE.md
|- CROSSWALK.md
|- WORKSPACE.md
\- STATUS.md
```

## Procedure

### Step 1 - Read and Translate Customer Brief
1. Read `information.md`
2. Extract modules, business rules, DB entities, URL structure, bilingual needs
3. Separate confirmed requirements from inferred structure
4. Write a first-pass relationship map:
   - table -> parent table
   - table -> child tables
   - FK-backed relations
   - logical text-match relations like `vehicles.car_type` -> `pricing_rules.car_type`

### Step 2 - Classify the Project Shape
Answer:
- Is this PHP website + Vben admin?
- What is the schema name?
- What is the storage bucket name?
- What language support is needed?
- Is there a reference project to copy from?

### Step 2.5 - DATABASE.md Sync Law
`DATABASE.md` is a live mirror of Supabase and must be updated in the same task as any DDL change.

Preferred conventions for this ecosystem:
- project-scoped business tables
- UUID primary keys
- timestamps
- soft delete
- bilingual pairs only where website-visible content needs them

### Step 2.6 - Relationship And Coverage Law
- Before building modules, AI must write:
  - a table relationship map
  - an admin coverage audit (`all DB tables` vs `current admin views/routes`)
- If a table exists in `DATABASE.md` but has no admin module, record it immediately in `STATUS.md` and `CROSSWALK.md`.
- If website routes already contain real public-facing content, prefer that copy/structure as seed input instead of generic placeholders.

### Step 3 - Create Root Docs
Create and fill:
- `PROJECT_INFO.md`
- `PROJECT_RESEARCH.md`
- `PROJECT_KNOWLEDGE.md`
- `DATABASE.md`
- `CROSSWALK.md`
- `WORKSPACE.md`
- `STATUS.md`

Minimum required content:
- `DATABASE.md` must include a relationship section
- `CROSSWALK.md` must include an admin coverage note for any missing module
- `STATUS.md` must state which tables are not yet represented in the admin UI

### Step 4 - Set Up Admin Panel
```powershell
cd admin-[name]
pnpm.cmd install
pnpm.cmd run dev:local
```

Then clean and rebrand — **every copied panel has Angel branding that must be replaced**:

| File | What to change |
|---|---|
| `packages/@core/preferences/src/config.ts` | `name:` project name, `companyName:`, `date:` year, `defaultHomePath:` → first useful module |
| `packages/effects/layouts/src/authentication/authentication.vue` | `appName: 'Warehouse Management System'` → new project name |
| `apps/web-antd/src/utils/upload.ts` | `BUCKET_NAME` + `SCHEMA` fallback → new values |
| `apps/web-antd/src/views/_core/authentication/login.vue` | Pre-fill `userMap.admin` with dev admin email + password |
| All `.env*` files | `VITE_APP_TITLE`, `VITE_SUPABASE_SCHEMA`, `VITE_SUPABASE_STORAGE_BUCKET`, `VITE_PROJECT_ID` |

Also clean old modules: `skills/clean-module/skill.md`

Then run a copied-panel audit:
- menu order
- project branding
- login dev credentials
- schema owner env values
- missing module routes for tables already present in `DATABASE.md`

### Step 4.5 - Create Admin User + Link to Project
After schema + migrations are applied:

```sql
-- 1. Create auth user directly in psql (for local dev)
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at, confirmation_token,
  raw_app_meta_data, raw_user_meta_data, is_super_admin)
VALUES (
  gen_random_uuid(), '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'admin@<project>.com',
  crypt('<password>', gen_salt('bf')),
  now(), now(), now(), '',
  '{"provider":"email","providers":["email"]}',
  -- IMPORTANT: active_project_id tells custom_access_token_hook which project
  '{"active_project_id":"<project-uuid>"}',
  false
) RETURNING id, email;

-- 2. Link to public."user"
INSERT INTO public."user" (auth_id, project_id, role_id, name, email, status)
SELECT '<auth-id-from-above>', p.id, r.id, '<Admin Name>', 'admin@<project>.com', 'active'
FROM public.project p JOIN public.role r ON r.project_id = p.id AND r.name = 'admin'
WHERE p.schema_name = '<schema_name>';
```

**Project ID rule — CRITICAL:**
- Each project gets its OWN unique UUID from `public.project` (auto-generated by `gen_random_uuid()`)
- NEVER reuse a UUID from another project (angel: `b3e45339...`, wms: `5b65e9f4...`, etc.)
- Get the real UUID AFTER applying migration 051 (permissions_seed): `SELECT id FROM public.project WHERE schema_name = '<schema>';`
- Update ALL `.env*` files with this UUID before testing login

### Step 5 - Create Supabase Schema
Create the project schema and align the shared DB contract values across admin and website.

### Step 6 - Website PHP Structure
Follow `claude-website/01-config-generation`.
Create the `api/` folder tree and copy only the reusable Sovereign core patterns needed.

If the website already has meaningful template content:
- harvest real service names, pricing rows, attractions, contact info, and insight copy
- create a website-alignment seed migration for local Supabase
- avoid leaving the admin seeded with unrelated placeholder/demo content

### Step 7 - Verify Both Apps Run
```powershell
cd admin-[name]
pnpm.cmd run dev:local

cd website-[name]
php -S 127.0.0.1:8000 index.php
```

### Step 7.5 - Starting-Point Exit Criteria
Starting-point is NOT complete until all of these are true:
- root docs exist and match the current DB/app structure
- `DATABASE.md` includes relationship truth
- `CROSSWALK.md` includes schema-to-admin coverage truth
- missing admin modules are explicitly listed
- local seed data is at least directionally aligned with the current website look/copy
- next handoff target is clearly `skills/claude/WORKING_PROGRESS.md`

## Guardrails

### Database
- business data stays in the project schema
- schema owner and consumer must follow `SHARED_DB_CONTRACT.md`
- website-facing bilingual content is conditional, not universal

### Admin Panel
- Vben admin is the schema owner in this common project shape
- prefer `skills/claude/WORKING_PROGRESS.md` for real admin/module work

### Website PHP
- `.env` belongs under `api/core/`
- schema reads must stay project-scoped
- use anon-safe public patterns only

### References
- reference projects are read-only

## Router - AI Navigation Map

| Situation / Trigger | Go To |
|---|---|
| New project starts, user gives brief | `skills/starting-point/skill.md` |
| Setting up PHP website API layer | `skills/claude-website/WORKING_PROGRESS.md` |
| Setting up Vben admin panel | `skills/claude/WORKING_PROGRESS.md` |
| Writing SQL migrations / DB schema | `skills/claude/generate-supabase-schema/skill.md` |
| Writing RLS policies | `skills/claude/supabase-rls-rbac-design.md` |
| Building Pinia stores in admin | `skills/claude/generate-store/skill.md` |
| Building admin CRUD views | `skills/claude/generate-views/skill.md` |
| Building admin route definitions | `skills/claude/generate-route/skill.md` |
| i18n / bilingual in admin | `skills/claude/generate-i18n/skill.md` |
| Cleaning copied admin modules | `skills/clean-module/skill.md` |
| SEO tables needed | `skills/claude/seo-tables-planner/skill.md` |
| Project knowledge files | `PROJECT_INFO.md` -> `PROJECT_RESEARCH.md` -> `PROJECT_KNOWLEDGE.md` -> `STATUS.md` -> `DATABASE.md` -> `CROSSWALK.md` |
| DB contract between admin + website | `skills/SHARED_DB_CONTRACT.md` |

### Auto-Trigger Rules
- user says "new project" -> load this skill
- user says "build module X" -> check `CROSSWALK.md`, then route to the correct admin or website skill
- any session start in a live project -> read `STATUS.md` -> `DATABASE.md` -> `CROSSWALK.md`
- any DB change -> update `DATABASE.md` in the same task
- after bootstrap truth is stable -> continue admin build work in `skills/claude/WORKING_PROGRESS.md`

## Skill Chain
1. `claude-website/01-config-generation`
2. `claude-website/07-rest-client`
3. `claude-website/08-models-layer`
4. `claude-website/09-controllers-layer`
5. `claude-website/11-router-v1-endpoints`
6. `claude/generate-supabase-schema`
7. `claude/generate-store`
8. `claude/generate-views`
9. `claude/generate-route`
10. `claude/generate-i18n`

## Verify Bootstrap Complete
- root docs created
- admin runs locally
- website runs locally
- shared DB contract aligned
- `STATUS.md` reflects current phase and next step
