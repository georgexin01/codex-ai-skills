---
name: claude-website-working-progress
description: "Linear task executor for skills/claude-website — the PHP + Supabase REST builder. 45 numbered micro-tasks: handshake -> foundation -> engine -> endpoints -> publish. Follow top to bottom, one task at a time. Built for low-effort Claude 4.6 / GPT 5.4."
triggers: ["claude-website working progress", "build php api", "ai claude website", "sovereign rest", "php supabase"]
version: 1.0
date_updated: "2026-05-21"
status: authoritative
---

# 🟩 CLAUDE-WEBSITE — WORKING PROGRESS (PHP + Supabase REST Builder)

**How to run this file:** do ONE task, verify it, then go to the next number. Never skip. Never jump ahead.
Each task tells you exactly what to read — read only that.

## Rules you must follow (read once, keep in mind)

- **Handshake first** — `SHARED_DB_CONTRACT.md` decides who owns the schema. If a sibling admin panel exists, this skill CONSUMES the schema — it does NOT rebuild it.
- **Drift Guard** — every 5 tasks, re-read the user's original request and re-anchor if drifted.
- **Karpathy** — surgical scope: touch only files the current task names.
- **Schema isolation (Rule #1)** — every query reads the project schema via `Accept-Profile` / `Content-Profile` headers. Never write `public.*`.
- **apikey-only auth** — never add `Authorization: Bearer` with the anon JWT (PostgREST rejects duplicate JWT).
- Code-vault detail lives in the 13 numbered step folders (`01-config-generation/` … `13-brain-hardening/`) — this file points into them; do not duplicate code here.

---

## PHASE A — HANDSHAKE (Tasks 1–7)

### Task 1 — Read the DB contract
Do: read the shared contract.
Read: `../SHARED_DB_CONTRACT.md`
Verify: you understand the schema-ownership rule (§2).
Done? → Task 2

### Task 2 — Schema-ownership decision
Do: answer the handshake question — *Is there a sibling admin panel (e.g. `admin-panel-*`) that already owns this schema?*
Verify: write down the answer. YES → this skill CONSUMES the schema (skip Tasks 14–16). NO → this skill BUILDS the schema (do Tasks 14–16).
Done? → Task 3

### Task 3 — Confirm the three keys
Do: confirm schema name, storage bucket, project_id from the contract / sibling project.
Verify: all three known and consistent with the sibling (if any).
Done? → Task 4

### Task 4 — Local env file
Do: create `api/core/.env` pointing at local Docker Supabase.
File: `api/core/.env` → `SUPABASE_URL=http://localhost:54321`, anon key, `SUPABASE_SCHEMA`, bucket.
Verify: values match the contract.
Done? → Task 5

### Task 5 — Production env file
Do: create `api/core/.env.production` pointing at the Cloudflare tunnel.
File: `api/core/.env.production` → `SUPABASE_URL=https://db-xin.aisolo.vip` (or the project's tunnel host).
Verify: production keys present.
Done? → Task 6

### Task 6 — Read DATABASE.md
Do: read the schema you will consume (or build).
File: `<project-root>/DATABASE.md`
Verify: you know the table names, columns, and RLS the API must respect.
Done? → Task 7

### Task 7 — Lock the build path
Do: confirm the branch — CONSUME (skip 14–16) or BUILD (do 14–16).
Verify: the path is written down. Proceed to foundation.
Done? → Task 8

---

## PHASE B — FOUNDATION (Tasks 8–17)

### Task 8 — Folder genesis
Do: create the `api/` layout — `core/`, `Models/`, `Controllers/`, `Lib/`, `v1/`.
Read: `01-config-generation/skill.md`
Verify: all six pillar folders exist.
Done? → Task 9

### Task 9 — Env key layout
Do: finalize `.env` + `.env.production` with VITE_-prefixed Supabase keys per step 01.
File: `api/core/.env*`
Verify: key names match what `Config.php` will read.
Done? → Task 10

### Task 10 — Config.php: dotenv parsing
Do: write `api/Config.php` — `const Sovereign\Config`, dotenv parser.
Read: `02-env-loader/skill.md`
Verify: `php -l api/Config.php` passes.
Done? → Task 11

### Task 11 — Config.php: host-based env switch
Do: add localhost-detection — localhost host → load `.env`, else `.env.production`.
File: `api/Config.php`
Verify: on localhost it resolves the local URL; otherwise the tunnel URL.
Done? → Task 12

### Task 12 — composer.json PSR-4
Do: write `composer.json` with PSR-4 `Sovereign\\` autoload + files autoload.
Read: `03-composer-autoload/skill.md`
Verify: namespace maps to `api/`.
Done? → Task 13

### Task 13 — composer dump-autoload
Do: run `composer dump-autoload`.
Verify: `php -r "require 'vendor/autoload.php';"` is silent (no fatal).
Done? → Task 14

### Task 14 — Schema build (BUILD path only)
Do: if NO sibling owns the schema, build the relational SQL DDL.
Read: `04-schema-building/skill.md`
Verify: UUID PKs, soft-delete, timestamps. If CONSUME path, skip → Task 17.
Done? → Task 15

### Task 15 — Security lock (BUILD path only)
Do: write RLS policies — anon-insert, soft-delete filter, casing-sync COALESCE.
Read: `05-security-lock/skill.md`
Verify: every table has RLS. If CONSUME path, skip → Task 17.
Done? → Task 16

### Task 16 — Seeding (BUILD path only)
Do: generate + inject seed data; verify FK integrity.
Read: `06-seeding/skill.md`
Verify: seed rows load cleanly. If CONSUME path, skip → Task 17.
Done? → Task 17

### Task 17 — Foundation verify
Do: confirm autoload works and env resolves.
Verify: `php -r "require 'vendor/autoload.php'; var_dump(Sovereign\Config::get('SUPABASE_URL'));"` prints the right URL.
Done? → Task 18

---

## PHASE C — ENGINE (Tasks 18–30)

### Task 18 — SupabaseClient: class skeleton
Do: create `api/core/SupabaseClient.php` — constructor reads url/anonKey/schema; `from()` + `storage()`.
Read: `07-rest-client/skill.md` → §1
Verify: `php -l` passes.
Done? → Task 19

### Task 19 — SupabaseClient: request() engine
Do: write the low-level cURL `request()` — apikey-only headers, `Accept-Profile`/`Content-Profile`, diagnostic `error_log`.
File: `api/core/SupabaseClient.php`
Verify: headers include schema profiles; no `Authorization: Bearer`.
Done? → Task 20

### Task 20 — FIX 1: cURL timeout
Do: add `curl_setopt($ch, CURLOPT_TIMEOUT, 10);` and `curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);` inside `request()`.
File: `api/core/SupabaseClient.php`
Verify: a slow/dead Supabase now fails fast instead of hanging the PHP worker.
Done? → Task 21

### Task 21 — FIX 2: conditional SSL verify
Do: replace the hardcoded `CURLOPT_SSL_VERIFYPEER, false` with `getenv('APP_ENV') === 'production'` (or contract env flag).
File: `api/core/SupabaseClient.php`
Verify: production verifies the cert; local Docker (self-signed) still works.
Done? → Task 22

### Task 22 — SovereignQuery: fluent filters
Do: create `api/core/SovereignQuery.php` — `select`, `eq`, `neq`, `gt`, `ilike`, `filter`, `or`, `order`, `limit`, `range`, `single`.
Read: `07-rest-client/skill.md` → §2
Verify: every filter value passes through `urlencode`.
Done? → Task 23

### Task 23 — FIX 3: in() filter method
Do: add an `in($column, array $values)` shortcut → builds `{col}=in.("v1","v2")` with proper encoding.
File: `api/core/SovereignQuery.php`
Verify: `->in('id', [$a,$b])` produces a valid PostgREST `in.` filter.
Done? → Task 24

### Task 24 — SovereignQuery: get/insert/update/delete
Do: implement `get()` (with `single()` envelope guard), `insert()`, `update()`, `delete()`.
File: `api/core/SovereignQuery.php`
Verify: `single()` returns the row directly on 2xx, `null` otherwise.
Done? → Task 25

### Task 25 — SovereignStorage stub
Do: create `api/core/SovereignStorage.php` — `publicUrl()`; leave upload/remove for later.
Read: `07-rest-client/skill.md` → §3
Verify: `php -l` passes on all three core files.
Done? → Task 26

### Task 26 — REST client smoke test
Do: run the end-to-end smoke test against local Supabase.
Read: `07-rest-client/skill.md` → "Verify"
Verify: a `select` returns `status 200`; `single()` returns a row object or null.
Done? → Task 27

### Task 27 — Models layer
Do: create `api/Models/` — `BaseModel` + per-entity models with `format()` DB→template alias.
Read: `08-models-layer/skill.md`
Verify: each model maps to one table; `format()` overrides aliases.
Done? → Task 28

### Task 28 — Controllers layer
Do: create `api/Controllers/` — `BaseController` + entity controllers with `processResourceRequest` / `processCollectionRequest`.
Read: `09-controllers-layer/skill.md`
Verify: controllers call models, not the REST client directly.
Done? → Task 29

### Task 29 — ErrorHandler
Do: create `api/Lib/ErrorHandler.php` — global exception catch, CORS preflight, JSON error envelope.
Read: `10-error-handler/skill.md`
Verify: an uncaught error returns a clean JSON envelope, not an HTML stack trace.
Done? → Task 30

### Task 30 — Engine verify
Do: confirm the engine compiles and a controller returns data.
Verify: `php -l` on every engine file; one controller call returns a JSON envelope.
Done? → Task 31

---

## PHASE D — ENDPOINTS + UI (Tasks 31–39)

### Task 31 — index.php static passthrough
Do: write root `index.php` — short-circuit JS/CSS/asset requests BEFORE autoload.
Read: `11-router-v1-endpoints/skill.md`
Verify: a request for a `.css` file returns the file, not HTML.
Done? → Task 32

### Task 32 — router.php dispatch
Do: write `router.php` — GET/POST dispatch to `api/v1/*` adapters, UUID-only resolution.
File: `router.php`
Verify: routing maps `/api/v1/{resource}` to the adapter.
Done? → Task 33

### Task 33 — First v1 endpoint
Do: create the first `api/v1/{resource}.php` adapter.
Folder: `api/v1/`
Verify: `curl localhost/api/v1/{resource}` returns a JSON envelope.
Done? → Task 34

### Task 34 — Remaining v1 endpoints
Do: create one adapter per remaining resource (one `.php` each).
Folder: `api/v1/`
Verify: every resource in `DATABASE.md` / `CROSSWALK.md` has an adapter.
Done? → Task 35

### Task 35 — UUID resolution
Do: confirm relational binding uses UUIDs (`agent_profile_id`), not slugs.
Verify: a detail request by UUID resolves; a bad UUID returns 404 (not the first row).
Done? → Task 36

### Task 36 — Endpoint smoke test
Do: `curl` every endpoint — list + single.
Verify: all return 200 with correct envelopes; logs in `api/logs/` show clean requests.
Done? → Task 37

### Task 37 — UI refactor
Do: build/refresh PHP templates — `htmlspecialchars()` discipline, "No Profile Image" fallback, server-rendered pages.
Read: `12-ui-refactor/skill.md`
Verify: pages render with live data; no unescaped output.
Done? → Task 38

### Task 38 — Brain hardening
Do: summarize the architecture into the project snapshot doc; save session memory.
Read: `13-brain-hardening/skill.md`
Verify: snapshot doc exists and matches the build.
Done? → Task 39

### Task 39 — Endpoint + UI verify
Do: full pass — every endpoint + every page.
Verify: site loads, API responds, no PHP warnings in logs.
Done? → Task 40

---

## PHASE E — PUBLISH (Tasks 40–45)

### Task 40 — Switch to production env
Do: confirm production deploy will read `api/core/.env.production` (host-detection from Task 11).
Verify: non-localhost host resolves the tunnel URL.
Done? → Task 41

### Task 41 — Verify tunnel health
Do: check the public DB host — both `/auth/v1/health` AND `/rest/v1/`.
Verify: both healthy (not 502). If 502, run `supabase status` and restart `rest`.
Done? → Task 42

### Task 42 — Deploy PHP files
Do: upload the website + `api/` to hosting.
Verify: upload completes; `vendor/` is included or `composer install` runs on host.
Done? → Task 43

### Task 43 — Live static passthrough check
Do: confirm CSS/JS load on the live site.
Verify: no asset returns HTML; `index.php` passthrough works in production.
Done? → Task 44

### Task 44 — Live API smoke test
Do: `curl` the live `/api/v1/*` endpoints.
Verify: live endpoints return data from the production Supabase.
Done? → Task 45

### Task 45 — Final report
Do: report what changed, what was verified, what remains uncertain.
Verify: report covers all three. Update the project `STATUS.md` if present.
Done? → ✅ COMPLETE
