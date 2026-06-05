---
name: seo-tables-planner
description: Plan-first SEO tables protocol for Vben Admin + Supabase projects. Covers schema, permissions, page discovery, route-keyed lookup, custom-detail exclusions, and long-term update workflow for Website/App SEO modules.
triggers: ["seo tables", "seo tables in admin", "seo settings module", "meta title meta description meta keywords", "page seo settings", "plan seo tables"]
phase: 0-planning
requires: []
unlocks: []
inputs: [project_name, project_structure, target_surfaces, custom_meta_routes]
output_format: step_plan
model_hint: gpt-5.3-codex
version: 1.2
---

# SEO Tables Planner

Plan-first protocol for adding or updating a reusable SEO Settings module in a Vben Admin + Supabase project.

## Core SEO Contract

This module stores:

- `page_name`
- `route_path`
- `meta_title`
- `meta_description`
- `meta_keywords`
- `meta_robots`

Required management fields:

- `project_id`
- `project_type`
- `source_surface`
- `sort`
- `published_at`
- `created_at`
- `updated_at`
- `deleted_at`
- `is_auto_generated`

## Authority Rules

- `route_path` is the authoritative website/app runtime lookup key.
- `page_name` is the human label/filter field in admin.
- Do not use `page_name` as the public routing key.

## Admin UX Rules

- `page_name` should normally be read-only in admin
- `route_path` should normally be read-only in admin
- remove required markers from those read-only identity labels
- style those read-only identity inputs as visually disabled/inactive
- `meta_title`, `meta_description`, `meta_keywords` are editable
- `meta_robots` should use a switch:
  - ON -> `index, follow`
  - OFF -> `noindex, nofollow`
- if rows are system-seeded, hide manual create
- hide created-at from the SEO list unless the user explicitly wants it shown
- if ordering is exposed, follow the shared drag-sort plan:
  - default `sort DESC`
  - gap `1000`
  - draggable sequence handle
- in list tables, render robots as a status badge instead of plain text

## Scope Rules

Include:

- public Website pages
- public App pages

Exclude:

- admin panel pages
- authentication-only internal screens
- technical/system-only routes

Exclude from auto-generation if custom per-record metadata already exists:

- any detail page family already using record-specific/custom meta
- any dynamic page family already proven to have its own meta source
- examples may include blog detail pages, product detail pages, article detail pages, testimonial detail pages, listing detail pages, or other record-driven routes

## Dynamic Family Pattern

For route families like `/material/{category}`:

- do not create one SEO row per slug
- create one shared fallback row such as `route_path = '/material/{category}'`
- allow exact-match override rows later if needed

Lookup order:

1. exact `route_path`
2. dynamic family fallback
3. custom-detail exclusion path skips SEO table entirely
4. global site/app fallback

Classification rule:

- record-detail page with its own title/body/excerpt/database-driven custom meta -> exclude from SEO table
- filtered listing family without per-record custom meta -> one shared fallback row
- static page -> one row per page

Important:

- names like `blogs`, `material`, `product`, `testimonial`, or `listing` are only examples
- the real decision rule is whether that page family already has its own custom meta source
- if custom meta already exists for that page family, do not add it to baseline SEO table runtime lookup
- if no custom meta exists and many slugs share one listing/family pattern, use one shared fallback row

## Recommended Table Design

```sql
create table if not exists <schema>.seo_settings (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.project(id) on delete restrict,
  project_type text not null default '',
  source_surface text not null default '',
  page_name text not null,
  route_path text not null default '',
  meta_title text not null default '',
  meta_description text not null default '',
  meta_keywords text not null default '',
  meta_robots text not null default 'noindex, nofollow',
  is_auto_generated boolean not null default true,
  published_at timestamptz,
  sort integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
```

Recommended indexes:

- `(project_id, source_surface, sort, created_at desc)`
- unique active key on `(project_id, source_surface, route_path)` when `route_path` is authoritative

## Permissions and RLS

Do not stop at table creation alone. Minimum working stack:

1. table
2. trigger
3. RLS policies
4. SQL grants
5. permission seed rows

Do not assume a backend endpoint removes the need for anon/public table access.

If the website or app still reads Supabase/PostgREST using an anon key under the hood,
the minimum working stack becomes:

1. table
2. trigger
3. RLS policies
4. SQL grants
5. permission seed rows
6. anon/public read policy when the public surface reads through anon REST

Practical failure rules:

- empty admin rows can come from missing `permissions` rows even when data exists
- empty public SEO can come from missing anon policy or missing table grants
- working RLS alone is not enough

Reusable SQL checklist for future SEO modules:

```sql
-- Authenticated CRUD RLS (shape only; adapt helper functions per project)
CREATE POLICY seo_settings_select_auth ON <schema>.seo_settings
FOR SELECT TO authenticated
USING (...);

CREATE POLICY seo_settings_insert ON <schema>.seo_settings
FOR INSERT TO authenticated
WITH CHECK (...);

CREATE POLICY seo_settings_update ON <schema>.seo_settings
FOR UPDATE TO authenticated
USING (...)
WITH CHECK (...);

CREATE POLICY seo_settings_delete ON <schema>.seo_settings
FOR DELETE TO authenticated
USING (...);

-- Permission seed rows
INSERT INTO <schema>.permissions ("roleId", resource, action, scope, "isDelete")
VALUES
  (..., 'seo_settings', 'create', 'all', false),
  (..., 'seo_settings', 'read',   'all', false),
  (..., 'seo_settings', 'update', 'all', false),
  (..., 'seo_settings', 'delete', 'all', false)
ON CONFLICT DO NOTHING;

-- Public/anon read policy when website/app reads through anon REST
DROP POLICY IF EXISTS seo_settings_select_anon ON <schema>.seo_settings;
CREATE POLICY seo_settings_select_anon ON <schema>.seo_settings
FOR SELECT TO anon
USING (published_at IS NOT NULL AND deleted_at IS NULL);

-- Explicit table grants
GRANT SELECT ON <schema>.seo_settings TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON <schema>.seo_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON <schema>.seo_settings TO service_role;
```

Grant rule:

- schema-wide grants created before a new table do not backfill that table
- future SEO migrations must include explicit grants for the SEO table itself

## Discovery Pass

Before building or updating:

1. detect project type from runtime + route structure
2. inventory all public Website/App routes
3. separate static pages, dynamic families, and custom-detail pages
4. mark routes that need shared fallback rows
5. confirm keyword strategy source
6. confirm whether rows are one-time seeded or sync-managed
7. inspect project SEO docs first
8. inspect live admin + website SEO files before rewriting the contract

## Auto-Generation Strategy

For each included page:

- `page_name` from route label
- `route_path` from the public route map
- `meta_title` = page name + project/site name
- `meta_description` = derived from page content/intent
- `meta_keywords` = shared keyword bank + page-specific additions
- `meta_robots` = `index, follow` unless intentionally hidden
- `project_type` = detected project type
- `sort` = stable display order using the shared `1000, 2000, 3000...` pattern

Never overwrite user-customized SEO blindly.

## Angel Current Contract Reference

When this skill is used inside `angel-interior`, the currently verified SEO contract is:

- `route_path` is the runtime lookup key
- `page_name` is the admin label/filter only
- create is hidden in admin
- sort stays active and follows the shared drag-sort pattern
- `meta_robots` is switch-backed: `index, follow` or `noindex, nofollow`
- excluded/custom page families are decided by whether they already have record-driven custom meta
- shared fallback rows are used for dynamic listing families that do not have per-record custom meta
- in Angel today, `/blogs/{slug}` is excluded and `/material/{category}` is a shared fallback row, but those names are project examples only
- the website PHP layer assigns SEO values directly inside `initData.php` scope
- `$GLOBALS` writes alone are not reliable for the router/include pattern

Project-first audit order for Angel:

1. `SEO_TABLES_PLAN.md`
2. `STATUS.md`
3. `DATABASE.md`
4. admin:
   - `apps/web-antd/src/stores/seo.ts`
   - `apps/web-antd/src/types/seo.ts`
   - `apps/web-antd/src/views/seo/seo-list.vue`
   - `apps/web-antd/src/views/seo/seo-form.vue`
   - migrations `079` to `085`
5. website:
   - `api/Models/SeoModel.php`
   - `api/Controllers/SeoController.php`
   - `api/v1/seo.php`
   - `lib/seoData.php`
   - `lib/initData.php`

## Update Workflow

When the user later says:

- `update seo tables`
- `update seo tables in admin`
- `refresh seo settings`

the AI should:

1. read the project SEO markdown first
2. re-scan public Website/App pages
3. compare current route inventory vs stored `route_path`
4. add newly discovered pages
5. preserve edited rows
6. flag removed routes for review instead of hard-deleting

## Output Expectations

When triggered, produce:

- a step-by-step implementation/update plan
- schema proposal
- permissions/RLS checklist
- route discovery strategy
- auto-generation strategy
- lookup-key and exclusion rules
- update-safe sync strategy
