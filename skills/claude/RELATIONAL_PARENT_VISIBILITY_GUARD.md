---
name: relational-parent-visibility-guard
description: "Auto-hide child rows when any parent in the chain is deleted/missing, for vben admin + Supabase soft-delete schemas."
triggers: ["parent child visibility", "soft delete relation", "hide orphan rows", "ancestor chain filter", "vben relational guard"]
phase: reference
model_hint: gpt-5.3-codex
version: 1.0
status: active
date_created: "2026-05-12"
---

# Relational Parent Visibility Guard (Insert-Only Note)

## Problem
In soft-delete systems, child rows can remain visible even when parent rows are deleted.
This causes broken detail pages and incorrect admin operations.

## Policy
Before list/detail rendering, child records MUST pass active-parent checks.
If any ancestor in the relation chain is deleted or missing, child row is hidden.

## Scope Patterns
- lessons -> questions -> questionAnswers
- users -> user_lessons
- agent_profiles -> agent_reviews
- agent_profiles -> agent_leads

## Implementation Pattern
1. Keep soft-delete source of truth on each table (`isDelete=false`)
2. Fetch page candidate rows first
3. Extract parent IDs from those rows only (page-scoped)
4. Query parent table active IDs (`id` + `isDelete=false`)
5. Filter child rows by active parent ID set
6. Continue joins/formatting only for visible rows

## Performance Rule
Use page-scoped ID validation (not full-table scans).
This keeps overhead small and predictable.

## Create/Update Guard
Before create/insert into child table:
- validate referenced parent is active
- reject operation if parent is deleted/missing

## Safety Mode
On transient parent-check query failure:
- fail-open for list visibility (avoid full page outage)
- fail-closed for create (block invalid references)

## Reuse Reminder
For future vben+supabase projects, apply this guard at store layer first.
Prefer one shared utility for parent active-id checks to avoid duplicated logic.

