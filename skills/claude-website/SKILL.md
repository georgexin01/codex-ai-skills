---
name: claude-website
description: "V7.1 Sovereign PHP + Supabase REST orchestrator - 14-step pyramid for building a Sovereign\\ namespaced backend API. Each step is a self-sufficient code vault (copy-paste ready). No external template folders required."
triggers: ["claude website", "php supabase", "sovereign rest", "sovereign query", "psr-4", "composer autoload", "crud engine", "agent landing", "new website module", "claude-website"]
phase: 0-orchestrator
version: 7.1
status: authoritative
last_updated: "2026-06-04"
---

# `claude-website` - Sovereign PHP + Supabase REST Protocol V7.1

> **To BUILD, use the linear executor: [`WORKING_PROGRESS.md`](WORKING_PROGRESS.md)** - 45 numbered micro-tasks (handshake -> foundation -> engine -> endpoints -> publish). This `SKILL.md` plus the numbered step folders are the code-vault reference it points into.
> **DB handshake** shared with `claude` + `claude-app`: [`../SHARED_DB_CONTRACT.md`](../SHARED_DB_CONTRACT.md). If a sibling admin panel owns the schema, this skill consumes it.

## When to Use

Initializing or refactoring a Sovereign PHP backend (public landing pages, agent profiles, reviews, lead capture). Use this as the authoritative orchestrator for the **14-Step PHP API Lifecycle**.

This skill is self-sufficient - every step contains its own copy-paste code vault. The reference template `website-BE/` is no longer required.

## SEO Module Cooperation

When the user asks for:

- `seo tables`
- `seo tables in admin`
- `seo settings module`
- page-level `meta title / meta description / meta keywords`

do not jump straight into implementation. First coordinate with:

- [`../claude/seo-tables-planner/skill.md`](../claude/seo-tables-planner/skill.md)

Use that planner to:

- classify project type
- inventory Website/App public pages
- exclude dynamic routes that already use record-specific meta
- design the SEO table / permissions / auto-seed strategy
- keep `route_path` as the authoritative runtime lookup key
- treat `page_name` as the read-only admin label/filter
- align SEO ordering to the shared drag-sort pattern when sort is exposed in admin
- prefer robots as a switch-backed field storing `index, follow` or `noindex, nofollow`

Then return to `claude-website` for the PHP website-facing integration pieces.

Website-side SEO implementation rules:

- read the project SEO truth docs first:
  - `SEO_TABLES_PLAN.md`
  - `STATUS.md`
  - `DATABASE.md`
- resolve SEO rows by `route_path`, not `page_name`
- allow exact-match rows first, then shared dynamic-family fallback rows
- decide exclusion by meta ownership, not by route naming:
  - any page family already using record-specific/custom meta stays outside SEO table lookup
  - names like blog/product/testimonial/listing are examples only
- assign resolved SEO variables directly into template scope before rendering
- for the Angel router/include pattern, do not rely on `$GLOBALS` writes alone
- treat SEO table API response as backend-owned truth, not hardcoded defaults
- if PHP reads Supabase/PostgREST with the anon key, verify:
  - anon SELECT policy
  - explicit table grants
  - populated `published_at`
- future SEO module implementations must include these SQL artifacts explicitly:
  - authenticated CRUD RLS
  - `seo_settings` permission seed rows
  - anon SELECT policy when public reads use anon REST
  - explicit grants for `anon`, `authenticated`, and `service_role`
- if the published admin SEO table appears empty, check:
  - grants on `seo_settings`
  - `angelinterior.permissions` rows for `seo_settings`
  - matching `project_id`
  - `deleted_at` / `published_at`

## Folder Anchors

The website `api/` layer has six load-bearing folders/files. Every step below anchors to one of them:

| `api/` Folder | Role | Owning Step |
|---|---|---|
| `api/core/` | `SupabaseClient.php`, `SovereignQuery.php`, `.env` loader | **07** + env in **01** |
| `api/Models/` | CRUD + `format()` alias override per entity | **08** |
| `api/Controllers/` | request orchestration | **09** |
| `api/Lib/` | `ErrorHandler.php` - global catch, CORS, JSON envelopes | **10** |
| `api/v1/` | endpoint adapters (one `.php` per resource) | **11** |
| `api/vendor/` | Composer PSR-4 autoload (`Sovereign\` namespace) | **03** |

## The 14-Step Sovereign Protocol

### Phase 1 - Foundation
1. **[01-config-generation](01-config-generation/skill.md)** - `.env` + `.env.production`
2. **[02-env-loader](02-env-loader/skill.md)** - env loading + switching
3. **[03-composer-autoload](03-composer-autoload/skill.md)** - PSR-4 autoload
4. **[04-schema-building](04-schema-building/skill.md)** - relational SQL DDL
5. **[05-security-lock](05-security-lock/skill.md)** - RLS policies
6. **[06-seeding](06-seeding/skill.md)** - seed generation + verification

### Phase 2 - Sovereign Engine
7. **[07-rest-client](07-rest-client/skill.md)** - `SupabaseClient.php` + `SovereignQuery.php`
8. **[08-models-layer](08-models-layer/skill.md)** - `api/Models/`
9. **[09-controllers-layer](09-controllers-layer/skill.md)** - `api/Controllers/`
10. **[10-error-handler](10-error-handler/skill.md)** - `api/Lib/ErrorHandler.php`

### Phase 3 - Endpoint Adapters + UI + Brain
11. **[11-router-v1-endpoints](11-router-v1-endpoints/skill.md)** - endpoint adapters + routing
12. **[12-ui-refactor](12-ui-refactor/skill.md)** - PHP templates + safe rendering
13. **[13-brain-hardening](13-brain-hardening/skill.md)** - architecture summary + memory

### Phase 4 - SEO
14. **[14-seo-structured-data](14-seo-structured-data/skill.md)** - JSON-LD structured data and website SEO integration references

## Mandatory Execution Rules

- **Clinical sequencing** - execute 01 -> 14 in order for a new website unless doing a targeted edit
- **Schema isolation** - every query reads from the project schema, never `public.*` business tables
- **Envelope guard** - `SovereignQuery::get()` returns record data directly when `single()` is used
- **UUID authoritative** - relational binding uses UUIDs, not string slugs
- **APIKEY-only clients** - avoid duplicate bearer headers on anon PostgREST requests
- **Static passthrough** - `index.php` must short-circuit asset requests before autoload

## SEO-Specific Verification

For website SEO work, verify:

- `/api/v1/seo` returns `200`
- `/api/v1/seo` returns a route-keyed payload, not an empty result
- public pages resolve the expected DB-backed title/description/keywords/robots
- shared family fallback routes behave correctly
- excluded detail pages still use record-specific meta
- `route_path` rows and rendered pages stay aligned after route changes
- legal pages keep their intended robots values

## 🗺️ Router — AI Navigation Map

AI routes here automatically based on what the user needs.

### Inbound — When to load claude-website
| Trigger / Situation | Action |
|---|---|
| New PHP website / API project | → Start at `01-config-generation/skill.md` |
| User says "build website module X" | → `08-models-layer/skill.md` + `09-controllers-layer/skill.md` + `11-router-v1-endpoints/skill.md` |
| .env / env file setup | → `01-config-generation/skill.md` |
| Env loader / Config.php | → `02-env-loader/skill.md` |
| composer.json / autoload | → `03-composer-autoload/skill.md` |
| SQL DDL / migrations | → `04-schema-building/skill.md` |
| RLS / row security policies | → `05-security-lock/skill.md` |
| Seed data | → `06-seeding/skill.md` |
| SovereignQuery / SupabaseClient | → `07-rest-client/skill.md` |
| BaseModel / entity Model | → `08-models-layer/skill.md` |
| BaseController / Controller | → `09-controllers-layer/skill.md` |
| ErrorHandler / CORS | → `10-error-handler/skill.md` |
| Router / v1 endpoints / clean URLs | → `11-router-v1-endpoints/skill.md` |
| PHP templates / partials | → `12-ui-refactor/skill.md` |
| Architecture summary / docs | → `13-brain-hardening/skill.md` |
| SEO / structured data | → `14-seo-structured-data/skill.md` |
| SEO tables planning | → `../claude/seo-tables-planner/skill.md` first |

### Outbound — What claude-website links to
| Need | → Path |
|---|---|
| Vben Admin paired to this website | `../claude-app/SKILL.md` |
| New project bootstrap | `../starting-point/skill.md` |
| Shared DB contract | `../SHARED_DB_CONTRACT.md` |
| Progress tracking | `WORKING_PROGRESS.md` (in this folder) |
| Reusable snippets | `_cookbook.md` (in this folder) |

### Step Entry Points (Fast Access)
```
01  .env + folders    → 01-config-generation/skill.md
02  Config.php        → 02-env-loader/skill.md
03  composer.json     → 03-composer-autoload/skill.md
04  SQL DDL           → 04-schema-building/skill.md
05  RLS policies      → 05-security-lock/skill.md
06  seed data         → 06-seeding/skill.md
07  api/core/ clients → 07-rest-client/skill.md
08  api/Models/       → 08-models-layer/skill.md
09  api/Controllers/  → 09-controllers-layer/skill.md
10  ErrorHandler+CORS → 10-error-handler/skill.md
11  api/v1/ + router  → 11-router-v1-endpoints/skill.md
12  PHP templates     → 12-ui-refactor/skill.md
13  architecture docs → 13-brain-hardening/skill.md
14  SEO JSON-LD       → 14-seo-structured-data/skill.md
```

### Auto-Trigger Rules (AI applies without being asked)
- **New endpoint needed** → follow `11-router-v1-endpoints` adapter pattern, create both Controller + v1 file
- **New table created** → create Model (`08`) + Controller (`09`) + v1 endpoint (`11`) in that order
- **URL has `.php` in it** → fix in `router.php` per `11-router-v1-endpoints` clean URL rules
- **`import.meta.env` seen in PHP** → wrong file; use `SupabaseConfig::loadEnv()` per `02-env-loader`
- **Cross-origin / CORS error** → `10-error-handler/skill.md` first
- **After any DB change** → update `DATABASE.md` and confirm RLS in `05-security-lock`

## Verify the Orchestrator

- `claude-website/` contains the numbered sub-directories plus `SKILL.md`
- step references remain valid
- no deprecated mirror-path references are reintroduced

---
**Protocol Status**: V7.1 Active | **Architect**: Claude-Website | **Self-Sufficient**: Yes
