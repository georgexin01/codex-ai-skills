thread_id: 019e8b77-e02a-7982-851a-1b00ab985674
updated_at: 2026-06-04T08:09:46+00:00
rollout_path: C:\Users\user\.codex\sessions\2026\06\03\rollout-2026-06-03T11-12-29-019e8b77-e02a-7982-851a-1b00ab985674.jsonl
cwd: \\?\C:\Users\user\Desktop\angel-interior

# Root cleanup and ignore-file hygiene were audited and partially cleaned, with a few locked/runtime artifacts left intentionally in place.

Rollout context: The user asked to inspect the repository root and supporting folders for legacy, duplicated, or unnecessary files, then safely clean what can be removed without harming the working workspace. They also asked to review ignore files in the root/admin/website folders and tighten them only where it would reduce noise or save space without hiding important source, docs, migrations, or runtime behavior.

## Task 1: Root cleanup and startup-script deprecation
Outcome: success

Preference signals:
- The user asked to "check root folder" for old/legacy content like `.log`, `.ps1`, and duplicate `.md` files, indicating a preference for workspace hygiene and pruning stale handoff files.
- The user specifically questioned whether `start.ps1` / `stop.ps1` were "really necessary" and asked for a better way to start/stop localhost testing, implying preference for the simplest current workflow over duplicate wrapper scripts.
- The user said to ask if anything is hard to decide, indicating that ambiguous deletions should be paused instead of guessed.

Reusable knowledge:
- In this workspace, the direct website-start workflow is now the canonical one: `php -S 127.0.0.1:8000 index.php` from `website-angel-interior/`.
- The old root `start.ps1` / `stop.ps1` wrappers were stale and hardcoded an outdated admin port (`6007`), so they were safe to remove once `STATUS.md` was updated.
- `run-local.bat` remains the website-local helper, but the root handoff now points to the direct `php -S` command as the current command of record.
- `AI_START_HERE.md` and `BLUEPRINT.md` were removed from the root because their active guidance was already duplicated in `STATUS.md`, `DATABASE.md`, `CROSSWALK.md`, `CLAUDE.md`, and the `.codex` skills.
- `php-seo-debug.log` could not be deleted because it was locked by a running process, but it is now ignored so it won’t keep polluting the workspace.

Failures and how to do differently:
- One temp/debug log (`php-seo-debug.log`) could not be removed because another process had it open. Future cleanup should stop the process first if deletion is desired.
- Some stale root references (`admin-panel-trash`, removed docs/scripts) needed explicit handoff updates in `STATUS.md` to avoid leaving broken pointers after file deletion.

References:
- Removed root files: `AI_START_HERE.md`, `BLUEPRINT.md`, `start.ps1`, `stop.ps1`, `.tmp-blog-api.json`.
- Updated root handoff: `STATUS.md` now points to `php -S 127.0.0.1:8000 index.php` for the website and no longer treats `admin-panel-trash` as an active reference in the workflow guidance.
- Locked log left in place because of file lock: `php-seo-debug.log`.

## Task 2: Ignore-file tightening across root, admin, and website
Outcome: success

Preference signals:
- The user asked to check the ignore files "in root folder and inside admin-panel or website folder" to save space but avoid impacting working files, indicating a preference for conservative ignore updates that reduce noise without hiding anything important.
- The user explicitly wanted existing important/necessary files preserved, so ignore changes were limited to temp/debug/runtime artifacts and not source, migrations, docs, or env templates.

Reusable knowledge:
- Root ignore files now consistently exclude harmless workspace noise such as `**/.tmp-*.json` and `php-seo-debug.log`.
- All four AI ignore files (`.codexignore`, `.claudeignore`, `.geminiignore`, `.openaiignore`) were updated together so they stay synchronized and no longer keep the deleted `BLUEPRINT.md` path as a visible durable doc.
- `admin-panel-angel/.gitignore` now ignores the local `.codex-dev-local.log` and the AI-tool folders `.codex/`, `.gemini/`, and `.openai/`.
- `admin-panel-angel/.dockerignore` now correctly names the active project (`admin-panel-angel`), not the old `admin-panel-trash`, and also ignores the same local AI tool folders.
- `website-angel-interior/.gitignore` now ignores `run-local-*.log` and `*.temp` in addition to existing runtime noise.
- The root `.gitignore` already had a strong base; only narrowly safe additions were made, so important code/docs/migrations remain visible.

Failures and how to do differently:
- A broad patch against the AI ignore files initially failed because of mismatched keep-rule lines; the safer fix was to patch each ignore file in smaller chunks.
- The workspace has a lot of historical doc duplication; future cleanup should keep the canonical docs (`STATUS.md`, `DATABASE.md`, `CROSSWALK.md`, `SEO_TABLES_PLAN.md`, `.codex` skills) as the source of truth rather than deleting everything that looks repeated.

References:
- Root ignore additions: `**/.tmp-*.json`, `php-seo-debug.log`.
- AI ignore sync: removed `BLUEPRINT.md` keep-rules and added the same temp/debug exclusions to `.codexignore`, `.claudeignore`, `.geminiignore`, and `.openaiignore`.
- Admin ignore additions: `.codex-dev-local.log`, `.codex/`, `.gemini/`, `.openai/`.
- Website ignore additions: `run-local-*.log`, `*.temp`.
