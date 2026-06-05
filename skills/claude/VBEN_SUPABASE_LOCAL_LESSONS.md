---
name: vben-supabase-local-lessons
description: "Field-tested gotchas + pre-flight checklist for Vben Admin on LOCAL Docker Supabase. Harvested from the angel-interior build. Complements create-module / generate-supabase-schema — read before any local-DB module work."
triggers: ["local supabase", "docker supabase", "vben local", "psql docker", "rls 403", "storage 404", "formapi not found", "seed from website"]
phase: reference
version: 1.0
status: authoritative
last_updated: "2026-05-20"
source_project: angel-interior
---

# Vben + Supabase — Local Docker Lessons

Field lessons from the **angel-interior** admin build. The `create-module` and
`generate-supabase-schema` skills assume SQL is pasted into Studio or applied via
remote MCP/SSH. This file covers the gaps that only surface on a **local Docker
Supabase** stack with live data. Every item here cost real debugging time — treat
as an additive pre-flight, not a replacement.

> Append-only. New lessons go at the bottom of the matching section. Never delete.

---

## 1. Safe SQL apply for LOCAL Docker (never use `psql -c`)

The skills say "paste into Studio SQL Editor". For repeatable, reviewable local
work use the **file → docker cp → psql -f** pattern instead:

```bash
# 1. Write SQL to a file (so it is reviewable + re-runnable)
#    e.g. fix_contact_rls.sql in project root, or src/sql/migrations/NNN_*.sql

# 2. Copy into the DB container
docker cp fix_contact_rls.sql supabase_db_local-supabase:/tmp/fix.sql

# 3. Execute the FILE (-f), never inline (-c)
docker exec supabase_db_local-supabase psql -U postgres -d postgres -f /tmp/fix.sql
```

**Why never `-c`:** passing SQL inline through `psql -c "..."` on Windows/PowerShell
mangles double-quoted identifiers (`"isDelete"`, `"roleId"`) — the quotes get
stripped or shell-escaped, and camelCase columns silently fail. `-f` on a real
file is byte-exact.

**Container names** are stack-specific — discover them, do not assume:
```bash
docker ps --format "{{.Names}}" | grep supabase
# common: supabase_db_local-supabase, supabase_storage_local-supabase
```

---

## 2. `formApi` MUST be in each form component's `defineExpose`

`useEntityForm` returns `formApi` and registers the global `window.__workflow_formApi`
bridge. That is **not enough**. `useCreateDrawer` / `useEditDrawer` read the form via
`(formRef.value as any)?.formApi` — so every form `.vue` component must explicitly
re-expose it:

```ts
const { Form, formApi, focus, isDirty, resetForm, submitForm, watchEntity } =
  useEntityForm(/* ... */);

defineExpose({ focus, formApi, isDirty, resetForm, submitForm });
//                    ^^^^^^^ — required, or drawer logs "formApi not found after 10s"
```

**Why it bites:** drawers keep forms mounted via `v-show`. `onMounted` does not
re-fire on re-open, so a missing expose is invisible until a workflow-test or a
drawer-driven submit needs the API. Add `formApi` to `defineExpose` in **every**
form component as a standing rule.

---

## 3. A working INSERT needs TWO grants: RLS policy AND a permissions row

A 403 / "new row violates row-level security policy" on an authenticated INSERT
is usually **not** one missing thing — it is two:

1. **RLS policy** — `FOR INSERT` policy on the table:
   ```sql
   CREATE POLICY contact_submissions_insert
     ON angelinterior.contact_submissions FOR INSERT TO authenticated
     WITH CHECK (
       angelinterior.is_current_project(project_id)
       AND angelinterior.authorize('contact_submissions', 'create')
     );
   ```
2. **Permissions row** — `authorize()` checks the `permissions` table, so each role
   that needs the action must have a row:
   ```sql
   INSERT INTO angelinterior.permissions ("roleId", resource, action, scope, "isDelete")
   VALUES
     ('<super_admin_role_id>', 'contact_submissions', 'create', 'all', false),
     ('<admin_role_id>',       'contact_submissions', 'create', 'all', false)
   ON CONFLICT DO NOTHING;
   ```

**Pre-flight:** for every resource × every action (create/read/update/delete), confirm
BOTH exist. The skills generate the policy; they do not always seed the matching
permissions rows. Missing `create` rows are the most common cause — seeds often grant
read/update/delete but skip create.

---

## 4. Storage paths must NOT start with `/` (the `//` bug)

`getStorageUrl()` builds `${supabaseUrl}${STORAGE_PUBLIC_PREFIX}${path}` where the
prefix already ends in `/`. A stored path with a leading slash produces
`…/public/bucket//uploads/...` → 404.

**Rule:** store relative paths with **no leading slash** — `uploads/x/y.jpg`,
never `/uploads/x/y.jpg`.

**Corrective migration** if bad data already exists:
```sql
UPDATE angelinterior.material_resources
SET image_path = ltrim(image_path, '/') WHERE image_path LIKE '/%';
-- repeat per image/cover column on every content table
```

When seeding from a website whose paths begin with `/` (e.g. `/uploads/...`), strip
the slash at generation time.

---

## 5. Local storage HTTP upload needs the REAL service-role key

Uploading files straight to local Docker storage over HTTP
(`POST /storage/v1/object/<bucket>/<path>`) with the well-known demo service key
fails with **"signature verification failed"** — the local stack was booted with a
different JWT secret.

Get the real key from the storage container's environment:
```bash
docker exec supabase_storage_local-supabase printenv | grep -i service
# or SERVICE_KEY / SERVICE_ROLE / ANON_KEY
```
Use `x-upsert: true` to make re-runs idempotent. (In-app uploads via the
`supabase-js` client are unaffected — they use the session token.)

---

## 6. Corrective-migration discipline (live data ≠ fresh scaffold)

`create-module` Step 1 says *"always DROP first so the migration can be re-run"*.
That is correct only for a **fresh** table. Once a table holds real data:

- **Never** `DROP TABLE` / rewrite an applied migration. Add a **new numbered**
  corrective migration (`048_…remove_categories`, `050_…remove_status`, …).
- Old migrations are immutable history. STATUS.md / change-logs explain why a later
  migration overrides an earlier shape.
- Seed re-runs use `DELETE FROM t WHERE project_id = '<id>'` then `INSERT` — scoped,
  never `TRUNCATE`.

**Numbering guard:** before picking the next number, check the highest existing one —
`ls migrations/ | sort | tail -1`. The angel-interior folder ended up with duplicate
`023`/`051`/`053` files because numbers were chosen blind under parallel work. Either
verify-then-increment, or use a timestamp prefix (`YYYYMMDDHHMM_`).

---

## 7. Seed-from-business-truth workflow

When a project has an authoritative non-DB source (a PHP site, a spreadsheet, a
filesystem of assets), seed from it instead of inventing data:

1. **Locate the source of truth** — hardcoded arrays (`lib/database.php` `$blogs`,
   `$rbzPacks`), or a filesystem scan (`uploads/resource/small/**`).
2. **Generate SQL programmatically** — a small Node script that reads the source and
   emits one `NNN_seed_*.sql` per table. Do not hand-type hundreds of rows.
3. **Idempotent shape** — `DELETE FROM t WHERE project_id = '<id>'` then `INSERT … VALUES …`.
4. **Strip leading slashes** from any path harvested from a web source (see §4).
5. **Upload the matching assets** to storage so admin previews resolve (see §5).
6. **Match count + items exactly** to the live site when the user asks for parity.

---

## 8. Governance patterns worth reusing per project

These came from angel-interior's root docs and saved significant re-entry time:

- **`STATUS.md` = single canonical handoff** — current state, what works, exact next
  task, locked rules, blockers. Any AI reads it first; it overrides stale docs.
- **Triple-sync rule** — a DB change updates `DATABASE.md` + `TABLE_STRUCTURE.md` +
  `DATABASE_MARKMAP.md` in the *same* task. Markmap is a pure mirror of DATABASE.md.
- **Locked-tables contract** — core tables (`users`, `permissions`, `attachments`)
  are append-only: never drop/rename columns, never change types/checks, always keep
  `isDelete` + `createdAt` + `updatedAt` + the `updatedAt` trigger. A migration that
  touches them updates the locked-structure doc in the same task.
- **3-folder workspace** — active build / read-only reference / business-truth source.
  Only the active folder is ever edited.

---

## 9. Design simplifications that worked (offer as options, not defaults)

angel-interior deliberately removed complexity. Offer these when a new content module
is over-engineered:

- **Publish via `published_at`**, not a `status` enum — "published" =
  `published_at IS NOT NULL AND deleted_at IS NULL`. Auto-set `published_at` on create.
- **No `slug`** — UUID routing only; nothing to keep unique or migrate.
- **No `media_assets` table** — an `attachments` registry + plain URL/path string
  columns on content tables (path-string link, no FK) is enough.
- **`sort` visible only where reorder matters** (resource pages), hidden elsewhere.
- **Drop `cta_label`-style fields** when the button text can be hardcoded on the frontend.

---

## Pre-Flight Checklist (run before local module work)

- [ ] Container names discovered (`docker ps | grep supabase`), not assumed
- [ ] SQL applied via file → `docker cp` → `psql -f` (never `-c`)
- [ ] Every form `.vue` has `formApi` in `defineExpose`
- [ ] Every resource×action has BOTH an RLS policy AND a `permissions` row (esp. `create`)
- [ ] All stored image paths have NO leading slash
- [ ] Next migration number verified against the highest existing file
- [ ] Live-data tables get corrective ALTER migrations, never DROP+CREATE
- [ ] Seed data generated from the business-truth source, not invented
- [ ] DB change → DATABASE.md + TABLE_STRUCTURE.md + DATABASE_MARKMAP.md all updated
