---
name: website-api-connection-retired
description: "RETIRED — content absorbed into the 13-step pyramid at ../SKILL.md. Kept as a pointer so legacy references still resolve."
triggers: []
phase: reference
version: 3.0
status: retired
retired_date: "2026-04-20"
superseded_by: "../SKILL.md"
---

# `website-api-connection` — Retired

This folder previously held a monolithic 12-step PHP + Supabase protocol (V2.0, 2026-04-17). That content has been **absorbed into the 13-step pyramid** at `../SKILL.md` — each former section is now a self-sufficient step file with a Code Vault.

## Where the old sections live now

| Former section | New step |
|---|---|
| STEP 1 — Project Skeleton | [01-config-generation](../01-config-generation/skill.md) |
| STEP 2 — .env + Env Loader | [02-env-loader](../02-env-loader/skill.md) |
| STEP 3 — Composer autoload | [03-composer-autoload](../03-composer-autoload/skill.md) |
| STEP 4 — Schema DDL | [04-schema-building](../04-schema-building/skill.md) |
| STEP 5 — RLS policies | [05-security-lock](../05-security-lock/skill.md) |
| STEP 6 — Seed data | [06-seeding](../06-seeding/skill.md) |
| STEP 7 — SupabaseClient + SovereignQuery | [07-rest-client](../07-rest-client/skill.md) |
| STEP 8 — BaseModel + format() | [08-models-layer](../08-models-layer/skill.md) |
| STEP 9 — BaseController + processRequest | [09-controllers-layer](../09-controllers-layer/skill.md) |
| STEP 10 — ErrorHandler + CORS | [10-error-handler](../10-error-handler/skill.md) |
| STEP 11 — Router + v1 endpoints | [11-router-v1-endpoints](../11-router-v1-endpoints/skill.md) |
| STEP 12 — Templates | [12-ui-refactor](../12-ui-refactor/skill.md) |
| (new) Brain hardening | [13-brain-hardening](../13-brain-hardening/skill.md) |

## Why retire?

The 12-step monolith was a single ~12 KB file. It worked but violated two principles:
1. **Pyramid lazy-load** — every trigger loaded the whole file, burning tokens.
2. **Self-sufficient steps** — no per-step Code Vault meant the caller still had to read `website-BE/` reference code, which is being deleted.

The 13-step pyramid fixes both — each step is independently loadable and carries its own copy-paste Code Vault.

## If you were looking for this file

Go to the orchestrator: [`../SKILL.md`](../SKILL.md). Pick the step your task matches and drill in.
