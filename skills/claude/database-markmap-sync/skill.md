---
name: database-markmap-sync
description: Claude/Vben workflow helper for keeping DATABASE.md, TABLE_STRUCTURE.md, and DATABASE_MARKMAP.md synchronized during Supabase/Postgres admin-panel planning. Use Markdown/Markmap as the human mindmap source and require user approval before implementation changes.
---

# Database Markmap Sync

Use for Vben/Supabase projects where the user wants a human-viewable mindmap that stays aligned with Markdown database planning.

## Required Files

- `DATABASE.md` - canonical schema/auth/RLS contract.
- `TABLE_STRUCTURE.md` - quick human table view.
- `DATABASE_MARKMAP.md` - Markdown-backed Markmap mindmap.
- Optional crosswalk doc - table to module, route, and permission mapping.

## Rules

- Markdown is the source of truth, not binary `.xmind`.
- Include Supabase/Postgres types in the mindmap: `uuid`, `text`, `int`, `bigint`, `boolean`, `date`, `timestamptz`, and `jsonb`.
- Use schema-qualified names and `snake_case`.
- Include primary keys, foreign references, uniqueness, nullability, and defaults when known.
- If Vben admin code is involved, never implement module changes from a mindmap update without explicit user approval.

## Flow

1. Read the database contract.
2. Update the table quick-view.
3. Update the Markmap mindmap.
4. Update module/permission crosswalk if mappings changed.
5. Stop before code implementation unless the user approves.
