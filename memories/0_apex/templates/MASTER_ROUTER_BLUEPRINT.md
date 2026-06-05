---
name: master-router-blueprint
description: "Router Blueprint template for multi-project root folders. Lightweight ecosystem map — not a project BLUEPRINT."
version: 1.0.0
status: master
last_updated: "2026-04-29"
blueprint_type: "router"
---

# 🗺️ ROUTER BLUEPRINT (V1.0)

> **Purpose** — This file is the **ecosystem navigation brain** for a root folder containing multiple sub-projects. It is intentionally lightweight. It tells AI what each sub-project does, how they relate to each other, and where to go for details. Each sub-project has its own full `BLUEPRINT.md`. This file does NOT duplicate their change logs.

---

## 📌 ECOSYSTEM OVERVIEW
- **Root Folder**: `[root-folder-name]/`
- **Type**: Multi-Project Ecosystem
- **Purpose**: [One paragraph: what is the overall ecosystem, who it serves]
- **Company**: [Company name]

---

## 🗂️ PROJECT DIRECTORY

| # | Folder | Type | Port | Purpose |
|---|---|---|---|---|
| A | `[folder-1]/` | [Vue WebApp / PHP / etc.] | `:XXXX` | [What it does in one line] |
| B | `[folder-2]/` | [Vue WebApp / PHP / etc.] | `:XXXX` | [What it does in one line] |
| C | `[folder-3]/` | [Vue WebApp / PHP / etc.] | `:XXXX` | [What it does in one line] |
| D | `[folder-4]/` | [Vue WebApp / PHP / etc.] | `:XXXX` | [What it does in one line] |

> For full project details, read that project's own `BLUEPRINT.md`.

---

## 🔗 CROSS-PROJECT RELATIONSHIPS

### Shared Infrastructure
- **Database**: [e.g. Supabase — Docker-hosted, schema: `quizLaa` — shared by all 4 projects]
- **Storage**: [e.g. Supabase Storage bucket `quizLaa` — shared across all projects]
- **Auth**: [e.g. auth.users table shared — admin panel creates users, webApp consumes them]

### Data Flow
<!-- How data moves between projects -->
- [Project A] creates/manages → [data type] → consumed by [Project B]
- [Project C] reads → [table/API] → owned by [Project A]

### Shared Assets / Reference Folder
- [e.g. `C:\Users\user\Desktop\LAA-UPDATE\` — client-supplied assets, read-only reference for all projects]

---

## 🚀 DEV SERVER COMMANDS
<!-- AI recognizes trigger phrases like "run dev 4 project" / "start all" -->

| # | Project | Command | Note |
|---|---|---|---|
| A | `[folder-1]/` | `[command]` | [note] |
| B | `[folder-2]/` | `[command]` | [note] |
| C | `[folder-3]/` | `[command]` | [note] |
| D | `[folder-4]/` | `[command]` | [note] |

---

## 📝 ECOSYSTEM CHANGE LOG
<!-- Only ecosystem-wide decisions go here (new project added, DB schema breaking changes, shared infra changes) -->
<!-- Per-project changes go in that project's own BLUEPRINT.md -->

*(No entries yet.)*

---

## 🧬 BLUEPRINT META
- **Blueprint Type**: Router (multi-project root)
- **Template Version**: V1.0
- **Created**: [YYYY-MM-DD]
- **Sub-project BLUEPRINTs**: [List folders that have their own BLUEPRINT.md]

---
*Router BLUEPRINT V1.0 — Antigravity Tier-0 // Use for multi-project root folders only*
