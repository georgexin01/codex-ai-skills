---
name: quizlaa-admin-relation-map
description: "Concrete relation map + parent-visibility filter coverage for admin-panel-quizLaa tables."
triggers: ["quizlaa relation map", "admin relation audit", "child visibility map"]
phase: reference
model_hint: gpt-5.3-codex
version: 1.0
status: active
date_created: "2026-05-12"
---

# QuizLAA Admin Relation Map (Parent-Visibility)

## Verified Relations
- users.id -> agent_profiles.user_id
- agent_profiles.id -> agent_reviews.agent_profile_id
- agent_profiles.id -> agent_leads.agent_profile_id
- lessons.id -> questions.lessonId
- users.id -> questionAnswers.userId
- lessons.id -> questionAnswers.lessonId
- users.id -> user_lessons.userId (logical relation in current schema)
- lessons.id -> user_lessons.lessonId (logical relation in current schema)

## Guard Coverage (Implemented)
- stores/agent.ts
- stores/review.ts
- stores/lead.ts
- stores/questions.ts
- stores/question-answers.ts
- stores/user-lessons.ts
- stores/users.ts (assignment count consistency)
- utils/relation-visibility.ts (shared active-parent id validator)

## Expected Behavior
When parent is deleted/missing:
- Child rows are hidden from list fetch.
- Child detail fetch returns null/not found.
- Create/update that references deleted parent is blocked.

## Design Intent
This pattern avoids forcing staff to manually delete every child row while preserving soft-delete history.

