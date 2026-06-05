---
name: project-handoff-doc-stack
description: Use when a project needs durable AI/Claude/Codex handoff docs so future agents can resume without re-reading the whole workspace. Creates or maintains a root documentation stack such as AI_START_HERE.md, BLUEPRINT.md, MASTER_PLAN.md, DATABASE.md, CROSSWALK.md, inventory docs, and sync rules.
metadata:
  short-description: Build reusable root handoff docs for AI projects
---

# Project Handoff Doc Stack

Use this skill when the user wants future AI agents to understand a project quickly and continue work without repeating discovery.

## Generic Root Stack

Recommended files:

- `AI_START_HERE.md` - first-read entrypoint, folder meanings, triggers, current phase.
- `BLUEPRINT.md` - one-screen workspace map and hard rules.
- `MASTER_PLAN.md` - phases, gates, checklists, risk register, verification matrix.
- `DATABASE.md` - database/auth/RLS/schema source of truth when a database exists.
- `TABLE_STRUCTURE.md` - quick human table overview.
- `DATABASE_MARKMAP.md` - optional Markdown-backed database mindmap.
- `CROSSWALK.md` - entity to table to module to route to permission mapping.
- `*_INVENTORY.md` - current-state inventory for legacy, active, or reference folders.
- `*_SYNC.md` - synchronization rules when multiple docs mirror the same source.

## Rules

- Keep project-specific facts in the project root docs, not global memory, unless the user explicitly asks for a generic reusable extraction.
- Keep the entrypoint small and route-first; do not force agents to read every document.
- Mark locked/read-only folders clearly.
- Record current phase and next task in the entrypoint and master plan.
- Put implementation gates in writing when schema/design changes should not automatically modify code.
- Update docs in the same task as code/schema changes.

## Trigger Pattern

If the user says `start plan`, `start planning`, or `start my plan`, load the root stack in this order:

1. `AI_START_HERE.md`
2. `BLUEPRINT.md`
3. `MASTER_PLAN.md`
4. `CROSSWALK.md` when module/database routing matters
5. Task-specific docs only after the route is known

## Quality Bar

A good handoff stack lets a new agent answer:

- Which folder is source of truth?
- Which folder is active implementation?
- Which folder is locked reference?
- What phase are we in?
- What is the next safe task?
- Which docs must change when schema, routes, permissions, or implementation changes?
