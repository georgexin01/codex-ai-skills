---
name: laa-project-snapshot
description: "Per-project living snapshot written by the claude build tracks (13-brain-hardening, 06-seeding, 12-ui-refactor). Holds production URL, seed data table, credentials pointers, and architecture summary so future AI sessions resume without reading code. Recreated 2026-06-11 — path was referenced by skills but missing on disk."
triggers: ["project snapshot", "laa snapshot"]
version: 1.0
status: living-document
date_updated: "2026-06-11"
---

# LAA Project Snapshot

> Living document. Skills append/update sections below; never delete history without a rot-audit.
> Writers: `skills/claude-website/13-brain-hardening` (architecture), `skills/claude-website/06-seeding` (seed table), `skills/claude-app/13-native-pwa-deploy` (production URL + credentials pointer).

## Current Project

- Project: _(unset — first writer fills this)_
- Schema: _(business schema name, never `public`)_
- Production URL: _(unset)_
- Local dev: admin `localhost:6006` (Vben, `pnpm.cmd run dev:local`) · website `php -S 127.0.0.1:<port>`

## Seed Data

| Table | Rows | Notes |
|---|---|---|
| _(none recorded yet)_ | | |

## Credentials Pointer

Never store real secrets here — record only *where* they live (env file path, vault key name).

## Architecture Summary

_(13-brain-hardening writes hardened learnings here per session)_

## Session Log

| Date | Track | What changed |
|---|---|---|
| 2026-06-11 | maintenance | Snapshot file recreated at canonical path `memories/3_domains/claude/` |
