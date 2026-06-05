---
name: claude-blueprint-recipe
description: "Executable, AI-readable companion to the tier-0 SOVEREIGN_BLUEPRINT_PROTOCOL. Use when the user asks to document an existing project into BLUEPRINT.md (and DESIGN.md), or when a project root is missing those files. Covers detection, simulation gate, auto-bootstrap, output schema, change-log write obligation, isolation firewall, archive clone, and verification."
type: procedure
tier: 2
phase: 1-execution
priority: HIGH
model_hint: codex-gpt-5.3
applies_to: ["claude", "claude-code", "codex-gpt-5.3", "antigravity"]
requires: ["0_apex/SOVEREIGN_BLUEPRINT_PROTOCOL.md", "2_governance/SOVEREIGN_BLUEPRINT_PROCEDURE.md", "0_apex/templates/MASTER_BLUEPRINT.md", "0_apex/templates/MASTER_APP_BLUEPRINT.md", "0_apex/templates/MASTER_DESIGN.md", "0_apex/templates/MASTER_ROUTER_BLUEPRINT.md", "0_apex/templates/BLUEPRINT_SAMPLES.md"]
unlocks: ["MOBILE_APP_DESIGN_RECIPE.md", "IMAGE_TO_MOBILE_APP_PIPELINE.md"]
related: ["0_apex/USER_DNA.md", "1_core/DESIGN_SOP.md", "1_core/UI_DNA_MASTER.md", "archive/wrider_design_senses.md"]
accepted_filenames: ["BLUEPRINT.md", "APP_BLUEPRINT.md"]
companion_design_file: "DESIGN.md"
version: 2.0
date: 2026-05-07
status: authoritative
triggers:
  - "redesign app blueprint"
  - "new app with blueprint.md"
  - "regenerate blueprint for [project]"
  - "build BLUEPRINT.md for these apps"
  - "study + understand + document an app"
  - "blueprint for this project"
  - "auto-generate blueprint"
  - "missing blueprint"
---

# 🧱 CLAUDE BLUEPRINT RECIPE (v2.0)

> Executable companion to the tier-0 [SOVEREIGN_BLUEPRINT_PROTOCOL.md](0_apex/SOVEREIGN_BLUEPRINT_PROTOCOL.md). When the user asks to document a project into BLUEPRINT.md (or BLUEPRINT.md is missing from a valid project root), follow these steps end-to-end.

---

## 0. Fast-Agent reading notes

**This file is structured for fast route-first agents:**

- All rules use imperative voice (`MUST`, `MUST NOT`, `SHOULD`).
- Tables are preferred over prose for tabular data.
- Code/snippets use fenced blocks with language tags.
- Every rule cites its source file (`Per SOVEREIGN_BLUEPRINT_PROTOCOL §1.2`).
- Decompose any execution into ≤ 3 sub-tasks per turn (per [FLASH_HARDENING_PROTOCOL §4](1_core/SOFTWARE_3_0_DNA.md)).
- Use the [Verification mandate](#13-verification-mandate-mental-linter--cove) (CoVe) before declaring `[✅ STATUS: CRYSTAL]`.

---

## 1. When to invoke

Trigger on any of these (or paraphrases):

- "redesign app blueprint"
- "new app with blueprint.md"
- "regenerate blueprint for [project]"
- "build BLUEPRINT.md for these apps"
- "study + understand + document an app into BLUEPRINT.md"
- BLUEPRINT.md is missing in a valid project root (auto-detected per §6.3 of SOVEREIGN protocol)

If the user wants to **build** a new mobile app (not just document an existing one):
- → redirect to [MOBILE_APP_DESIGN_RECIPE.md](MOBILE_APP_DESIGN_RECIPE.md) for the build steps
- → if user provides a folder of design images: [IMAGE_TO_MOBILE_APP_PIPELINE.md](IMAGE_TO_MOBILE_APP_PIPELINE.md)

---

## 2. Universal applicability statement (per SOVEREIGN protocol §0)

These rules activate for **ANY project**, past or future, regardless of stack, company, or location. The BLUEPRINT system is not specific to one client.

**Accepted filenames:** `BLUEPRINT.md`, `APP_BLUEPRINT.md`.
**Companion file (mandatory):** `DESIGN.md` — DESIGN wins for visual identity / tokens; BLUEPRINT wins for everything else.

---

## 3. Pre-flight simulation gate (per SOVEREIGN_BLUEPRINT_PROCEDURE §1)

BEFORE generating the blueprint, the AI MUST run a Mental Sandbox to predict and document:

1. **Logical conflicts** (e.g., "Will this auth flow work with the requested offline mode?")
2. **Edge-case failures** (e.g., "This design will break on a 320px screen.")
3. **Performance bottlenecks** (e.g., "50 image loads here will cause lag.")

Findings MUST be written into a `## 🧪 SIMULATION_LOG` section inside the resulting BLUEPRINT.md.

---

## 4. Project type detection (per SOVEREIGN protocol §2)

The AI MUST detect which BLUEPRINT type applies before writing anything.

| Condition | Type | Template to use |
|---|---|---|
| Folder contains ONE project (single `package.json` / `composer.json` / `index.php`) | **Project BLUEPRINT** | [MASTER_BLUEPRINT.md](0_apex/templates/MASTER_BLUEPRINT.md) or [MASTER_APP_BLUEPRINT.md](0_apex/templates/MASTER_APP_BLUEPRINT.md) for dual-webapp |
| Folder contains MULTIPLE sub-project folders, each with their own project file | **Router BLUEPRINT** | [MASTER_ROUTER_BLUEPRINT.md](0_apex/templates/MASTER_ROUTER_BLUEPRINT.md) |
| Folder is documentation / temp / script-only | **Exempt** | none needed |

Cross-check examples in [BLUEPRINT_SAMPLES.md](0_apex/templates/BLUEPRINT_SAMPLES.md) before deciding.

---

## 5. The Deep 4 Questions (per SOVEREIGN_BLUEPRINT_PROCEDURE §4)

If the user has NOT supplied detail, ask these in order:

1. **Architecture**: Monolithic or Modular?
2. **State**: Client-side, Supabase-heavy, or PHP variable-array (no DB)?
3. **Visuals**: Which Aesthetic Spells / palette tokens are active?
4. **Security**: AOE-Tier requirements?

If user has supplied detail (e.g., showed images, gave repo, named tech stack), skip the questions and infer.

---

## 6. Inputs to gather BEFORE writing (read in parallel)

For each target project, read in this order:

1. `package.json` — name, deps, scripts.
2. `index.html` — title, viewport meta, theme-color, fonts, icon system, global `<style>` rules, container width.
3. `tailwind.config.*` (if present) — color tokens, font family, custom shadows.
4. `tsconfig.json`, `vite.config.*` — language/build config and path aliases.
5. `src/style.css` (or main CSS) — `.glass-card`, `.shadow-premium`, `.no-scrollbar`, custom utilities.
6. `src/App.vue` (or root component) — currentPage state machine, route table, back-navigation contract, BottomNav whitelist.
7. **Every** `src/views/*.vue` — read enough lines to summarize purpose + primary UI sections (one row per view; never collapse).
8. `src/components/*` — list and one-line purpose each.
9. `src/stores/*` — list, one-line purpose, mapped database table if any.
10. `src/api/*` — Supabase client, auth, schema env var.
11. `.env` (if present) — Supabase URL, schema, project id.
12. `src/types/*` — domain entities and relationships.

If the project lacks a backend (mock store), explicitly call this out — do not invent one.

---

## 7. Output contract — `BLUEPRINT.md` structure

Every project root receives one `BLUEPRINT.md` with **this exact section order**:

1. **YAML frontmatter** — `name, project, title, role, target_user, status, generated, generator, sister_project, tier, phase, model_hint`. Aligned with [MASTER_APP_BLUEPRINT.md frontmatter](0_apex/templates/MASTER_APP_BLUEPRINT.md).
2. **§1 Identity & Value** — table: app name, audience, form factor, value pillars, sister app link.
3. **§2 Tech Stack** — table: layer / choice / `file:line` reference.
4. **§3 Routing Map** — split into Public / Main tabs / Detail-form pages, plus the back-navigation contract.
5. **§4 App Shell** — ASCII diagram of container → main → bottom nav, plus BottomNav slot table.
6. **§5 Design DNA** — five sub-sections:
   - 5.1 Color tokens (Tailwind values + light/dark)
   - 5.2 Typography (family, weights, size scale)
   - 5.3 Surfaces & glass utilities
   - 5.4 Geometry standards (radius, **6 px progress bars**, touch targets, container width, active feedback)
   - 5.5 Signature patterns (hero, KPI strip, carousel, segmented tabs, modal overlay, etc.)
7. **§6 State / Data Layer** — stores table (name, table, responsibility), API surface, env vars.
8. **§7 Domain Model** — entities table + ASCII relationship diagram.
9. **§8 PWA / Mobile Baseline** — table: item / current / standard / status. **Always check viewport against `width=device-width`** per [CLAUDE.md](C:/Users/user/.claude/CLAUDE.md) and flag deviation.
10. **§9 Engineering Protocols (compliance)** — table cross-checking USER_DNA / DESIGN_SOP / GROUND_KERNEL rules with ✅ / ⚠️ / ❌ per item.
11. **§10 Open Items / Roadmap** — numbered list of concrete next steps with `file:line` links.
12. **§11 SIMULATION_LOG** — output of the pre-flight simulation gate (logical conflicts / edge cases / perf).
13. **§12 CHANGE LOG** — append-only entries per §10 of this recipe.
14. **Footer** — generation date + retrigger hint.

---

## 8. Output contract — `DESIGN.md` (companion file, mandatory per SOVEREIGN §1.4)

DESIGN.md is the **authoritative source for aesthetics**. BLUEPRINT.md cross-references it but does not duplicate token tables.

Required DESIGN.md sections (clone from [MASTER_DESIGN.md](0_apex/templates/MASTER_DESIGN.md)):

1. YAML frontmatter
2. §1 Identity (palette name, brand spirit, visual fingerprint)
3. §2 Color tokens (full hex table, CSS custom property names)
4. §3 Typography (family, axes, scale, weight rules)
5. §4 Surfaces (cards, glass, shadows, borders)
6. §5 Geometry (radius scale, spacing scale, touch targets)
7. §6 Iconography (library, weight, fill rules)
8. §7 Motion (keyframes, transition durations, easing curves)
9. §8 Component recipes (copy-paste Tailwind for hero, card, list row, button, input, toggle, etc.)
10. §9 Anti-patterns (what NEVER to do)

If the project doesn't yet have visual definition, generate DESIGN.md alongside BLUEPRINT.md using shallow scan + USER_DNA defaults.

---

## 9. Mandatory cross-references

When writing the blueprint, **always** cite User DNA standards by name:

- 700 default heading weight, 900 reserved for numerical spectacle, never below 500 — [USER_DNA.md](USER_DNA.md).
- 6 px progress bars — non-negotiable.
- Glass for modals/overlays.
- Clickable cards over isolated buttons.
- Focus-first information culling (one hero mission per page).

Cite Engineering protocols ([GROUND_KERNEL.md](0_apex/GROUND_KERNEL.md)):

- APEX 5: every project root must have BLUEPRINT.md.
- APEX 11: schema logic in DB layer.
- APEX 9: surgical execution (no broad rewrites).

---

## 10. Change Log write obligation (per SOVEREIGN protocol §6.2)

**On every turn that modifies code, schema, or config**, the AI MUST append an entry to the BLUEPRINT.md `## 📜 CHANGE LOG` section.

Format:

```markdown
### 2026-MM-DD · [AI Name] · [Project] (brief title)
- **Goal**: ...
- **Files changed**: `path/to/file.vue`, `path/to/store.ts`
- **Outcome**: what now works / what broke / what was avoided
- **Open for next AI**: known limitations, follow-up tasks
```

Route to **closest-scope BLUEPRINT** — project BLUEPRINT if in a sub-project, router BLUEPRINT if ecosystem-wide. **Never duplicate** logs between router and project.

---

## 11. Auto-bootstrap rule (per SOVEREIGN protocol §7)

When AI enters any project folder for the first time AND BLUEPRINT.md is missing AND it's a valid project root:

1. Detect project type (project vs router vs exempt) — §4 of this file.
2. Clone appropriate master template from `0_apex/templates/`.
3. Run **shallow scan** — detect: stack, key folders, entry files, package names, existing ignores.
4. Fill in all auto-detectable BLUEPRINT sections (Tools Used, Structure Map, type).
5. Leave `[placeholder]` for sections that need human input (Company info, Target Audience, Ideas).
6. Offer to run **deep scan** for more detail — wait for user approval.
7. Save to project root.

For deep scan, also write the companion DESIGN.md (§8 of this file).

---

## 12. Clone-from-archive protocol (per SOVEREIGN protocol §10)

When user starts a NEW project of similar type to a past project:

1. Check `C:\Users\user\.codex\memories\4_archive\blueprints\` for nearest match by `[YYYY-MM-DD]_[project-type]_[stack]_BLUEPRINT.md` filename pattern.
2. Clone the matched BLUEPRINT into the new project root.
3. Run **isolation firewall** (§14 below).
4. Update placeholders with the new project's data.
5. Append new project marker to the BLUEPRINT.

Ask the user to confirm the chosen archive before cloning.

---

## 13. Verification mandate (mental linter / CoVe)

Subagent / `Explore` reports are **not** sources of truth — they are leads. After drafting the blueprint, the AI MUST directly read and verify these specific claims against actual code:

1. **Every Tailwind utility named in the blueprint** — especially heights/widths. Tailwind `h-2.5` is 10 px, `h-1.5` is 6 px. Don't conflate User DNA's 6 px standard with what the code actually uses; record the actual value and flag deviation.
2. **Every directory path** — `src/store/` vs `src/stores/`, `src/api/` vs `src/apis/`. Glob the parent dir to confirm.
3. **Every store-list claim** — read `stores/index.ts` (or equivalent) and check which files are re-exported vs which exist on disk. Note divergences.
4. **Every CSS token** — read `src/style.css` directly. Don't trust `tailwind.config.js` values when style.css overrides them (e.g., shadow-premium alpha).
5. **Every locale / i18n path** — locale files often live in nested `langs/` subfolders, not the top-level locale folder.
6. **Every type definition citation** — read `src/types/*.ts` and report exact field shapes, not paraphrases.
7. **BottomNav slot count** — count buttons in the actual component, not whitelist entries in App.vue. They are different.
8. **Cruft files** — `counter.ts`, `shims-vue.d.ts`, `HelloWorld.vue` and similar Vite/Vue starter leftovers are common. Glob for them and call them out.

If a claim cannot be verified directly, either remove it or annotate `(unverified)`.

The CoVe questions before declaring done:
- *"Does this BLUEPRINT delete any code or claim removals not actually performed?"*
- *"Does this BLUEPRINT introduce dependencies that aren't grounded in the codebase?"*
- *"Is this the simplest possible documentation? (Karpathy Standard)"*

---

## 14. Isolation firewall (per SOVEREIGN protocol §4)

When cloning a MASTER template OR an archived BLUEPRINT for a new project:

| Cleared (replace with `[placeholder]`) | Inherited |
|---|---|
| Company name, brand info | Design principles |
| Agent / staff names | Tech stack patterns |
| DB table names, schema | Function patterns |
| Contact info, URLs | Reasoning guidelines |
| Specific business logic | Token color rules |
| Credentials, env values | UI/UX standards |

**Never inherit business data across projects.** Always clear before populating.

---

## 15. Per-turn auto-check (per SOVEREIGN protocol §6.1)

Every new user chat message → AI MUST scan project root for `BLUEPRINT.md` (or `APP_BLUEPRINT.md`) AND `DESIGN.md` BEFORE the first tool call.

- First turn in session: read entire files.
- Subsequent turns: re-read only the `## 📜 CHANGE LOG` section.
- If both files missing in a valid project root: trigger §11 auto-bootstrap.

---

## 16. Style rules for the blueprint itself

- **File-link clickability** — every file reference MUST use `[label](path)` or `[label](path#L42)` markdown form (per VS Code extension conventions in this user's environment).
- **No emoji** unless the user explicitly requests it (per [CLAUDE.md](C:/Users/user/.claude/CLAUDE.md)).
- **Tables over prose** wherever the data is naturally tabular.
- **Concrete `file:line` citations** — claims like "uses glassmorphism" must point at the line.
- **Flag, don't fix** — the blueprint records deviations (viewport `width=device-width`, missing PWA manifest, etc.) but does NOT silently fix code unless the user asks. List as Open Items.
- **Sister-project linkage** — when multiple related apps exist (e.g., agent + customer), each blueprint links to the other and notes shared / divergent decisions.
- **Replace, don't merge** — if a `BLUEPRINT.md` already exists, fully overwrite (per user instruction "remove last project blueprint information"). Do not attempt diff-merge — but PRESERVE the `CHANGE LOG` section by appending, never overwriting historical entries.

---

## 17. Permission boundaries

- **Writes confined to**: `BLUEPRINT.md` and `DESIGN.md` at each project root; nothing else changes.
- **Tier-0/1 governance** files in `.codex/memories/0_apex/` and `.codex/memories/2_governance/` are **read-only** per APEX 0 lockdown.
- **New blueprint-related knowledge files** at `.codex/memories/` root may be added with explicit per-turn user authorization.
- **Knowledge archive** at `.codex/memories/4_archive/blueprints/` may be written when user says "archive this", "project is done", "stable now".

---

## 18. Reference implementation

The first execution of this recipe produced:

- [c:\Users\user\Desktop\insurance-CRM\webApp-insuranceCRM-agent\BLUEPRINT.md](c:/Users/user/Desktop/insurance-CRM/webApp-insuranceCRM-agent/BLUEPRINT.md)
- [c:\Users\user\Desktop\insurance-CRM\webApp-insuranceCRM-customer\BLUEPRINT.md](c:/Users/user/Desktop/insurance-CRM/webApp-insuranceCRM-customer/BLUEPRINT.md)
- [c:\Users\user\Desktop\insurance-CRM\template\BLUEPRINT.md](c:/Users/user/Desktop/insurance-CRM/template/BLUEPRINT.md)

Use those as the canonical shape when regenerating any future project blueprint.

---

## 19. Companion recipes (delegate to these for related tasks)

| User intent | Use this recipe |
|---|---|
| Document an existing app | This file (CLAUDE_BLUEPRINT_RECIPE.md) |
| Build a new mobile app from scratch | [MOBILE_APP_DESIGN_RECIPE.md](MOBILE_APP_DESIGN_RECIPE.md) |
| Build a new mobile app from a folder of design images | [IMAGE_TO_MOBILE_APP_PIPELINE.md](IMAGE_TO_MOBILE_APP_PIPELINE.md) |
| Generate a Supabase schema for a new project | [generate-supabase-schema](C:/Users/user/.claude/skills/generate-supabase-schema/) |
| Generate Vue route configuration | [generate-route](C:/Users/user/.claude/skills/generate-route/) |

---

## 20. Output schema (Gemini 3 Flash quick-reference)

When this recipe completes, the AI MUST have produced:

```
<project_root>/
├── BLUEPRINT.md     ← project type-specific, 12 sections, change log appended
└── DESIGN.md        ← (only if project has visual definition or user requests)
```

And the BLUEPRINT.md must pass the verification mandate (§13). Then declare:

```
[🟢 STATUS: CRYSTAL] BLUEPRINT.md generated for <project>. CHANGE LOG entry appended.
```

---

_Tier-0 source of truth: [SOVEREIGN_BLUEPRINT_PROTOCOL.md](0_apex/SOVEREIGN_BLUEPRINT_PROTOCOL.md). Tier-2 procedure: [SOVEREIGN_BLUEPRINT_PROCEDURE.md](2_governance/SOVEREIGN_BLUEPRINT_PROCEDURE.md). Templates: [0_apex/templates/](0_apex/templates/). When in doubt, defer to those — this file is the executable wrapper._
