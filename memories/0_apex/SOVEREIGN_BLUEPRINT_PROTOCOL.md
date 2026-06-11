---
name: sovereign-blueprint-protocol
tier: 0
priority: CRITICAL
scope: ["website", "webapp", "monorepo", "any-project"]
version: 2.0
last_updated: "2026-04-29"
applies_to: ["claude", "claude-code", "codex-gpt-5.3", "antigravity"]
accepted_filenames: ["BLUEPRINT.md", "APP_BLUEPRINT.md"]
---

# 🛡️ SOVEREIGN BLUEPRINT PROTOCOL (V2.0)

> **Universal applicability**: These rules activate for **ANY project**, past or future, regardless of technology stack, company, or location. The BLUEPRINT system is not specific to any one project or client.

---

## ⚖️ 1. MANDATORY RULES

1. **Blueprint First**: Every project folder containing a recognizable project root indicator (`package.json`, `composer.json`, `index.php`, `pnpm-workspace.yaml`, `requirements.txt`, etc.) **MUST** have a `BLUEPRINT.md` and a `DESIGN.md`.
2. **Auto-Generate if Missing**: If the BLUEPRINT or DESIGN files are missing and the folder is a valid project root, AI **MUST** auto-generate them using the appropriate master templates (`0_apex/templates/MASTER_BLUEPRINT.md` and `0_apex/templates/MASTER_DESIGN.md`).
3. **Tier-0 Reference**: When creating any BLUEPRINT or DESIGN file, AI must clone from the latest `0_apex/templates/` versions.
4. **DESIGN Wins**: In the domain of aesthetics, visual identity, and tokens, `DESIGN.md` is the authoritative source of truth.

---

## 🔎 2. BLUEPRINT TYPE DETECTION (UNIVERSAL RULE)

AI MUST detect which BLUEPRINT type applies to the current working directory:

| Condition | BLUEPRINT Type | Template to Use |
|---|---|---|
| Folder contains ONE project (single `package.json` / `composer.json` / `index.php`) | **Project BLUEPRINT** | `MASTER_BLUEPRINT.md` |
| Folder contains MULTIPLE sub-project folders, each with their own project files | **Router BLUEPRINT** | `MASTER_ROUTER_BLUEPRINT.md` |
| Folder is a documentation, temp, or script-only directory | **Exempt** | None needed |

---

## 🧬 3. EVOLUTION & INTEGRITY RULES

1. **Structural Purity**: Core sections of a BLUEPRINT (Company, Design System, Function Registry, etc.) are non-removable. Updates add/refine content; they do not strip existing structure.
2. **Evolutionary Loop**: When AI discovers a better pattern or design in any project, it MUST:
   - Update the project's BLUEPRINT.md Function Registry.
   - Evaluate if the pattern is universal → if yes, propagate to `MASTER_BLUEPRINT.md`.
3. **Deliberate Removal**: AI may only delete BLUEPRINT content if it is provably obsolete — must log the reason in the Change Log.
4. **Version Tracking**: BLUEPRINT YAML frontmatter `version` must increment on significant structural changes.

---

## 🔥 4. ISOLATION FIREWALL

1. **No Business Bleed**: When cloning MASTER template for a new project, ALL previous project's business data (company name, agents, DB schema, contact info, URLs) MUST be cleared — replaced with `[placeholder]` or the new project's data.
2. **Inherit Only**: May inherit: design principles, tech stack patterns, function patterns, reasoning guidelines.
3. **Never Inherit**: Company data, DB table names, routes, credentials, specific business logic.

---

## 🔑 5. KEYWORD TRIGGERS

- `"blueprint"` → AI must immediately read current project's `BLUEPRINT.md` and treat it as top-context.
- `"update blueprint"` → AI appends current session's changes to the BLUEPRINT Change Log.
- `"new project"` / `"start project"` → AI clones nearest archived BLUEPRINT + runs isolation firewall + triggers shallow scan to fill new project data.

---

## 🔄 6. PER-TURN AUTO-CHECK PROTOCOL (V1.4 Carried Forward)

### 6.1 Mandatory Check
- Every new user chat message → AI MUST scan root for `BLUEPRINT.md` or `APP_BLUEPRINT.md` AND `DESIGN.md` before first tool call.
- Read entire files on first turn; subsequent turns in same session: re-read only Change Log sections.

### 6.2 Write Obligation
- Any turn modifying code, schema, or config → AI MUST append to Change Log of the **closest-scope BLUEPRINT** (project BLUEPRINT if in a sub-project; router BLUEPRINT if ecosystem-wide change).
- Format: `### YYYY-MM-DD · [AI Name] · [Project] (brief title)` → Goal → Files changed → Outcome → Open for next AI.

### 6.3 Missing File Handling
- Valid project root + no BLUEPRINT → AI auto-generates (shallow scan, no permission needed).
- User wants deep recursive scan → AI MUST ask permission first. If no response or refusal → skip deep scan, proceed with shallow.
- Non-project directory → exempt.

---

## 📦 7. AUTO-BOOTSTRAP RULE (NEW V2.0)

When AI enters any project folder for the first time (or BLUEPRINT is absent):

1. Detect project type (project vs router vs exempt).
2. Clone appropriate master template.
3. Run **shallow scan** — detect: stack, key folders, entry files, package names, existing ignores.
4. Fill in all auto-detectable BLUEPRINT sections (Tools Used, Structure Map, type).
5. Leave `[placeholder]` for sections that need human input (Company info, Target Audience, Ideas).
6. Offer to run deep scan for more detail — wait for user approval.
7. Save the generated BLUEPRINT to project root.

---

## 🗄️ 8. PROJECT SCOPE ROUTING (NEW V2.0)

- **Project BLUEPRINT** = records everything about that ONE folder: design, functions, changes, open tasks, ideas.
- **Router BLUEPRINT** = records only: project list, cross-project data relationships, shared infrastructure, ecosystem-wide decisions.
- AI MUST route Change Log entries to the correct BLUEPRINT — never duplicate logs between router and project.

---

## 💾 9. KNOWLEDGE ARCHIVE (NEW V2.0)

When a project reaches a stable/mature state, AI saves a BLUEPRINT snapshot:

- **Archive path**: `C:\Users\user\.codex\memories\4_archive\blueprints\`
- **Filename**: `[YYYY-MM-DD]_[project-type]_[stack]_BLUEPRINT.md`
- **Purpose**: Clone seeds for new projects of similar type.
- **Trigger**: User says "project is done" / "archive this" / "stable now".

---

## 🔁 10. CLONE PROTOCOL (NEW V2.0)

When user starts a new project:

1. AI checks archive: `4_archive/blueprints/` for nearest match by project type + stack.
2. If match found → clone it, run Isolation Firewall (strip all business data).
3. Run shallow scan on new project folder → fill in detected values.
4. Ask user if deep scan is desired.
5. Present filled BLUEPRINT for review before saving.

---

## 🔗 11. IGNORE SYSTEM INTEGRATION

The BLUEPRINT system and Ignore system are coupled. When generating/updating a BLUEPRINT:

- AI MUST verify ignore files exist (per **APEX 13** rules).
- If missing, auto-generate suitable ignore files (`.codexignore` mandatory; platform-specific ones only if the tool is deployed).
- Record ignore file status in BLUEPRINT `## TOOLS USED` section.

---
*Sovereign Blueprint Protocol V2.0 — Universal across all AI models and all projects // Antigravity Tier-0 Governance // 2026-04-29*
