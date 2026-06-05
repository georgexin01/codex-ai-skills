---
name: website-04-schema-building
description: "Step 04 — SQL DDL in quizLaa schema: UUID PKs, soft-delete (isDelete + camelCase convention), FK discipline, timestamps, indexes. Rule #1 enforced (no FK out of project schema)."
triggers: ["website schema", "sql tables", "quizLaa schema", "uuid pk", "soft delete", "isDelete", "schema isolation"]
phase: 1-foundation
requires: [website-03-composer-autoload]
unlocks: [website-05-security-lock, website-08-models-layer]
output_format: sql
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 04 — Schema Building (SQL DDL in `quizLaa`)

## 🎯 When to Use
After autoload works (Step 03). Before applying RLS (Step 05).

This step is a **knowledge skill** (SQL + conventions), not a file drop — the actual DDL lives in `apps/web-antd/src/sql/migrations/` on the admin panel side. The website layer reads from these tables; it rarely authors DDL. Use this skill as the reference when a new website-side table must be added (e.g., `agent_leads`, `agent_reviews`, `agent_profiles`).

## ⚠️ Dependencies
- **03-composer-autoload** — the Sovereign engine needs `SUPABASE_SCHEMA=quizLaa` to route DDL consumers correctly.

## 📋 Procedure

1. **Decide the entity list** for the site (e.g., `agent_profiles`, `agent_reviews`, `agent_leads`).
2. **Author DDL** — Code Vault §1 template. UUID PK + timestamps + `isDelete` + FKs inside `quizLaa` only.
3. **Apply via Supabase Studio SQL editor** (or via `apps/web-antd/src/sql/migrations/NN_<name>.sql` and `supabase db reset`).
4. **Index every FK + `isDelete`** — Code Vault §2. Missing indexes destroy list-page performance.
5. **Verify** — Code Vault §4 psql commands.

## 📦 Code Vault

### §1. Table template (canonical quizLaa pattern)
```sql
-- Ensure the project schema exists.
CREATE SCHEMA IF NOT EXISTS "quizLaa";

-- Grant anon + authenticated roles USAGE on the schema (RLS gates rows separately).
GRANT USAGE ON SCHEMA "quizLaa" TO anon, authenticated;

-- Example: agent_profiles (public-facing agent landing page data)
CREATE TABLE "quizLaa"."agent_profiles" (
  "id"           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  "user_id"      uuid        NOT NULL REFERENCES "quizLaa"."users"("id") ON DELETE CASCADE,
  "slug"         text        UNIQUE,
  "title"        text        NOT NULL,
  "tagline"      text,
  "description"  text,
  "company"      text        DEFAULT 'LAA',
  "photo"        text,
  "video_url"    text,
  "phone"        text,
  "email"        text,
  "address"      text,
  "social_links" jsonb       DEFAULT '[]'::jsonb,
  "skills"       jsonb       DEFAULT '[]'::jsonb,
  "services"     jsonb       DEFAULT '[]'::jsonb,
  "achievements" jsonb       DEFAULT '[]'::jsonb,
  "videos"       jsonb       DEFAULT '[]'::jsonb,

  "isDelete"     boolean     NOT NULL DEFAULT false,
  "createdAt"    timestamptz NOT NULL DEFAULT now(),
  "updatedAt"    timestamptz NOT NULL DEFAULT now()
);

-- Example: agent_reviews (1:N testimonials for each agent_profile)
CREATE TABLE "quizLaa"."agent_reviews" (
  "id"                uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  "agent_profile_id"  uuid        NOT NULL REFERENCES "quizLaa"."agent_profiles"("id") ON DELETE CASCADE,
  "reviewer_name"     text        NOT NULL,
  "reviewer_photo"    text,
  "review_text"       text        NOT NULL,
  "rating"            int         NOT NULL CHECK ("rating" BETWEEN 1 AND 5),
  "review_date"       date        DEFAULT current_date,

  "isDelete"          boolean     NOT NULL DEFAULT false,
  "createdAt"         timestamptz NOT NULL DEFAULT now(),
  "updatedAt"         timestamptz NOT NULL DEFAULT now()
);

-- Example: agent_leads (anon-writable contact form target)
CREATE TABLE "quizLaa"."agent_leads" (
  "id"               uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  "agent_profile_id" uuid        NOT NULL REFERENCES "quizLaa"."agent_profiles"("id") ON DELETE CASCADE,
  "name"             text        NOT NULL,
  "email"            text,
  "phone"            text,
  "message"          text,

  "isDelete"         boolean     NOT NULL DEFAULT false,
  "createdAt"        timestamptz NOT NULL DEFAULT now()
);
```

### §2. Indexes (every FK + `isDelete` + any frequently-filtered column)
```sql
CREATE INDEX "idx_agent_profiles_user_id"      ON "quizLaa"."agent_profiles"("user_id");
CREATE INDEX "idx_agent_profiles_isDelete"     ON "quizLaa"."agent_profiles"("isDelete");
CREATE INDEX "idx_agent_profiles_slug"         ON "quizLaa"."agent_profiles"("slug");

CREATE INDEX "idx_agent_reviews_profile_id"    ON "quizLaa"."agent_reviews"("agent_profile_id");
CREATE INDEX "idx_agent_reviews_isDelete"      ON "quizLaa"."agent_reviews"("isDelete");
CREATE INDEX "idx_agent_reviews_review_date"   ON "quizLaa"."agent_reviews"("review_date" DESC);

CREATE INDEX "idx_agent_leads_profile_id"      ON "quizLaa"."agent_leads"("agent_profile_id");
CREATE INDEX "idx_agent_leads_isDelete"        ON "quizLaa"."agent_leads"("isDelete");
CREATE INDEX "idx_agent_leads_createdAt"       ON "quizLaa"."agent_leads"("createdAt" DESC);
```

### §3. `updatedAt` trigger (generic — apply once per updatable table)
```sql
CREATE OR REPLACE FUNCTION "quizLaa".set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW."updatedAt" = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER "trg_agent_profiles_updated_at"
  BEFORE UPDATE ON "quizLaa"."agent_profiles"
  FOR EACH ROW EXECUTE FUNCTION "quizLaa".set_updated_at();

CREATE TRIGGER "trg_agent_reviews_updated_at"
  BEFORE UPDATE ON "quizLaa"."agent_reviews"
  FOR EACH ROW EXECUTE FUNCTION "quizLaa".set_updated_at();
```

### §4. Verify via psql
```bash
# List tables in the project schema
psql "$DATABASE_URL" -c '\dt "quizLaa".*'

# Inspect a specific table (columns, indexes, FKs)
psql "$DATABASE_URL" -c '\d+ "quizLaa"."agent_profiles"'

# Confirm FK integrity — every agent_reviews.agent_profile_id should resolve
psql "$DATABASE_URL" -c '
  SELECT count(*)
  FROM "quizLaa"."agent_reviews" r
  LEFT JOIN "quizLaa"."agent_profiles" p ON p.id = r.agent_profile_id
  WHERE p.id IS NULL;
'
# Expected: 0
```

## 🛡️ Guardrails

- **Rule #1 (schema isolation)** — every FK points INSIDE `quizLaa`. The only permitted cross-schema reference is indirect: `quizLaa.users` ↔ `auth.users` via email (no DB-level FK). NEVER write `REFERENCES public.user(id)`.
- **Casing convention** — `quizLaa.*` columns are camelCase with quoted identifiers: `"isDelete"`, `"userId"`, `"createdAt"`. `public.*` columns are snake_case: `is_delete`, `auth_id`, `project_id`. Mixing them inside the same schema breaks PostgREST query results.
- **Table-name casing is mixed** — `agent_profiles` (snake), `questionAnswers` (camel). Respect what the admin panel already shipped; don't normalize retroactively.
- **UUID PK, always** — `gen_random_uuid()` default. No SERIAL/BIGSERIAL. UUIDs mean the admin panel, webApp, and website can all reference the same row without ID collision.
- **Soft-delete everywhere** — every business table has `"isDelete" boolean NOT NULL DEFAULT false`. Never `DROP` rows from anon-visible tables. Physical deletes happen via admin RPC only.
- **FK ON DELETE CASCADE for dependent rows** — `agent_reviews` cascade from `agent_profiles` because a review can't exist without its agent. For leads, also cascade — orphan leads are noise.
- **`REFERENCES "quizLaa"."users"("id")`** — explicit schema on FK target. Without the schema prefix, PostgreSQL defaults to `public` and the FK silently points at the wrong table.
- **Index every FK + `isDelete`** — list queries filter by both on every request. Missing indexes → seq scans → seconds of latency on realistic data.
- **Indexes on `createdAt DESC` / `review_date DESC`** — if the view orders by date (usually yes), index it descending. Reduces sort overhead.
- **JSONB over TEXT** for structured arrays (`social_links`, `skills`, `services`). The Model's `format()` decodes JSONB via `json_decode` — TEXT would require an extra parse step at every row.
- **Apply DDL via the admin panel's migration system** — `apps/web-antd/src/sql/migrations/NN_<name>.sql`. Do not run DDL ad-hoc in Studio for anything that should live forever; it won't replay on `supabase db reset`.

## ✅ Verify

```bash
# 1. Schema exists
psql "$DATABASE_URL" -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'quizLaa';"
# Expected: quizLaa

# 2. Tables exist
psql "$DATABASE_URL" -c '\dt "quizLaa".*'
# Expected: agent_profiles, agent_reviews, agent_leads (+ users, lessons, questions, etc. from admin side)

# 3. Indexes exist
psql "$DATABASE_URL" -c '\di "quizLaa".*'

# 4. PostgREST schema exposure — from the Sovereign client:
php -r "
  require 'vendor/autoload.php';
  \$api = \Sovereign\supabaseClient();
  \$r = \$api->from('agent_profiles')->select('id')->limit(1)->get();
  var_dump(\$r['status']);  // Expected: int(200)
"
```

## ♻️ Rollback
```sql
-- Reverse FK order: drop leaf tables first
DROP TABLE IF EXISTS "quizLaa"."agent_leads"    CASCADE;
DROP TABLE IF EXISTS "quizLaa"."agent_reviews"  CASCADE;
DROP TABLE IF EXISTS "quizLaa"."agent_profiles" CASCADE;
-- DROP SCHEMA IF EXISTS "quizLaa" CASCADE;  -- only for full reset
```

## → Next Step
**[05-security-lock](../05-security-lock/skill.md)** — enable RLS on each table with the anon-read + anon_insert_access patterns.
