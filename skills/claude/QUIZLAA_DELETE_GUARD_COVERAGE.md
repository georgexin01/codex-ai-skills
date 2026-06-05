---
name: quizlaa-delete-guard-coverage
description: "Current strict delete coverage status for parent tables in admin-panel-quizLaa."
triggers: ["quizlaa delete coverage", "strict delete coverage", "parent delete guard status"]
phase: reference
model_hint: gpt-5.3-codex
version: 1.0
status: active
date_created: "2026-05-12"
---

# QuizLAA Strict Delete Coverage

## Parent Tables Requiring Typed Delete
1. users
2. lessons
3. agent_profiles

## Status
- agent_profiles: IMPLEMENTED (relation warning + type `delete`)
- users: IMPLEMENTED (relation warning + type `delete`)
- lessons: IMPLEMENTED (relation warning + type `delete`)

## Relation Warning Counts
- users: assignments (`user_lessons`), quiz results (`questionAnswers`), agent profiles (`agent_profiles`)
- lessons: questions (`questions`), quiz results (`questionAnswers`), assignments (`user_lessons`)
- agent_profiles: reviews (`agent_reviews`), leads (`agent_leads`)

## UI Rule
Only parent-like relation tables get strict typed-delete.
Non-relational tables keep standard confirmation to avoid unnecessary friction.

