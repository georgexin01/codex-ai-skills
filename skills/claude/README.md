---
name: claude-admin
description: "Core CRUD, Supabase, and module generation engine for Vben Admin. Acts as the primary orchestrator for industrial-grade namespaced architecture."
triggers: ["claude", "vben admin", "admin", "module", "crud"]
phase: orchestrator
version: 1.0
---

# Claude Skills Registry (Gemini 3 Flash Hybrid Format)

> **To BUILD a module, use the linear executor: [`WORKING_PROGRESS.md`](WORKING_PROGRESS.md)** — 41 numbered micro-tasks (handshake → build → publish). The skill files below are the code-vault reference it points into.
> **DB handshake** shared with `claude-website` + `claude-app`: [`../SHARED_DB_CONTRACT.md`](../SHARED_DB_CONTRACT.md).

Skills use hybrid YAML frontmatter + Markdown body for fast keyword routing and structured-output compatibility with Gemini 3 Flash.

## Frontmatter Schema

| Field | Purpose |
|---|---|
| `name` | Unique skill ID (matches folder name) |
| `description` | One-line summary for loader listing |
| `triggers[]` | Literal keywords the router matches against user input |
| `phase` | Execution stage: `0-orchestrator`, `1-analysis`, `2-scaffold`, `3-testing`, `reference` |
| `requires[]` | Skills that must run first |
| `unlocks[]` | Skills this one enables |
| `inputs[]` | Required input parameters |
| `output_format` | Structured output contract |
| `model_hint` | `gpt-5.4-mini` (fast) or `gpt-5.5` (heavy reasoning) |
| `version` | Skill version for cache-busting |

## Execution Pipeline

```
0-orchestrator                 create-module (all-in-one, 14 steps)
        |
1-analysis                     analyze-schema
        |
2-scaffold     generate-store → generate-supabase-schema → generate-views
                                                               |
                                                       generate-route
                                                       generate-i18n
                                                       image-upload-spec
        |
3-testing                      generate-e2e, workflow-test
```

## Skill Index

### Orchestrator
- [create-module](create-module/skill.md) — End-to-end CRUD module (SQL → views → tests)

### Phase 1: Analysis
- [analyze-schema](analyze-schema/skill.md) — Confirm entity fields + relationships

### Phase 2: Scaffold
- [generate-store](generate-store/skill.md) — Types + Pinia + Supabase CRUD
- [generate-supabase-schema](generate-supabase-schema/skill.md) — SQL migrations + RLS
- [generate-views](generate-views/skill.md) — Vue list/detail/form/drawer
- [generate-route](generate-route/skill.md) — Vue Router module
- [generate-i18n](generate-i18n/skill.md) — zh-CN + en-US translations
- [image-upload-spec](image-upload-spec/skill.md) — Image upload + crop modal

### Phase 3: Testing
- [generate-e2e](generate-e2e/skill.md) — E2E test scenarios
- [workflow-test](workflow-test/skill.md) — Playwright + workflow config

### Reference (always-on context)
- [staging](staging/skill.md) — Mock / Supabase / default mode switching
- [ui-standardization](ui-standardization/skill.md) — Divider + Card layout conventions
- [supabase-auth-architecture](supabase-auth-architecture/skill.md) — Multi-project auth schemas
- [supabase-rls-rbac-design](supabase-rls-rbac-design.md) — RLS + RBAC + JWT hooks
- [mcp-supabase-postgres-connection](mcp-supabase-postgres-connection.md) — MCP PostgreSQL setup
- [VBEN_SUPABASE_LOCAL_LESSONS](VBEN_SUPABASE_LOCAL_LESSONS.md) — Local Docker gotchas + pre-flight (psql `-f`, formApi expose, RLS+permissions dual-grant, `//` storage bug, corrective migrations)

## Router Contract

The Gemini 3 Flash router should:
1. Match user input against `triggers[]` (cheap literal match first, semantic fallback)
2. Resolve `requires[]` dependencies and warn if prerequisites unmet
3. Load only the matched skill's body (lazy-load — frontmatter alone is enough to route)
4. Route to `model_hint` — `gpt-5.4-mini` for light scaffold, `gpt-5.5` for orchestration
5. Enforce the `output_format` contract in structured-output mode

## Core Principle: Reality-First Table Forging

When creating or changing database tables for a website or app module:

1. Research the real rendered website/app output first and treat that as the source of truth.
2. Extract the exact visible data contract the UI truly uses.
3. Prefer the leanest recognizable field set that fully supports the real output.
4. Do not invent extra columns just because another project had them.
5. Use older Vben/admin projects only as structural references for CRUD/module patterns, never as authority for field lists.
6. Compare with similar tables in current and older projects only to confirm what is necessary, not to justify adding more fields.
7. Keep styling-only or hardcoded presentation details out of the database unless the live UI truly needs them to vary per record.
8. If a visible UI key exists in legacy code but the user says it is not important, re-check whether it is business data or merely presentation sugar before keeping it.
9. When in doubt, choose fewer columns and map hardcoded presentation in the website/app layer.
10. Goal: tables should look familiar to the user, reproduce the real module data, and avoid unrecognized or speculative fields.

