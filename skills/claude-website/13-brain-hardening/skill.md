---
name: website-13-brain-hardening
description: "Step 13 — harden architectural learnings into .codex/memories/3_domains/claude/LAA_PROJECT_SNAPSHOT.md. Final step: makes the build resumable by future AI sessions without reading the code."
triggers: ["brain hardening", "project snapshot", "memory harden", "save architecture", "laa snapshot", "update snapshot"]
phase: 3-orchestration
requires: [website-12-ui-refactor]
unlocks: []
output_format: markdown
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 13 — Brain Hardening

## 🎯 When to Use
Last step. The site is running end-to-end (Steps 01–12 all pass their Verify blocks). Capture what got built into a living snapshot so the next session can resume without re-reading every file.

## ⚠️ Dependencies
- **12-ui-refactor** — templates render; the "definition of done" is met.

## 📋 Procedure

1. **Open** `C:/Users/User/.codex/knowledge/3_domains/claude/LAA_PROJECT_SNAPSHOT.md`. This file already exists; don't recreate it.
2. **Update the sections** that changed during the build (Code Vault §1 checklist).
3. **Move entries** from "Known Bugs" to "Resolved" with a dated line.
4. **Add any new decisions** that aren't derivable from code (compliance driver, deadline, deferred scope).
5. **Save a project-scope memory** — Code Vault §2 — if a shift in architecture, convention, or constraint happened that wasn't already memorized.
6. **Append changelog** — one bullet per deploy in the "Changelog" section (append-only; never rewrite history).
7. **Update the seed count table** in the snapshot if the seed set grew/shrunk.

## 📦 Code Vault

### §1. Sections to audit + update
```
3_domains/claude/LAA_PROJECT_SNAPSHOT.md
├── Project Layout              → still accurate? add new top-level folders
├── MASTER RULES applied        → add new FK relationships to quizLaa
├── Supabase Schema (quizLaa)   → add new tables + casing notes
├── 3 Apps — Connection Matrix  → update URLs if staging/prod shifted
├── Critical Architecture       → move stale items to changelog, add new
├── URL Patterns                → keep UUID-only rule pinned
├── Known Bugs                  → resolve + date; don't delete (kept for history)
├── Seed Data                   → match reality — run the count queries
├── Login Credentials           → rotate if prod, keep if dev seed
├── Migrations Total Count      → bump on each new migration
└── When to update this snapshot → append to the guidance list if new triggers emerged
```

### §2. Project memory template — save if an architectural shift happened
```markdown
---
name: <Short Label>
description: "<one-line description used by future AI to decide relevance>"
type: project
---
**Rule/Fact:** <what changed>

**Why:** <motivation — constraint, deadline, legal, performance>

**How to apply:** <when future sessions should use this fact>
```

Write to `C:\Users\user\.claude\projects\c--Users-user-Desktop-admin-panel-quizLaa\memory\<filename>.md` and add a pointer line to `MEMORY.md`.

### §3. Changelog entry format
```markdown
## Changelog

- **2026-04-20** — website-LAA-agent: migrated to Sovereign V2 (13-step pyramid). UUID-only routing enforced. `agent_profiles.user_id` FK moved into `quizLaa` schema. ErrorHandler global catch active. Deployed to staging.
- **2026-04-17** — [prior entries preserved, do not rewrite]
```

### §4. Resolved bug entry format (moved out of "Known Bugs")
```markdown
## Resolved

- **2026-04-20** — `website/review.php:15` used `$_GET['agent_id']` which router set to `uuid/review`. Fixed by splitting on `/` and using `$parts[0]`. (MED severity, closed)
```

### §5. Verification queries to run before committing the snapshot
```bash
# 1. Live seed counts (for the Seed Data section)
psql "$DATABASE_URL" -At -c "
  SELECT 'agent_profiles: ' || count(*) FROM \"quizLaa\".\"agent_profiles\" WHERE \"isDelete\" = false
  UNION ALL
  SELECT 'agent_reviews: '  || count(*) FROM \"quizLaa\".\"agent_reviews\"  WHERE \"isDelete\" = false
  UNION ALL
  SELECT 'agent_leads: '    || count(*) FROM \"quizLaa\".\"agent_leads\"    WHERE \"isDelete\" = false;
"

# 2. Migrations count
ls apps/web-antd/src/sql/migrations/*.sql | wc -l

# 3. Policy count
psql "$DATABASE_URL" -At -c "SELECT count(*) FROM pg_policies WHERE schemaname = 'quizLaa';"

# 4. URL pattern smoke (confirms UUID-only rule still holds)
curl -s -o /dev/null -w '%{http_code}' "https://<staging-url>/agents/not-a-uuid"
# Expected: 404
```

## 🛡️ Guardrails

- **Don't rewrite the snapshot — edit in place** — git history already preserves prior states. Inline edits keep the file reviewable without diff archaeology.
- **Never delete a "Known Bugs" entry** — resolving one means *moving* it to "Resolved" with a date. The record of past issues is itself load-bearing institutional memory.
- **Dates are absolute** — "Thursday" means nothing in 3 months. Always write `2026-04-20`.
- **Don't memorize code patterns** — if it's in the code, it's discoverable by reading the code. Memorize DECISIONS and CONSTRAINTS (compliance, stakeholder asks, performance budgets, deadlines).
- **Don't memorize file paths** — they move. Memorize architectural roles (e.g., "PHP anon-write tables use return=minimal", not "agent_leads is at api/v1/leads.php").
- **Seed counts must be live** — stale counts are worse than no counts. Always run the query.
- **Login credentials are dev-only** — when staging moves to prod, REMOVE the credentials table from the snapshot. Replace with a pointer to the secret manager.
- **Project memory is for cross-session continuity** — if a memory wouldn't be useful next month, it doesn't belong. One-shot task state goes in plan/tasks, not memory.
- **Rule #1 stays pinned** — the schema isolation rule is Always Applicable. Snapshot reconfirms it for every new table added.

## ✅ Verify

```bash
# 1. Snapshot file readable + has updated date
head -20 C:/Users/User/.codex/knowledge/3_domains/claude/LAA_PROJECT_SNAPSHOT.md

# 2. Run the verification queries in Code Vault §5; compare output with what
#    you wrote in the snapshot. Diffs are a bug.

# 3. Smoke-test future-session recall — ask the next AI session:
#    "What does the quizLaa schema contain?"
#    It should load the snapshot via the INDEX.md → claude domain route
#    and get the right answer WITHOUT reading the code.
```

## ♻️ Rollback
```bash
# Revert the snapshot to the previous commit — architectural snapshots are safe to rollback.
# git log -1 --format='%H' -- <path>
# git restore --source=<prev-hash> <path>
```

## → Finish
Skill protocol complete. Site should now:
- Serve HTML templates via `index.php` + `router.php` with UUID-only resolution.
- Serve JSON via `api/v1/*.php` adapters with uniform error envelope.
- Honor RLS at the DB layer (anon SELECT with soft-delete, anon INSERT for leads).
- Log every request + exception to `api/logs/api.log`.
- Deploy to Apache/nginx/cli-server with the rewrite rules from Step 11.

Ping back to [`claude-website/SKILL.md`](../SKILL.md) — the protocol pyramid is now self-sufficient. `website-BE/` can be deleted.

