---
name: vben-relation-autoguard-playbook
description: "Unified auto-detection and auto-fix workflow for relation visibility, relation navigation, and destructive-delete safety in vben + Supabase admin apps."
triggers: ["vben relation autoguard", "auto detect relation issue", "parent child auto fix", "typed delete relation"]
phase: orchestrator
model_hint: gpt-5.3-codex
version: 1.0
status: active
date_created: "2026-05-12"
---

# VBEN Relation AutoGuard Playbook

## Mission
When a table relation exists, the agent should auto-check and auto-fix three areas:
1. Parent/child visibility integrity
2. Relation navigation UX (blue FK links / layer icon)
3. Destructive delete safety (typed keyword + relation warning)

## Detection Pipeline
1. Read schema/migrations and store joins
2. Build parent -> child relation map
3. Compare relation map against current list/detail UI behavior
4. Flag gaps as:
   - Visibility gap
   - Navigation gap
   - Delete-safety gap

## Auto-Fix Rules
### A) Visibility Guard (mandatory)
- Child list/detail fetch must verify active parent IDs
- If parent deleted/missing: child hidden / detail null
- Child create/update must reject deleted/missing parent references

### B) Navigation Guard (conditional)
- FK display fields use `CellFkLink`
- One-to-many drilldown uses layer icon + drawer
- Avoid relation controls on non-relational tables

### C) Delete Guard (mandatory for parent-like tables)
- Show relation impact summary (child counts)
- Require typed keyword `delete`
- Block deletion on keyword mismatch

## Parent-Like Table Priority
1. tables referenced by 2+ child modules
2. tables used in assignment or workflow hub screens
3. tables with high operator impact (users/lessons/agents)

## Output Contract (for future runs)
For each detected relation table, produce:
- Current status: pass/fail per A/B/C
- Patch plan: files to change
- Safety text: 2-line warning copy
- Skill update: append relation map + fixes

## QuizLAA Baseline
This playbook should include and reuse:
- relation-visibility guard utility
- relation-aware typed delete pattern
- blue-link/layer-icon relation navigation pattern

