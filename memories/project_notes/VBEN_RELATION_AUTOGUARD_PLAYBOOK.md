---
name: vben-relation-autoguard-playbook
description: "Unified auto-detection and auto-fix workflow for relation visibility, relation navigation, and destructive-delete safety in vben + Supabase admin apps."
triggers: ["vben relation autoguard", "auto detect relation issue", "parent child auto fix", "typed delete relation"]
phase: orchestrator
model_hint: gpt-5.3-codex
version: 1.1
status: active
date_created: "2026-05-12"
date_updated: "2026-05-29"
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
- Use page-scoped parent ID validation, not full-table scans.
- List/detail visibility may fail open on transient parent-check errors; create/update must fail closed.
- Implement first at the store/shared utility layer to avoid copied per-view logic.

### B) Navigation Guard (conditional)
- FK display fields use `CellFkLink`
- One-to-many drilldown uses layer icon + drawer
- Avoid relation controls on non-relational tables
- Use blue FK text for direct parent navigation (`userName`, `lessonTitle`, `agentName`).
- Use a layer icon only for meaningful one-to-many child stacks.
- Validate the target drawer exists and receives the required ID payload.

### C) Delete Guard (mandatory for parent-like tables)
- Show relation impact summary (child counts)
- Require typed keyword `delete`
- Block deletion on keyword mismatch
- Recommended copy line 1: `Related data found (Reviews: X, Leads: Y). Child records will be hidden.`
- Recommended copy line 2: `Type "delete" to confirm.`
- Keep typed keyword lowercase and exact.

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

### QuizLAA Applied Cases
- Parent tables requiring typed delete: `users`, `lessons`, `agent_profiles`.
- Strict delete coverage status: `users`, `lessons`, and `agent_profiles` implemented.
- Relation warning counts:
  - `users`: assignments (`user_lessons`), quiz results (`questionAnswers`), agent profiles (`agent_profiles`)
  - `lessons`: questions (`questions`), quiz results (`questionAnswers`), assignments (`user_lessons`)
  - `agent_profiles`: reviews (`agent_reviews`), leads (`agent_leads`)
- Navigation cases:
  - Agent List: `userName` opens User Detail drawer.
  - Assign Lessons: `userName` opens User Detail drawer.
  - Lessons: layer icon opens Questions drawer.
  - Questions: layer icon opens Question Answers drawer.
  - Reviews/Leads: `agentName` opens Agent Detail drawer.

## Consolidation Note
On 2026-05-29, the duplicate memory notes below were merged here and removed from `memories/project_notes/` because identical copies remain under `skills/claude/`:
- `RELATIONAL_PARENT_VISIBILITY_GUARD.md`
- `RELATION_AWARE_TYPED_DELETE.md`
- `RELATION_NAVIGATION_BLUE_LINK_LAYER_ICON.md`
- `QUIZLAA_DELETE_GUARD_COVERAGE.md`

