---
name: relation-navigation-blue-link-layer-icon
description: "Rule set for relation navigation in vben tables: when to use blue FK text vs layer icon drawers."
triggers: ["relation blue text", "layer icon relation", "fk navigation", "drawer relation navigation"]
phase: reference
model_hint: gpt-5.3-codex
version: 1.0
status: active
date_created: "2026-05-12"
---

# Relation Navigation Pattern (Blue Link vs Layer Icon)

## Goal
Ensure relational tables have fast, obvious navigation to parent/child modules without adding noise to unrelated tables.

## Decision Rules
1. Use **Blue FK text** when a column is a direct FK display (`userName`, `lessonTitle`, `agentName`).
2. Use **Layer icon** when a row should open a relation hub or child-module stack (one-to-many exploration).
3. Use both when both behaviors are meaningful and non-duplicative.
4. Do not add relation controls on non-relational columns/tables.

## QuizLAA Applied Cases
- Agent List: `userName` -> open User Detail drawer (blue link)
- Assign Lessons: `userName` -> open User Detail drawer (blue link)
- Existing good patterns retained:
  - Lessons: layer icon -> Questions drawer
  - Questions: layer icon -> Question Answers drawer
  - Reviews/Leads: `agentName` blue link -> Agent Detail drawer

## Extension Checklist For New Tables
- Identify FK columns from schema or store join fields.
- Add `CellFkLink` for direct FK fields.
- Add layer icon only if child aggregation workflow exists.
- Validate drawer target exists and receives required ID payload.

