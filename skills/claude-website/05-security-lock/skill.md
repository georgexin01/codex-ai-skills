---
name: website-05-security-lock
description: "Step 05 — Row-Level Security: anon SELECT with isDelete filter, anon_insert_access for contact forms (lead capture), casing-sync COALESCE for JWT project_id. Rule #1 locked at the database layer."
triggers: ["security lock", "rls policies", "anon insert access", "anon select", "row level security", "casing sync", "coalesce project id"]
phase: 1-foundation
requires: [website-04-schema-building]
unlocks: [website-06-seeding, website-07-rest-client]
output_format: sql
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 05 — Security Lock (RLS policies)

## 🎯 When to Use
Immediately after Step 04 (tables exist). Before seeding (Step 06) — otherwise seeds hit a locked-down table or, worse, seed into an unprotected one.

## ⚠️ Dependencies
- **04-schema-building** — tables + `isDelete` + `user_id` / `agent_profile_id` FKs in place.

## 📋 Procedure

1. **Enable RLS on every business table** — Code Vault §1.
2. **Add anon SELECT policy** for public-readable tables (`agent_profiles`, `agent_reviews`) — Code Vault §2. Always filter `isDelete = false`.
3. **Add anon_insert_access policy** for lead-capture tables (`agent_leads`) — Code Vault §3. Anon can INSERT but cannot SELECT (no data leaks).
4. **Block anon writes on everything else** — omitting INSERT/UPDATE/DELETE policies is the correct lock. RLS is default-deny.
5. **For multi-tenant tables**, filter by `project_id` via the Casing Sync COALESCE — Code Vault §4.
6. **Verify** with the smoke tests in §Verify.

## 📦 Code Vault

### §1. Enable RLS (one-shot for every table)
```sql
ALTER TABLE "quizLaa"."agent_profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "quizLaa"."agent_reviews"  ENABLE ROW LEVEL SECURITY;
ALTER TABLE "quizLaa"."agent_leads"    ENABLE ROW LEVEL SECURITY;
```

### §2. Anon SELECT with soft-delete filter
```sql
-- agent_profiles — public listing + detail
CREATE POLICY "anon_select_active"
  ON "quizLaa"."agent_profiles"
  FOR SELECT
  TO anon
  USING ("isDelete" = false);

-- agent_reviews — embeds into agent_profiles via PostgREST
CREATE POLICY "anon_select_active"
  ON "quizLaa"."agent_reviews"
  FOR SELECT
  TO anon
  USING ("isDelete" = false);
```

### §3. Anon INSERT (lead capture — write-only for anon)
```sql
-- agent_leads — anon CAN submit contact form, CANNOT read submissions.
CREATE POLICY "anon_insert_access"
  ON "quizLaa"."agent_leads"
  FOR INSERT
  TO anon
  WITH CHECK (
    "isDelete" = false
    AND "agent_profile_id" IS NOT NULL
    AND length(coalesce("name", '')) > 0
  );

-- NOTE: no anon SELECT policy on agent_leads — anon cannot read other users' leads.
-- When the Sovereign client INSERTs here, it MUST use Prefer: return=minimal
-- (see SupabaseClient in Step 07) because return=representation triggers a
-- SELECT that RLS blocks.
```

### §4. Casing-sync for project-scoped tables (if multi-project)
```sql
-- Some tables live in quizLaa but must filter by the JWT's project_id.
-- The JWT claim can arrive as either `project_id` (snake) or `projectId` (camel)
-- depending on which app issued the token. COALESCE both, always.

CREATE POLICY "authenticated_select_own_project"
  ON "quizLaa"."some_table"
  FOR SELECT
  TO authenticated
  USING (
    "isDelete" = false
    AND "project_id" = COALESCE(
      auth.jwt() ->> 'project_id',
      auth.jwt() ->> 'projectId'
    )::uuid
  );
```

### §5. Service-role bypass (reference — do NOT use from the website layer)
```sql
-- Service-role bypasses RLS entirely. This is a DB-level behavior, not a policy.
-- It exists so admin-panel RPCs can do elevated operations.
-- The website PHP layer uses ANON only — never service-role in this stack.
```

### §6. Confirmatory policy audit (run after every RLS change)
```sql
SELECT
  schemaname,
  tablename,
  policyname,
  cmd,
  roles,
  qual AS using_clause,
  with_check
FROM pg_policies
WHERE schemaname = 'quizLaa'
ORDER BY tablename, policyname;
```

## 🛡️ Guardrails

- **Enabling RLS without a policy = lockout** — every `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` must be paired with at least one policy (SELECT for public tables, INSERT for lead capture). Otherwise anon gets zero rows AND the admin panel gets zero rows (unless service-role).
- **`isDelete = false` on every policy** — without it, soft-deleted rows leak to the public. Non-negotiable.
- **Anon INSERT MUST use `WITH CHECK`** — not `USING`. `USING` applies to rows already in the table (SELECT/UPDATE/DELETE visibility); `WITH CHECK` applies to the new row being written. Anon INSERT policies without `WITH CHECK` are effectively no-ops.
- **No anon SELECT on lead tables** — `agent_leads` is write-only for anon. Reads happen via admin panel (authenticated) only. This prevents competitor scraping + PII leak.
- **`return=minimal` for anon INSERT** — the Sovereign PHP client must send `Prefer: return=minimal` when POSTing to tables without anon SELECT. `return=representation` triggers a RETURNING clause that RLS blocks → INSERT succeeds but the response is empty, confusing the caller.
- **Casing-sync COALESCE (Principle 1)** — `COALESCE(auth.jwt()->>'project_id', auth.jwt()->>'projectId')` in EVERY multi-tenant policy. Different apps mint JWTs with different casing; both must work.
- **Role targeting** — `TO anon` for public-facing, `TO authenticated` for logged-in. Never `TO PUBLIC` (PUBLIC includes both anon AND superuser — surprising privilege).
- **One policy per (role, command) pair** — `anon SELECT`, `anon INSERT`, `authenticated SELECT`, `authenticated UPDATE` are separate policies. Don't try to encode all in one.
- **Admin panel access is via authenticated role** (with `user_role: 'admin'` JWT claim), not service-role. Policies for admin CRUD are written `TO authenticated USING (auth.jwt() ->> 'user_role' = 'admin')`.
- **Test from anon curl BEFORE going live** — the smoke tests in §Verify are not optional.

## ✅ Verify

```bash
ANON="$VITE_SUPABASE_ANON_KEY"                  # from api/core/.env
URL="$VITE_SUPABASE_URL"                         # e.g. http://localhost:54321

# 1. Anon SELECT on agent_profiles — expect rows
curl -s "$URL/rest/v1/agent_profiles?select=id,title&limit=3" \
  -H "apikey: $ANON" -H "Accept-Profile: quizLaa" | jq
# Expected: [ {id, title}, ... ]

# 2. Anon SELECT on agent_leads — expect empty (RLS blocks)
curl -s "$URL/rest/v1/agent_leads?select=*" \
  -H "apikey: $ANON" -H "Accept-Profile: quizLaa" | jq
# Expected: []

# 3. Anon INSERT into agent_leads — expect 201 Created
curl -s -X POST "$URL/rest/v1/agent_leads" \
  -H "apikey: $ANON" -H "Content-Profile: quizLaa" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '{"agent_profile_id":"<real-uuid>","name":"Test","email":"t@x.com"}'
# Expected: HTTP 201, empty body

# 4. Anon INSERT into agent_profiles — expect 401/403 (no policy)
curl -s -X POST "$URL/rest/v1/agent_profiles" \
  -H "apikey: $ANON" -H "Content-Profile: quizLaa" \
  -H "Content-Type: application/json" \
  -d '{"title":"Hack attempt"}'
# Expected: HTTP 401/403 + error body

# 5. Policy audit — list all policies in quizLaa
psql "$DATABASE_URL" -c "
  SELECT tablename, policyname, cmd, roles
  FROM pg_policies WHERE schemaname = 'quizLaa' ORDER BY tablename;
"
```

## ♻️ Rollback
```sql
-- Drop policies
DROP POLICY IF EXISTS "anon_select_active"  ON "quizLaa"."agent_profiles";
DROP POLICY IF EXISTS "anon_select_active"  ON "quizLaa"."agent_reviews";
DROP POLICY IF EXISTS "anon_insert_access"  ON "quizLaa"."agent_leads";

-- Disable RLS (only if you really want the table wide-open — usually a mistake)
ALTER TABLE "quizLaa"."agent_profiles" DISABLE ROW LEVEL SECURITY;
-- ... etc
```

## → Next Step
**[06-seeding](../06-seeding/skill.md)** — seed generator + psql bulk inject + FK integrity check.
