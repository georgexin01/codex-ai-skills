---
name: markdown-database-mindmap
description: Use when a project needs a database schema contract synchronized with a human-viewable VS Code mindmap. Prefer Markdown/Markmap over binary XMind for Supabase/Postgres planning, schema-qualified table naming, SQL column types, and AI/human database collaboration.
metadata:
  short-description: Sync database markdown with a Markmap mindmap
---

# Markdown Database Mindmap

Use this skill when a user wants a database structure that is both AI-editable and human-viewable as a mindmap inside VS Code.

## Core Pattern

Keep three Markdown files synchronized:

1. `DATABASE.md` - canonical schema/auth/RLS contract.
2. `TABLE_STRUCTURE.md` - quick human table overview.
3. `DATABASE_MARKMAP.md` - Markdown-backed mindmap rendered by Markmap or MindMark.

Avoid making `.xmind` the source of truth. Binary mindmap files are harder to diff, repair, and keep synchronized. If exported diagrams exist, treat them as optional exports only.

## Supabase/Postgres Naming Rules

- Use schema-qualified names, for example `public.user` or `app.blog_posts`.
- Use `snake_case` for schemas, tables, columns, constraints, and permission keys.
- Use `uuid` primary keys with `default gen_random_uuid()` unless the project has an existing ID convention.
- Use `project_id uuid` for project-scoped app tables.
- Use `timestamptz` for timestamps.
- Use `jsonb` for structured page/content/config blocks.
- Use join tables with composite primary keys for many-to-many relationships.
- Do not overload Supabase/PostgREST reserved JWT claim `role`; use application claims such as `user_role`, `project_id`, and `role_level`.

## Markmap File Shape

Start `DATABASE_MARKMAP.md` with Markmap frontmatter:

```markdown
---
markmap:
  colorFreezeLevel: 2
  maxWidth: 420
---

# Project Database
```

For every table, include purpose, column name, SQL type, nullability, defaults, keys, uniqueness, and foreign references when known.

## Sync Workflow

When schema changes:

1. Update `DATABASE.md` first.
2. Update `TABLE_STRUCTURE.md` for quick reading.
3. Update `DATABASE_MARKMAP.md` with the same tables, column names, and SQL types.
4. Update module/route/permission crosswalk docs if present.
5. Do not update implementation code until the user approves the implementation phase.

When the user edits the mindmap Markdown, treat it as a proposed schema change and sync back to `DATABASE.md` before implementation.

## VS Code Extensions

Recommend one or more:

- `gera2ld.markmap-vscode` - open Markdown as Markmap.
- `phoihos.markdown-markmap` - Markmap support in Markdown preview.
- `Graveon.mindmark` - Markdown mindmap editor option.
- `hediet.vscode-drawio` - optional manual diagram editor, not canonical.
