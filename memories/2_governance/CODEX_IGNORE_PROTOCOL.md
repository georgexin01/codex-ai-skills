---
name: codex-ignore-protocol
description: "Project-level Codex ignore contract for AI indexing, routing, and cleanup hygiene."
triggers: ["codexignore", ".codexignore", "ignore setting", "ai ignore", "codex ignore"]
phase: governance
version: 1.0
status: active
date_updated: "2026-05-12"
---

# Codex Ignore Protocol

## Mission

Every project that Codex, Gemini, Claude, or Antigravity works on should carry an explicit AI ignore contract. The contract prevents agents from indexing runtime noise, generated outputs, secrets, browser/session artifacts, and local tool state while keeping durable project knowledge visible.

## Required Project Files

When a project has AI-assisted development, check for these files before indexing, routing, cleanup, build work, or broad search:

- `.gitignore`: Git and deployment exclusion contract.
- `.geminiignore`: Gemini/Antigravity AI-index exclusion contract.
- `.codexignore`: Codex AI-index exclusion contract.
- `AGENTS.md`: project instructions, if present.
- `BLUEPRINT.md`: project brain, if present.

If `.codexignore` is missing, create it from the project context instead of blindly copying a global file. Keep it readable and conservative.

## Codex Ignore Baseline

A project `.codexignore` should usually exclude:

```gitignore
node_modules/
vendor/
dist/
build/
coverage/
.vite/
cache/
storage/
tmp/
temp/
test-results/
.phpunit.cache/
.pytest_cache/
*.log
*.tmp
*.cache
.env
.env.*
*.key
*.token
*.secret
auth/
cookies/
sessions/
browser_recordings/
.codex/
.sandbox/
.sandbox-bin/
.sandbox-secrets/
codex-sessions/
session_index.jsonl
*.sqlite
*.sqlite-shm
*.sqlite-wal
```

For projects with generated media, also exclude generated output folders when files can be regenerated or sourced again, such as `assets/img/generated/` and `uploads/generated/`.

## Keep Visible

Do not hide durable instruction or project-brain files from AI routing:

```gitignore
!.codexignore
!.geminiignore
!AGENTS.md
!BLUEPRINT.md
```

Do not ignore reference projects or approved source folders just because they are large. If a folder is used as a design/source reference, leave it visible unless the user explicitly asks to remove or ignore it.

## Safety Rules

- Secrets and credential-like files stay excluded unless the user explicitly asks and the action is safe.
- Runtime SQLite, sessions, cookies, browser profiles, auth stores, and recordings stay excluded by default.
- Historical memory is not the source of truth for current ignore rules. Read current project files first.
- Current project `.codexignore` and `.geminiignore` override generic templates when they are more specific.
- Update `.gitignore`, `.geminiignore`, and `.codexignore` together when the same exclusion affects Git, Gemini, and Codex.

## EcoWorld 2026-05-12 Baseline

For `C:\Users\user\Desktop\ecoworld`, Codex ignore was initialized as a project-level file, not a global Codex-home file. The project keeps `_reference/`, `website-LAA-agent/`, and `website-LAA-website/` visible because they are useful reference folders for this workspace.
