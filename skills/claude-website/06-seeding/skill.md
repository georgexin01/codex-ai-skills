---
name: website-06-seeding
description: "Step 06 — seed data generation + bulk injection + FK integrity. Merges the old seed-generator + data-injection steps into a single lifecycle (generate → dry-run → inject → verify)."
triggers: ["seeding", "seed sql", "db_seed.php", "bulk insert", "psql inject", "fk integrity", "seed generator", "data injection"]
phase: 1-foundation
requires: [website-05-security-lock]
unlocks: [website-07-rest-client, website-11-router-v1-endpoints]
output_format: mixed
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 06 — Seeding (generator → inject → verify)

## 🎯 When to Use
After RLS is locked (Step 05). Before the website goes live — agents need sample testimonials, profiles need at least one entry to test the router.

This step merges the old 05-seed-generator + 06-data-injection into one lifecycle. Two phases: **A** (generate SQL from a source) and **B** (inject + verify).

## ⚠️ Dependencies
- **05-security-lock** — RLS in place so seed INSERTs use the correct role (`service_role` for admin-seeding, `anon` for testing INSERT policies).

## 📋 Procedure

### Phase A — Generate

1. **Decide a source**: CSV, existing MySQL dump, PHP array literal, hand-authored.
2. **Author `db_seed.php`** — Code Vault §1. Uses `Sovereign\supabaseClient()` with service-role (or direct psql insert) to write seeds. Lives at project root, NOT inside `api/`.
3. **Or author SQL directly** — Code Vault §2 format. For static dev seeds, hand-authored is often fastest.
4. **Validate SQL syntax** — `psql --dry-run -f seed.sql` (or run in a transaction that's rolled back).

### Phase B — Inject

1. **Bulk inject via psql** — Code Vault §3.
2. **FK integrity check** — Code Vault §4. Every `agent_reviews.agent_profile_id` must resolve to an existing `agent_profiles.id`.
3. **Spot-check 3 rows** — compare against the source to catch mapping bugs.
4. **Run the website** — `php -S localhost:8080` → visit `/agents/<seeded-uuid>` → page renders with seeded content.

## 📦 Code Vault

### §1. `db_seed.php` (root-level seeder — run from CLI)
```php
<?php
/**
 * db_seed.php — populate dev data for the Sovereign website.
 *
 * Usage:  php db_seed.php
 * Idempotent: safe to re-run; each run upserts by slug.
 */

require __DIR__ . '/vendor/autoload.php';

$api = \Sovereign\supabaseClient();

// ─── Sample data ─────────────────────────────────────────

$agents = [
    [
        'slug'        => 'john-agent',
        'title'       => 'John Tan',
        'tagline'     => 'Senior Agent, LAA',
        'description' => 'Specializing in life + medical protection since 2015.',
        'company'     => 'LAA',
        'phone'       => '60123456789',
        'email'       => 'john@laa.com.my',
        'skills'      => ['Life Insurance', 'Medical', 'Retirement Planning'],
        'isDelete'    => false,
    ],
    // ... more agents
];

$reviews = [
    [
        'agent_slug'      => 'john-agent',                // look up at insert time
        'reviewer_name'   => 'Sarah Lim',
        'review_text'     => 'John made the onboarding process seamless.',
        'rating'          => 5,
        'review_date'     => '2026-03-15',
    ],
    // ... more reviews
];

// ─── Insert agents ───────────────────────────────────────

foreach ($agents as $a) {
    // Upsert by slug — delete existing then insert
    $existing = $api->from('agent_profiles')
        ->select('id')
        ->eq('slug', $a['slug'])
        ->limit(1)
        ->get();

    if (!empty($existing['data'])) {
        $api->from('agent_profiles')
            ->eq('slug', $a['slug'])
            ->delete();
    }

    $inserted = $api->from('agent_profiles')->insert($a);
    $id = $inserted['data'][0]['id'] ?? null;
    echo "agent: {$a['slug']} → id={$id}\n";
}

// ─── Insert reviews (resolve slug → id) ──────────────────

foreach ($reviews as $r) {
    $agent = $api->from('agent_profiles')
        ->select('id')
        ->eq('slug', $r['agent_slug'])
        ->single()
        ->get();

    if (!$agent) {
        echo "SKIP review (no agent {$r['agent_slug']})\n";
        continue;
    }

    unset($r['agent_slug']);
    $r['agent_profile_id'] = $agent['id'];
    $r['isDelete'] = false;

    $api->from('agent_reviews')->insert($r);
    echo "review for {$agent['id']}: {$r['reviewer_name']}\n";
}

echo "\nDone.\n";
```

### §2. Hand-authored SQL seed (`seed.sql`)
```sql
-- Disable RLS temporarily for bulk seeding via psql (bypass needed).
-- If running via the admin panel's migration system, this is automatic.

INSERT INTO "quizLaa"."agent_profiles" (id, slug, title, tagline, description, phone, email, skills)
VALUES
  (gen_random_uuid(), 'john-agent', 'John Tan',   'Senior Agent, LAA',  'Specializing since 2015.', '60123456789', 'john@laa.com.my',  '["Life","Medical"]'::jsonb),
  (gen_random_uuid(), 'jane-agent', 'Jane Wong',  'Principal Advisor',  'Retirement expert.',       '60198765432', 'jane@laa.com.my',  '["Retirement","Wealth"]'::jsonb),
  (gen_random_uuid(), 'bob-agent',  'Bob Chan',   'Family Protection',  'Youth + family focus.',    '60111122233', 'bob@laa.com.my',   '["Family","Youth"]'::jsonb);

-- Reviews reference agent_profiles by email (deterministic — slug also works).
INSERT INTO "quizLaa"."agent_reviews" (id, agent_profile_id, reviewer_name, review_text, rating, review_date)
SELECT gen_random_uuid(), p.id, 'Sarah Lim',  'Seamless onboarding.', 5, '2026-03-15'
FROM "quizLaa"."agent_profiles" p WHERE p.slug = 'john-agent';

INSERT INTO "quizLaa"."agent_reviews" (id, agent_profile_id, reviewer_name, review_text, rating, review_date)
SELECT gen_random_uuid(), p.id, 'Daniel Koh', 'Clear advice on coverage.', 5, '2026-02-20'
FROM "quizLaa"."agent_profiles" p WHERE p.slug = 'jane-agent';
```

### §3. Inject via psql (or Supabase Studio SQL editor)
```bash
# Dry-run (syntax check) — begin + rollback
psql "$DATABASE_URL" -c 'BEGIN;' -f seed.sql -c 'ROLLBACK;'

# Real inject
psql "$DATABASE_URL" -f seed.sql

# Via PHP seeder
php db_seed.php
```

### §4. FK integrity + spot-check
```sql
-- 1. Orphan check — reviews pointing at missing agents
SELECT count(*)
FROM "quizLaa"."agent_reviews" r
LEFT JOIN "quizLaa"."agent_profiles" p ON p.id = r.agent_profile_id
WHERE p.id IS NULL;
-- Expected: 0

-- 2. Reviews per agent (sanity)
SELECT p.slug, count(r.id) AS review_count
FROM "quizLaa"."agent_profiles" p
LEFT JOIN "quizLaa"."agent_reviews" r ON r.agent_profile_id = p.id
GROUP BY p.slug
ORDER BY p.slug;

-- 3. Confirm no soft-deleted agents leaked
SELECT count(*) FROM "quizLaa"."agent_profiles" WHERE "isDelete" = true;
```

### §5. Lead capture test (simulates contact form submit — anon INSERT)
```bash
AGENT_ID=$(psql -At "$DATABASE_URL" -c "SELECT id FROM \"quizLaa\".\"agent_profiles\" LIMIT 1;")

curl -s -X POST "$VITE_SUPABASE_URL/rest/v1/agent_leads" \
  -H "apikey: $VITE_SUPABASE_ANON_KEY" \
  -H "Content-Profile: quizLaa" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d "{\"agent_profile_id\":\"$AGENT_ID\",\"name\":\"Smoke Test\",\"email\":\"smoke@test.com\"}" \
  -w '\n[HTTP %{http_code}]\n'
# Expected: [HTTP 201]
```

## 🛡️ Guardrails

- **Never commit seeded PII** — `db_seed.php` is OK to commit (the data is synthetic). Real customer data never enters a seed file.
- **Idempotency is mandatory** — re-running `db_seed.php` must NOT duplicate rows. The upsert-by-slug pattern handles it; DO NOT skip and later wonder why review counts doubled.
- **Seed with admin context or bypass RLS** — anon cannot INSERT into `agent_profiles` (no policy). Use one of: (a) psql direct (bypasses RLS), (b) service-role client (bypasses RLS), (c) admin panel's authenticated mutation RPC. The Sovereign anon client can NOT seed `agent_profiles`.
- **FK integrity via JOIN, not by trust** — always run the orphan check (§4 query 1). A single orphaned review means a seed mapping bug that will surface as a PHP null-deref on the website.
- **FK resolution by slug, not position** — when linking `agent_reviews` to `agent_profiles`, look up the parent by `slug` (or `email`) at insert time. Don't assume `agent_profiles[0].id` — deletion + re-seed changes the UUIDs.
- **`return=minimal` for anon INSERT** — see Step 05. If you get back `[]` after a "successful" INSERT, check the Prefer header.
- **`supabase db reset` re-runs all seeds** — anything in `apps/web-antd/src/sql/migrations/*` + the Supabase seed file executes on reset. Keep seed data deterministic (specific UUIDs or slugs) so tests across resets are stable.
- **UUIDs regenerate on every reset** — don't hardcode them in PHP code. Look them up at runtime via `slug` or `email`.
- **Seed count on snapshot** — when architecture changes, update the Seed Data table in `LAA_PROJECT_SNAPSHOT.md` (Step 13 handles this hygienically).

## ✅ Verify

```bash
# 1. Seeder runs clean
php db_seed.php
# Expected: one "agent: slug → id=uuid" line per record; no "SKIP" lines; no errors.

# 2. Row counts match expectations (adjust numbers to your seed)
psql "$DATABASE_URL" -c 'SELECT count(*) FROM "quizLaa"."agent_profiles";'
# Expected: 4 (for the canonical quizLaa seed set)
psql "$DATABASE_URL" -c 'SELECT count(*) FROM "quizLaa"."agent_reviews";'
# Expected: 9

# 3. FK integrity (see §4)
psql "$DATABASE_URL" -c '
  SELECT count(*) FROM "quizLaa"."agent_reviews" r
  LEFT JOIN "quizLaa"."agent_profiles" p ON p.id = r.agent_profile_id
  WHERE p.id IS NULL;
'
# Expected: 0

# 4. Website renders a seeded agent (after Step 11-12 land)
curl -s "http://localhost:8080/agents/john-agent"
# Expected: HTTP 200 HTML with John Tan's content
```

## ♻️ Rollback
```sql
-- Delete seeded rows (reviews first, then profiles due to FK)
DELETE FROM "quizLaa"."agent_reviews"
WHERE agent_profile_id IN (
  SELECT id FROM "quizLaa"."agent_profiles" WHERE slug LIKE '%-agent'
);
DELETE FROM "quizLaa"."agent_profiles" WHERE slug LIKE '%-agent';

-- Full reset:
-- supabase db reset     # re-runs migrations + seeds
```

## → Next Step
**[07-rest-client](../07-rest-client/skill.md)** — already landed. Skip to [08-models-layer](../08-models-layer/skill.md) if rest-client is done.
