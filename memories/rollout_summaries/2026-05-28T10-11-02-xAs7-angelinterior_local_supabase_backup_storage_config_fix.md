thread_id: 019e6e10-e86a-73a1-9ba8-2119cccef3d7
updated_at: 2026-05-28T10:25:39+00:00
rollout_path: C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T18-11-10-019e6e10-e86a-73a1-9ba8-2119cccef3d7.jsonl
cwd: \\?\C:\Users\user\Documents\supabase-project-backup-restore
git_branch: main

# Local Angel Interior Supabase backup/migration state was audited and fixed before VPS migration

Rollout context: The user was preparing to move the local Supabase project to VPS and wanted the local `angelinterior` project to be complete, including database settings, config, policies, storage, and other missing pieces. The work happened in `C:\Users\user\Documents\supabase-project-backup-restore` and also referenced the shared local Supabase repo at `C:\Users\user\Documents\local-supabase`.

## Task 1: Diagnose and repair the local Angel project backup/migration setup

Outcome: success

Preference signals:
- The user said they were “moving from local to vps soon” and wanted the local database/config/policies “complete” before migration -> future agents should treat this as a migration-readiness request, not just a narrow backup check.
- The user explicitly asked to “help me update supabase local docker of mine angelinterior project to complete those missing policies and others setting” -> future agents should proactively audit local Supabase completeness (DB, storage, config, policies), not only answer whether a single backup succeeded.

Key steps:
- Verified that the local DB container and storage container names were correct and running: `supabase_db_local-supabase` and `supabase_storage_local-supabase`.
- Discovered the first mismatch was `public.project.schema_name = angel` while the actual Postgres schema was `angelinterior`; updated the `public.project` row so the backup tool and schema list matched the real DB schema.
- Verified that the local `angelinterior` schema existed, had RLS enabled on all app tables, had 43 policies in the schema, and the auth hook `public.custom_access_token_hook` existed.
- Found a second naming mismatch: the storage bucket was `angel-interior`, not `angelinterior`, and the storage policies were prefixed `angel_interior_*`.
- Patched the backup scripts to resolve storage bucket id and policy prefix separately from the schema name, instead of assuming they were identical.
- Patched the backup flow to copy the shared `C:/Users/user/Documents/local-supabase/supabase/config.toml` into the backup when it contained `angelinterior`, so the backup would include local config too.
- Re-ran backups to confirm the corrected flow captured:
  - storage bucket `angel-interior`
  - physical files from `/mnt/stub/stub/angel-interior`
  - 4 storage policies matching `angel_interior_*`
  - `config.toml`
  - verification passed.

Failures and how to do differently:
- The first backup attempt failed because the script used `angel` from `public.project` even though the real schema was `angelinterior`; future checks should compare `public.project.schema_name` with `information_schema.schemata` before backing up.
- The first storage warnings were false negatives caused by assuming bucket name and policy prefix matched the schema; future similar tooling should resolve schema, bucket id, and policy prefix independently.
- A first attempt to use a too-clever `psql`-based resolver was unreliable in this Windows/Git Bash environment; a simpler resolver based on direct container queries and shell string handling worked better.
- The backup tool’s config lookup originally missed the shared local Supabase config; future runs should check the shared `local-supabase/supabase/config.toml` path when per-project config isn’t found.

Reusable knowledge:
- For this project, the three identities are distinct:
  - business schema: `angelinterior`
  - storage bucket: `angel-interior`
  - storage policy prefix: `angel_interior_*`
  Future backup/restore logic should not assume these names are the same.
- The local Supabase config at `C:\Users\user\Documents\local-supabase\supabase\config.toml` already exposes `angelinterior` in `api.schemas`.
- The Angel schema state is otherwise healthy locally: RLS was enabled on all Angel tables, and the DB had the expected app policies and auth hook.
- The useful backup to use for VPS migration was the final one created after the fix: `local-backups/angelinterior-20260528-182503`.

References:
- [1] `public.project` row initially showed `Angel Interior | schema_name = angel`; later updated to `angelinterior`.
- [2] Actual schema check showed `information_schema.schemata` contained `angelinterior`.
- [3] Storage bucket/policy discovery: `storage.buckets.id = angel-interior`, policies `angel_interior_auth_delete`, `angel_interior_auth_insert`, `angel_interior_auth_update`, `angel_interior_public_read`.
- [4] `local-supabase/supabase/config.toml` already included `angelinterior` in `api.schemas`.
- [5] Final successful backup run output included: `Found storage in 'supabase_storage_local-supabase:/mnt/stub/stub/angel-interior'`, `Captured 4 storage policy/policies`, `Copied shared config.toml from: C:/Users/user/Documents/local-supabase/supabase/config.toml`, and `Verification PASSED`.
- [6] Files changed: `scripts/lib/resolve-storage-context.sh`, `scripts/lib/dump-storage.sh`, `scripts/lib/dump-storage-policies.sh`, `scripts/lib/sql/extract-storage-meta.sql`, `scripts/lib/sql/extract-storage-policies.sql`, `scripts/lib/write-manifest.sh`, `scripts/lib/verify-backup.sh`, `scripts/04-restore-local.sh`, and `scripts/01-backup-local.sh`.

## Task 2: Confirm local completeness for migration readiness

Outcome: success

Preference signals:
- The user asked for the local setup to be “complete” before moving to VPS -> future agents should audit the local project end-to-end rather than only answering a narrow symptom.

Key steps:
- Checked the shared local Supabase config, DB schema exposure, storage bucket, storage object count, RLS status, storage policies, and auth hook.
- Confirmed the final local state was migration-ready enough for the backup tool to capture full project context.

Reusable knowledge:
- The local Angel setup currently has:
  - `public.project.schema_name = angelinterior`
  - DB schema `angelinterior`
  - storage bucket `angel-interior`
  - 449 storage objects
  - 4 storage policies with prefix `angel_interior_`
  - `public.custom_access_token_hook`
  - schema exposed in local Supabase config
- The final backup that should be used for VPS migration is `local-backups/angelinterior-20260528-182503`.
