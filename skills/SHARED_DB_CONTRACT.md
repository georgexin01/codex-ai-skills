---
name: shared-db-contract
description: "Handshake contract shared by skills/claude (Vben admin), skills/claude-website (PHP API), and skills/claude-app (mobile app). Defines the one database all three connect to: schema, storage bucket, project_id, env-file matrix, and who owns the schema."
triggers: ["db contract", "shared db contract", "handshake", "schema ownership", "which skill owns the schema"]
version: 1.0
date_updated: "2026-05-23"
status: authoritative
---

# 🤝 SHARED DB CONTRACT

The three build skills are **clients of ONE database**, not three owners.
Proven by `angel-interior`: `admin-panel-angel` (Vben) + `website-angel-interior` (PHP) share one Supabase, one schema, one bucket.

This file is the handshake. Every WORKING_PROGRESS.md reads it at Phase A.

---

## 1. THE SHARED KEYS

Every project pins these once. All three skills MUST use the same values.

| Key | Example (angel-interior) | Where it lives |
|---|---|---|
| Schema name | `angelinterior` | env var `VITE_SUPABASE_SCHEMA` / PHP `SUPABASE_SCHEMA` |
| Storage bucket | `angel-interior` | env var `VITE_SUPABASE_STORAGE_BUCKET` |
| Project ID | `b3e45339-0de0-4073-b03a-7f5468bffe77` | env var `VITE_PROJECT_ID` |
| Local Supabase URL | `http://localhost:54321` | local env file |
| Production URL | `https://db-xin.aisolo.vip` | production env file |

**Rule:** if any skill uses a different schema/bucket/project_id than the contract, data writes land where the others cannot read them. Confirm all three keys before writing code.

---

## 2. SCHEMA OWNERSHIP RULE (the most important rule)

A schema has exactly ONE owner. The owner writes migrations; everyone else reads.

| Project shape | Schema owner | Others |
|---|---|---|
| Admin panel + PHP website (like angel-interior) | **`skills/claude`** (admin panel — migrations live in `apps/web-antd/src/sql/migrations/`) | `claude-website` CONSUMES the schema — never rebuilds it |
| PHP website only, no admin panel | **`skills/claude-website`** builds its own schema (its step 4) | — |
| Mobile app + admin panel | **`skills/claude`** owns the schema | `claude-app` CONSUMES it |
| Mobile app only, standalone | `claude-app` mock-mode default; schema optional | — |

**Handshake question every skill asks at Phase A:** *Is there a sibling project that already owns this schema?*
- YES → consume. Read `DATABASE.md`, do NOT write migrations.
- NO → this skill owns it. Build migrations.

---

## 3. ENV FILE MATRIX

Each skill keeps separate env files for local vs production. Never hardcode URLs.

| Skill | Local file | Production file | Switch mechanism |
|---|---|---|---|
| `claude` (Vben) | `.env.development.localhost` | `.env.production` | `pnpm dev:local` vs `pnpm build` mode |
| `claude-website` (PHP) | `api/core/.env` | `api/core/.env.production` | host-detection in `Config.php` (localhost → `.env`, else `.env.production`) |
| `claude-app` (mobile) | `.env.development` | `.env.production` | Vite mode |

Production points at the Cloudflare tunnel (`db-xin.aisolo.vip`). Local points at Docker Supabase (`localhost:54321`).

---

## 4. THE DATABASE.md DOC-STACK (source of truth)

The schema owner produces and maintains this doc-stack at the **project root**. Consumers read it.

| Doc | Role |
|---|---|
| `DATABASE.md` | Canonical schema + auth + RLS contract + migration index. **Single source of truth.** |
| `TABLE_STRUCTURE.md` | Quick table inventory (columns at a glance) |
| `DATABASE_MARKMAP.md` | Visual mindmap of the schema |
| `CROSSWALK.md` | Entity → table → module → route mapping |

**Rule:** any schema change updates `DATABASE.md` in the same task. Code and `DATABASE.md` never drift.

---

## 5. LOCKED-TABLE GOVERNANCE

Some tables are LOCKED — columns/types cannot change without explicit user approval.
In angel-interior: `users`, `permissions`, `attachments` are locked.

- Before altering a locked table: STOP, ask the user.
- A locked table is marked in `DATABASE.md` (or `ANGEL_TABLE_STRUCTURE.md`-style file).
- Adding a NEW table is fine; mutating a LOCKED one needs sign-off.

---

## 6. UNIVERSAL TABLE RULES (all three skills)

- **Soft delete**: every table has `isDelete boolean NOT NULL DEFAULT false` (or `deleted_at`). Never hard-delete from the client.
- **Timestamps**: `createdAt` + `updatedAt timestamptz`, with an `updatedAt` trigger.
- **camelCase columns** in project schemas (e.g. `updatedAt`, not `updated_at`) — add a camelCase trigger helper, do not reuse snake_case helpers.
- **UUID primary keys**: `id uuid PRIMARY KEY DEFAULT gen_random_uuid()`.
- **RLS on every table**: a policy is only half a grant — the role also needs the matching `permissions` row.
- **Storage paths** never start with `/` (avoids `//` 404s).

---

## 7. REFERENCE PROJECT

`C:\Users\user\Desktop\angel-interior` is the live proof of this contract:
- `admin-panel-angel/` — Vben admin (schema owner) — built by `skills/claude`
- `website-angel-interior/` — PHP API (schema consumer) — built by `skills/claude-website`
- `admin-panel-trash/` — read-only reference, never edited

Read its `DATABASE.md`, `BLUEPRINT.md`, `CROSSWALK.md` when a contract detail is unclear.
