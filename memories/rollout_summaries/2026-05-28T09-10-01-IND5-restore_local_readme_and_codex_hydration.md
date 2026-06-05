thread_id: 019e6dd9-0d7a-7281-ad36-a6163c86d01b
updated_at: 2026-05-28T09:13:18+00:00
rollout_path: C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T17-10-01-019e6dd9-0d7a-7281-ad36-a6163c86d01b.jsonl
cwd: \\?\C:\Users\user\Documents\restore-local

# Created an AI-oriented root README for `restore-local` after first loading `.codex` routing/knowledge.

Rollout context: The user wanted the agent to study the `restore-local` folder, understand what it does step by step, then write all useful information into a new `README.md` for future AI orientation and status tracking. The user specifically interrupted once to say: "ai read .codex knowledge first then do above request in chat," so the agent first loaded Codex startup/routing knowledge before returning to the folder.

## Task 1: Read `.codex` knowledge first, then map `restore-local`

Outcome: success

Preference signals:

- The user said "ai read .codex knowledge first then do above request in chat" -> future similar requests should first hydrate the local Codex routing/knowledge context before analyzing the workspace.
- The user wanted the folder understanding written for "ai to quickly understanding this restore-local folder" -> future similar docs should be concise, AI-oriented, and optimized for rapid orientation rather than human-style prose.

Key steps:

- Read `C:\Users\user\.codex\00_CODEX_START_HERE.md`, `00_CODEX_CUSTOM_INSTRUCTIONS_CODEX_BRIDGE.md`, `CODEX_FULL_ACCESS_ROUTING.md`, and `CODEX_DYNAMIC_ROUTING.md`.
- Observed that `.codex` routing emphasizes route-first selective loading and not hydrating full trees.
- Returned to `restore-local` and inspected root files, scripts, the `restore-single` packaged snapshot, `supabase` metadata, and the `p%` scratch file.

Failures and how to do differently:

- The folder contained a loose scratch file with secret-like content (`p%`); the agent correctly avoided copying its values into the README and treated it as sensitive.

Reusable knowledge:

- `.codex` startup/routing docs are the right first read when the user explicitly asks to read Codex knowledge before continuing.
- The folder is an operations/recovery workspace, not an app source tree, so AI orientation should focus on backup/restore workflows, packaged snapshots, and path assumptions.

References:

- `[1]` User instruction: "ai read .codex knowledge first then do above request in chat."
- `[2]` Codex startup docs read: `00_CODEX_START_HERE.md`, `CODEX_DYNAMIC_ROUTING.md`, `CODEX_FULL_ACCESS_ROUTING.md`.

## Task 2: Analyze `restore-local` and write `README.md`

Outcome: success

Preference signals:

- The user asked to "study this folder see what they do and know what they are, what their flow understanding it step by step and then write down every information ai get from here ... and save in a new files call readme.md" -> future similar tasks should produce a folder map plus step-by-step workflow, not just a brief summary.
- The user also wanted the README to be used for "ai to quickly understanding this restore-local folder and its information also saving the status or step for future updates here" -> future similar docs should include a status/update section and maintenance checklist.

Key steps:

- Inspected `backup-local.bat`, `restore-local.bat`, `restore-single.bat`, `restore-trash.bat`, `reset & restore-supabase.bat`, `extract_angelInterior.ps1`, `extract_quizlaa.ps1`, `extract_quizlaa.py`, and `vps comand.txt`.
- Read `restore-single\trash-20260522-140801\trash-20260522-140801\manifest.json` and confirmed the packaged project is `Trash` / schema `trash`.
- Read sample packaged files including `edge-functions\main\index.ts`, `edge-functions\create-user\index.ts`, and `08-public-functions.sql` to understand what the snapshot contains.
- Created `README.md` at the folder root and verified it by reading it back.

Failures and how to do differently:

- No functional failure in the write path, but one important mismatch was discovered: `restore-trash.bat` points to `C:\Users\user\Documents\restore-local\trash-20260522-140801\trash-20260522-140801`, while the actual packaged snapshot exists under `restore-single\trash-20260522-140801\trash-20260522-140801`. Future agents should check this path before relying on `restore-trash.bat`.
- The root contains inconsistent path conventions across scripts (`install-supabase\supabase\docker` vs `local-supabase\supabase`), so future edits should re-check hardcoded paths before assuming portability.

Reusable knowledge:

- `backup-local.bat` is the local backup creator: it detects non-system schemas, writes `schemas.txt`, dumps full/schema/custom/auth/storage/grants SQL, zips storage and functions, and optionally copies `.env`.
- `restore-local.bat` performs a full local restore: it drops custom schemas, clears auth/storage metadata, restores SQL dumps, reapplies grants, restores storage/functions, restarts containers, and verifies counts.
- `restore-single.bat` is the safer project-level restore path: it reads nested `manifest.json`, restores only one selected schema/project, and leaves other schemas/projects untouched.
- `restore-trash.bat` is a hardcoded one-project shortcut for `trash`; it includes a JWT hook reminder and verification queries, but its backup path appears stale.
- `reset & restore-supabase.bat` is the VPS sync controller with three modes: full VPS→local restore, pull one schema VPS→local, and push one schema local→VPS.
- `extract_angelInterior.ps1`, `extract_quizlaa.ps1`, and `extract_quizlaa.py` all perform schema extraction from a `backup_full.sql` using pg_dump block parsing.
- `vps comand.txt` is a shell payload used to create `/home/zetatech/full_backup.sh` on the VPS; the embedded script backs up full SQL, custom SQL, auth, storage metadata, storage zip, edge functions zip, grants, env, and backup metadata.
- `restore-single\trash-20260522-140801\trash-20260522-140801\manifest.json` records `projectName=Trash`, `schema=trash`, `projectId=fddcc8d4-2f70-4cdc-b5a4-b2fee7b9d8f6`, row counts, and included files.
- The packaged `trash` snapshot includes schema/data SQL, grants, storage policies, public functions, edge functions, and storage files.

References:

- `[1]` Written file: `C:\Users\user\Documents\restore-local\README.md`
- `[2]` Manifest evidence: `restore-single\trash-20260522-140801\trash-20260522-140801\manifest.json` with `schema: trash`, `projectName: Trash`, `projectId: fddcc8d4-2f70-4cdc-b5a4-b2fee7b9d8f6`.
- `[3]` Script evidence: `backup-local.bat`, `restore-local.bat`, `restore-single.bat`, `restore-trash.bat`, `reset & restore-supabase.bat`.
- `[4]` Sensitive-file warning: `p%` contains credential-like/access-like values and should not be copied into future summaries.

