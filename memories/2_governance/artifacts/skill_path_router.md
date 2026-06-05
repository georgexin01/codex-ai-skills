---
name: skill-path-router
description: "Canonical skill path index - maps trigger phrases to exact skill entry points. Read this before scanning skill directories."
triggers: ["skill path router", "skill_path_router", "ai read .codex skills", "which skill", "what skill"]
version: 2.1
date_updated: "2026-06-04"
status: authoritative
---

# SKILL PATH ROUTER V2.1

## How to use
1. Match the user trigger phrase against the table below.
2. Read only the matched skill file - do not scan the full skill tree.
3. If no match, fall back to `skills/` directory listing and frontmatter `description`.

## Trigger to Entry Point Map

| Trigger | Entry Point | What it covers |
|---|---|---|
| `ai claude` | `skills/claude/WORKING_PROGRESS.md` | Vben Admin module builder - 41 linear micro-tasks for admin/schema-owner work |
| `ai claude app` | `skills/claude-app/WORKING_PROGRESS.md` | Mobile app Vue builder - app/mobile workflow |
| `ai claude website` | `skills/claude-website/WORKING_PROGRESS.md` | PHP + Supabase REST builder - 45 linear micro-tasks |
| `ai starting point` | `skills/starting-point/skill.md` | New project bootstrap for PHP website + Vben Admin + Docker Supabase |
| `ai clean module` | `skills/clean-module/skill.md` | Remove old project modules from a copied Vben admin while keeping shared infrastructure |
| `ai personality` | `skills/ai-personality/skill.md` | Professional AI role and behavior profile for Codex and Claude Code |
| `DB handshake (shared)` | `skills/SHARED_DB_CONTRACT.md` | Shared schema, bucket, project_id, env matrix, and ownership rule |
| `ai claude meta` | `skills/claude-meta/SKILL.md` | Claude meta-skills and self-improvement patterns |
| `ai design app` | `skills/design/app/SKILL.md` | Mobile app design execution |
| `ai design website` | `skills/design/website/SKILL.md` | Website design execution |
| `ai design spec` | `skills/design/_spec/SKILL.md` | DESIGN.md contract layer, lint rules, and export guidance |
| `ai karpathy` | `skills/karpathy-guidelines/SKILL.md` | Karpathy coding quality rules |
| `ai imagegen` | `skills/imagegen/SKILL.md` | Image generation workflows and free-asset fallback |
| `ai markdown mindmap` | `skills/markdown-database-mindmap/SKILL.md` | Database schema to Markmap visualization |
| `ai project handoff` | `skills/project-handoff-doc-stack/SKILL.md` | Durable root handoff docs, project truth docs, and sync rules |

## Recipe and Knowledge Triggers

These point at executable recipes and foundational knowledge docs, not skills.

| Trigger | Entry Point | What it covers |
|---|---|---|
| `ai recipe blueprint` | `memories/CLAUDE_BLUEPRINT_RECIPE.md` | Generate durable project blueprint docs |
| `ai recipe mobile app` | `memories/MOBILE_APP_DESIGN_RECIPE.md` | Canonical mobile aesthetic recipe |
| `ai recipe image to app` | `memories/IMAGE_TO_MOBILE_APP_PIPELINE.md` | Convert design images into Vue mobile app structure |
| `ai recipe header footer` | `memories/1_core/HEADER_FOOTER_DESIGN_RULES.md` | Header and bottom-nav rules |
| `ai recipe free images` | `memories/1_core/IMAGE_SOURCING_FREE.md` | Free image sourcing waterfall |
| `ai recipe pwa` | `memories/1_core/PWA_FAVICON_META_SETUP.md` | PWA and meta setup |
| `ai design sop` | `memories/1_core/DESIGN_SOP.md` | Page-level structural manifest |
| `ai design evolution` | `memories/1_core/DESIGN_EVOLUTION_PROTOCOL.md` | Design-sense evolution framework |
| `ai user dna` | `memories/0_apex/USER_DNA.md` | Tier-0 taste profile |
| `ai gitnexus` | `memories/2_governance/GITNEXUS.md` | GitNexus workflow and allowlist |
| `ai drift guard` | `memories/2_governance/DRIFT_GUARD_PROTOCOL.md` | Anti-drift protocol |
| `ai knowledge rot` | `memories/2_governance/KNOWLEDGE_ROT_PROTOCOL.md` | Anti-entropy governance |
| `vben relation autoguard` / `typed delete relation` / `parent child visibility` / `relation navigation` | `memories/project_notes/VBEN_RELATION_AUTOGUARD_PLAYBOOK.md` | Merged Vben relation and deletion patterns |

## Sub-skill Index

### `skills/claude/` sub-skills
| Sub-skill | Path |
|---|---|
| Full module | `skills/claude/create-module/skill.md` |
| Schema analysis | `skills/claude/analyze-schema/skill.md` |
| Pinia store + CRUD | `skills/claude/generate-store/skill.md` |
| Supabase SQL + RLS | `skills/claude/generate-supabase-schema/skill.md` |
| Vue views + drawers | `skills/claude/generate-views/skill.md` |
| Vue Router module | `skills/claude/generate-route/skill.md` |
| i18n | `skills/claude/generate-i18n/skill.md` |
| Image upload + crop | `skills/claude/image-upload-spec/skill.md` |
| E2E tests | `skills/claude/generate-e2e/skill.md` |
| Workflow tests | `skills/claude/workflow-test/skill.md` |
| Supabase auth architecture | `skills/claude/supabase-auth-architecture/skill.md` |
| RLS + RBAC design | `skills/claude/supabase-rls-rbac-design.md` |
| MCP Supabase connection | `skills/claude/mcp-supabase-postgres-connection.md` |
| Local Docker lessons | `skills/claude/VBEN_SUPABASE_LOCAL_LESSONS.md` |
| SEO tables planner | `skills/claude/seo-tables-planner/skill.md` |

### `skills/design/` sub-skills
| Sub-skill | Path |
|---|---|
| App spec examples | `skills/design/_spec/examples/atmospheric-glass/` |
| Website step 4 | `skills/design/website/04-php-modularization/skill.md` |
| Website step 5 | `skills/design/website/05-hero-cinematics/skill.md` |
| Website step 6 | `skills/design/website/06-component-engineering/skill.md` |

## System Skills
- `skills/.system/skill-installer/SKILL.md` - install skills from GitHub
- `skills/.system/skill-creator/SKILL.md` - create new skill packages
- `skills/.system/plugin-creator/SKILL.md` - create OpenAI plugins
- `skills/.system/openai-docs/SKILL.md` - OpenAI API reference

## Excluded from Routing
- `skills/faucet/` - excluded per `router-config.json`
- `skills/normal/` - reference library only, no direct triggers
