thread_id: 019e6ddf-f0df-7311-9f73-b76444e6e4a9
updated_at: 2026-05-28T09:52:30+00:00
rollout_path: C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T17-17-33-019e6ddf-f0df-7311-9f73-b76444e6e4a9.jsonl
cwd: \\?\C:\Users\user\Documents\restore-local

# Restore/sync script documentation and hardening for `restore-local`

Rollout context: The user asked to document the `restore-local` folder in a new README, then repeatedly clarified how the restore scripts differ and how much destructive behavior is acceptable when pushing from local to VPS. The session also uncovered that option 3 in `reset & restore-supabase.bat` was stopping “half way” because it called `backup-local.bat`, which ended in a hard `pause`.

## Task 1: Document the `restore-local` folder and its workflows

Outcome: success

Preference signals:

- The user asked to “study this folder… understand it step by step… write down every information… in a new files call readme.md” -> future responses should default to a folder-oriented README that explains purpose, flow, status, and update notes, not just a terse file list.
- The user asked to “save the status or step for future updates here.. for ai easily reading and understanding situation here” -> future docs should include an explicit current status / maintenance section, not only static file descriptions.

Key steps:

- Read the root scripts, the `restore-single` package, and the `.codex` routing/knowledge boot files before writing the README.
- Wrote `README.md` at the repo root with: folder purpose, script map, step-by-step backup/restore flows, the packaged `trash` snapshot summary, path assumptions, risks/gotchas, and a maintenance checklist.
- Flagged `p%` as sensitive scratch material and omitted secret-like values from the README.

Failures and how to do differently:

- `restore-trash.bat` was found to be path-stale relative to the actual packaged snapshot under `restore-single\...`; future edits should verify the actual package path before trusting hardcoded restore scripts.

Reusable knowledge:

- `restore-local` is an operations workspace for Supabase backup/restore, not app source.
- `backup-local.bat` creates timestamped backups under `C:\Users\user\Documents\supabase-backup-restore`.
- `restore-single.bat` is local-only and restores one packaged project from `restore-single\...`.
- `reset & restore-supabase.bat` is the VPS/local sync tool with menu options for full restore, pull one schema, and push one schema.
- A root file named `p%` contains secret-like material and should be treated as sensitive.

References:

- [1] `README.md` added at `C:\Users\user\Documents\restore-local\README.md`
- [2] Packaged snapshot confirmed at `restore-single\trash-20260522-140801\trash-20260522-140801`
- [3] `manifest.json` showed project `Trash`, schema `trash`, project ID `fddcc8d4-2f70-4cdc-b5a4-b2fee7b9d8f6`

## Task 2: Harden local/VPS restore behavior and remove accidental blocking pauses

Outcome: partial

Preference signals:

- The user repeatedly asked whether `restore-single.bat` was the same as `reset & restore-supabase.bat`, then clarified they did not want merge behavior and wanted the scripts kept separate -> future answers should preserve the distinction between local packaged restore and VPS sync.
- The user asked for option 3 to “only restore 1 schema from local into vps… will not touch a single content in vps what project unrelated” -> the default should be import-only unless the user explicitly asks for replacement.
- After hitting a hard stop, the user asked why it “stop half way” -> when a parent batch script calls a child backup script, check for `pause`/interactive prompts immediately.

Key steps:

- Option 3 in `reset & restore-supabase.bat` was iterated from a replace-capable version to an import-only version that aborts if the target schema already exists on VPS.
- A `NO_PAUSE=1` gate was added to `backup-local.bat` so it still pauses when run standalone, but skips the pause when called from `reset & restore-supabase.bat` option 3.
- `reset & restore-supabase.bat` now sets `NO_PAUSE=1` before calling `backup-local.bat` and clears it afterward.
- The user later explicitly asked to revert option 3 to “original state” / “import from local to vps” only; the script was changed back so existing same-name VPS schemas cause a hard abort, with no replace flow.

Failures and how to do differently:

- The initial “half way” stop was not a VPS error; it was the child `backup-local.bat` hitting a `pause`. Future debugging of nested batch flows should inspect child-script terminal prompts first.
- The replace-mode experiments were not aligned with the user’s safety preference. When a user says not to alter unrelated VPS content, default to strict import-only or explicit abort, not a replace path.

Reusable knowledge:

- `backup-local.bat` ends with a `pause`; if called from another batch file, it blocks the parent unless an opt-out variable is introduced.
- In the final saved version, option 3 of `reset & restore-supabase.bat` is import-only: if the schema already exists on VPS, it aborts instead of replacing.
- The script validates extracted schema SQL before upload by checking that the SQL blocks belong only to the selected schema.

References:

- [1] `backup-local.bat` modified to skip `pause` when `NO_PAUSE=1`
- [2] `reset & restore-supabase.bat` modified to set/clear `NO_PAUSE` around `call "%~dp0backup-local.bat"`
- [3] Final option 3 behavior: aborts if schema exists on VPS; message states `SAFE MODE aborted: import-only mode never replaces existing VPS schemas.`

## Task 3: Investigate and explain schema removal on VPS / UI errors

Outcome: partial

Preference signals:

- The user repeatedly asked for the safest way to remove only one schema and not touch other projects -> future guidance should prioritize SQL Editor / explicit SQL over broad UI operations.
- The user asked about a dashboard alert (“Failed to generate title: API error happened while trying to communicate with the server.”) -> future debugging should separate UI-layer failures from actual SQL execution results.

Key steps:

- Identified that a Supabase Studio/UI alert about failing to generate a title is not the same as a database delete failure.
- Advised using SQL Editor for schema cleanup and explained that `DROP SCHEMA ... CASCADE` removes tables inside the target schema but should only be used after checking dependencies.
- Helped the user inspect the two similarly named schemas `angelInterior` and `angelinterior`, compare table lists, and reason about deleting only one of them.
- The user’s checks showed both schemas had the same 9 table names and no matching `public.project` row or storage bucket for the provided project ID, suggesting a schema-only cleanup rather than a broader project teardown.

Failures and how to do differently:

- The initial project-linked delete script did not fit the VPS state because the VPS had duplicate casing (`angelInterior` and `angelinterior`) and no matching project row for the provided ID. Future deletion scripts should confirm exact casing and live row presence before including `public.*`, `auth.*`, or `storage.*` deletes.
- A query used `schema_name` against `information_schema.tables` and failed; the correct column is `table_schema`. Future schema inspection should use the proper information_schema columns.

Reusable knowledge:

- A `Failed to generate title` popup in Supabase Studio is likely a UI/network/session issue, not proof that SQL failed.
- If both schemas exist with the same table set, compare row counts before deleting either one.
- When deleting a schema in Supabase/Postgres, quoted identifiers are case-sensitive: `"angelInterior"` and `"angelinterior"` are different schemas.

References:

- [1] Dependency checks returned only `pg_toast` objects, which are internal PostgreSQL storage objects, not another business schema.
- [2] Table list for both schemas showed identical tables: `attachments`, `blog_posts`, `contact_submissions`, `material_categories`, `material_resources`, `permissions`, `sketchup_categories`, `sketchup_resources`, `users`.
- [3] `information_schema.tables` query error: `column "schema_name" does not exist`; fix is to use `table_schema`.
- [4] `Failed to generate title: API error happened while trying to communicate with the server.` was treated as a dashboard/UI error, not a SQL execution result.
