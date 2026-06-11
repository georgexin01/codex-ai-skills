---
name: awards-gallery-agent-detail-pattern
description: "Simple neutral Awards Gallery rendering standard for Agent Detail modules + storage-path safety checks across admin and consumer sites."
triggers: ["awards gallery", "agent detail gallery", "agent achievements", "gallery card render", "upload path consistency"]
phase: reference
model_hint: gpt-5.3-codex
version: 1.0
status: active
date_created: "2026-05-12"
---

# Awards Gallery Agent Detail Pattern (Insert-Only Note)

## Goal
Prevent raw JSON rendering in Agent Detail and keep a simple, low-color gallery design that is readable in dark themes.

## Scope
Applies to all Agent Detail surfaces that display `agent_profiles.achievements`:
- Agent module detail drawer/page
- Any cross-module detail entry that reuses Agent Detail

## Rendering Contract
`achievements` must be normalized before rendering:
1. Preferred shape: array of objects
   - `{ photo, title, year, caption }`
2. Legacy shape: object keyed by index
   - convert `Object.values(achievements)` into the same card shape
3. Ignore entries without `photo`

Never print raw object JSON in UI cards.

## Design Standard (Simple / Minimal)
- Use neutral container: subtle border + low-opacity dark background
- Image-first card layout
- Small typography hierarchy:
  - title (strong)
  - year (small outline badge)
  - caption (muted text)
- No heavy gradients, neon accents, or mixed color chips
- Empty state uses dashed neutral border with short helper text

## Storage URL Safety Rule
For gallery photos and reviewer photos:
- Persist relative storage path in DB (example: `agents/goh-keng-yen/cover-page.jpeg`)
- Convert to absolute URL at render time via storage URL helper
- Keep one bucket source of truth per project (`quizLaa`)

## Cross-App Consistency Checklist
When admin upload works in localhost but breaks after build/domain split:
1. Confirm bucket path format is relative, not local web path
2. Confirm consumer apps use storage URL builder, not site-relative `/uploads/...`
3. Confirm runtime `SUPABASE_URL` points to online API in production
4. Confirm the same bucket is readable by anon/public policy if public rendering is required
5. Validate at least one uploaded file URL from:
   - Admin detail view
   - Website agent detail
   - Website review list

## Reuse Reminder
For other admin + Supabase projects, apply the same pattern to every image-upload table:
- normalize DB shape
- resolve URL via storage helper
- render with neutral card UI
- validate cross-domain production path after build

