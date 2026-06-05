---
name: relation-aware-typed-delete
description: "Destructive action guard: relation warning + mandatory typed keyword confirmation for parent-linked tables."
triggers: ["typed delete confirm", "relation aware delete", "dangerous delete guard", "parent child delete warning"]
phase: reference
model_hint: gpt-5.3-codex
version: 1.1
status: active
date_created: "2026-05-12"
---

# Relation-Aware Typed Delete (Admin Pattern)

## Why
Soft-delete systems with parent-child relations need stronger operator safety.
A normal click-confirm is too easy for high-impact records.

## Pattern
Before delete executes:
1. Show relation warning summary (child table counts)
2. Require user to type exact keyword: `delete`
3. Block delete if keyword does not match

## Recommended 2-Line Warning Copy
Line 1: `Related data found (Reviews: X, Leads: Y). Child records will be hidden.`
Line 2: `Type "delete" to confirm.`

## UX Rules
- Keep copy short and explicit
- Show child count summary when available
- Use danger-confirm button style
- Keep typed keyword lowercase and exact (`delete`)

## Scope
Apply to parent-like tables first (e.g. users, lessons, agent_profiles), then extend to other sensitive tables.

## Integration Notes
- Pair with parent-visibility guard (child fetch filter)
- Keep logic in shared delete util so new modules can reuse it
- For new tables, pass relation metadata to modal to avoid hardcoded strings

