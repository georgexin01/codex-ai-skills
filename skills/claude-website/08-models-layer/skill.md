---
name: website-08-models-layer
description: "Step 08 — api/Models/: abstract BaseModel (find/all/paginate/create/update/softDelete) + entity Models with format() override for DB→template alias + JSONB decode + nested review hydration."
triggers: ["models layer", "basemodel", "agent model", "format method", "jsonb decode", "model crud", "embed default", "resolve entity"]
phase: 2-engine
requires: [website-07-rest-client]
unlocks: [website-09-controllers-layer]
output_format: php_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 08 — Models Layer (the `api/Models/` pillar)

## 🎯 When to Use
After the REST engine (Step 07) works. Models are where DB shapes become template-friendly shapes. Every entity gets one.

## ⚠️ Dependencies
- **07-rest-client** — `Sovereign\Core\SupabaseClient` + `SovereignQuery` available.
- **03-composer-autoload** — `Sovereign\Models\` PSR-4 mapped to `api/Models/`.

## 📋 Procedure

1. **Create `api/Models/BaseModel.php`** — Code Vault §1. Abstract class with find/all/paginate/create/update/softDelete + the `format()` hook.
2. **For each entity**, create `api/Models/<Entity>Model.php`:
   - Extend `BaseModel`
   - Set `$embedDefault` (PostgREST embedded-select string for 1:N joins)
   - Override `format()` to alias DB keys, decode JSONB, hydrate related rows, cast booleans
3. **Special resolvers** — entities with non-standard lookup (UUID OR slug, email OR phone) add a `resolve()` method. See AgentModel (Code Vault §2).
4. **Run `composer dump-autoload`** after adding each new Model file.

## 📦 Code Vault

### §1. `api/Models/BaseModel.php` — abstract parent
```php
<?php
/**
 * Sovereign BaseModel — PostgREST-backed data access layer.
 *
 * Children set $table + optionally $embedDefault, then inherit
 * find/all/paginate/create/update/softDelete + the format() hook.
 */

namespace Sovereign\Models;

abstract class BaseModel
{
    protected \Sovereign\Core\SupabaseClient $api;
    protected string $table = '';
    protected string $embedDefault = '*';

    public function __construct(\Sovereign\Core\SupabaseClient $api, string $table)
    {
        $this->api   = $api;
        $this->table = $table;
    }

    /** Fetch one row by UUID primary key. */
    public function find(string $id, ?string $select = null): ?array
    {
        $row = $this->api->from($this->table)
            ->select($select ?? $this->embedDefault)
            ->eq('id', $id)
            ->eq('isDelete', 'false')
            ->single()
            ->get();

        return $row ? $this->format($row) : null;
    }

    /** Fetch rows with simple equality filters. */
    public function all(array $filters = [], ?string $select = null): array
    {
        $query = $this->api->from($this->table)
            ->select($select ?? $this->embedDefault)
            ->eq('isDelete', 'false');

        foreach ($filters as $col => $val) {
            $query->eq($col, $val);
        }

        $resp = $query->get();
        $rows = $resp['data'] ?? [];
        return array_map([$this, 'format'], $rows);
    }

    /** Paginated list. */
    public function paginate(int $page = 1, int $pageSize = 10, array $filters = []): array
    {
        $from = ($page - 1) * $pageSize;
        $to   = $from + $pageSize - 1;

        $query = $this->api->from($this->table)
            ->select($this->embedDefault)
            ->eq('isDelete', 'false')
            ->range($from, $to);

        foreach ($filters as $col => $val) {
            $query->eq($col, $val);
        }

        $resp = $query->get();
        $rows = $resp['data'] ?? [];

        return [
            'items'    => array_map([$this, 'format'], $rows),
            'page'     => $page,
            'pageSize' => $pageSize,
            'total'    => count($rows),    // for true total, run a separate count query
        ];
    }

    /**
     * Insert a single row.
     * $returnRow=true  → Prefer: return=representation (needs SELECT RLS on inserted row)
     * $returnRow=false → Prefer: return=minimal (no SELECT required — use for anon INSERTs)
     */
    public function create(array $data, bool $returnRow = true): ?array
    {
        $prefer = $returnRow ? 'return=representation' : 'return=minimal';
        $resp = $this->api->request($this->table, 'POST', $data, $prefer);
        if (($resp['status'] ?? 500) >= 400) return null;

        if (!$returnRow) return ['created' => true];

        $rows = $resp['data'] ?? [];
        $row  = \is_array($rows) && isset($rows[0]) ? $rows[0] : $rows;
        return $row ? $this->format($row) : null;
    }

    /** Partial update by id. */
    public function update(string $id, array $data): ?array
    {
        $resp = $this->api->request(
            $this->table . '?id=eq.' . urlencode($id),
            'PATCH',
            $data,
        );
        if (($resp['status'] ?? 500) >= 400) return null;

        $rows = $resp['data'] ?? [];
        $row  = is_array($rows) && isset($rows[0]) ? $rows[0] : $rows;
        return $row ? $this->format($row) : null;
    }

    /** Soft-delete by id (sets isDelete=true). */
    public function softDelete(string $id): bool
    {
        $resp = $this->api->request(
            $this->table . '?id=eq.' . urlencode($id),
            'PATCH',
            ['isDelete' => true],
        );
        return ($resp['status'] ?? 500) < 400;
    }

    /**
     * Data-shape hook — child overrides to:
     *   - decode JSONB columns
     *   - prepend storage domain to image paths
     *   - cast booleans from PostgREST string form
     *   - hydrate related records
     */
    protected function format(array $row): array
    {
        return $row;
    }
}
```

### §2. `api/Models/AgentModel.php` — entity example (embed + format + resolve)
```php
<?php
/**
 * AgentModel — resolves agent_profiles + hydrates reviews, social, skills,
 * services, achievements, videos to the exact shape home.php / review.php expect.
 *
 * resolve($id) accepts UUID (profile.id OR user_id). Slug lookups removed
 * per user directive (2026-04-17) — non-UUID always 404s.
 */

namespace Sovereign\Models;

use function Sovereign\isUuid;

class AgentModel extends BaseModel
{
    public function __construct(\Sovereign\Core\SupabaseClient $api)
    {
        parent::__construct($api, 'agent_profiles');
        // Embedded select — pulls agent_reviews with every profile fetch
        $this->embedDefault = '*,agent_reviews(*)';
    }

    /**
     * Universal matcher — UUID only (profile.id OR user_id).
     */
    public function resolve(string $identifier): ?array
    {
        if ($identifier === '' || !isUuid($identifier)) return null;

        $row = $this->api->from($this->table)
            ->select($this->embedDefault)
            ->eq('isDelete', 'false')
            ->or("id.eq.{$identifier},user_id.eq.{$identifier}")
            ->limit(1)
            ->single()
            ->get();

        return $row ? $this->format($row) : null;
    }

    /**
     * Format raw DB row into template-ready shape.
     * Guarantees every key home.php / review.php / initData.php consumes.
     */
    protected function format(array $row): array
    {
        // ─── DB → template key aliases ───────────────────
        $row['url']         = $row['slug']        ?? '';
        $row['name']        = $row['title']       ?? '';
        $row['title']       = $row['tagline']     ?? '';
        $row['company']     = $row['company']     ?? 'LAA';
        $row['tagline']     = $row['tagline']     ?? '';
        $row['description'] = $row['description'] ?? '';
        $row['photo']       = $row['photo']       ?? '';
        $row['video_url']   = $row['video_url']   ?? '';
        $row['phone']       = $row['phone']       ?? '';
        $row['email']       = $row['email']       ?? '';
        $row['address']     = $row['address']     ?? '';

        // ─── JSONB columns ───────────────────────────────
        $row['social']       = $this->decodeJsonb($row['social_links'] ?? null, []);
        $row['skills']       = $this->decodeJsonb($row['skills']       ?? null, []);
        $row['services']     = $this->decodeJsonb($row['services']     ?? null, []);
        $row['achievements'] = $this->decodeJsonb($row['achievements'] ?? null, []);
        $row['videos']       = $this->decodeJsonb($row['videos']       ?? null, []);

        // ─── Nested hydration: reviews ───────────────────
        $reviews = $row['agent_reviews'] ?? [];
        usort($reviews, fn($a, $b) =>
            strtotime($b['review_date'] ?? '0') - strtotime($a['review_date'] ?? '0')
        );
        foreach ($reviews as &$r) {
            $r['name']   = $r['reviewer_name']  ?? 'Anonymous';
            $r['photo']  = $r['reviewer_photo'] ?? '';
            $r['text']   = $r['review_text']    ?? '';
            $r['rating'] = (int)($r['rating']   ?? 5);
            $r['date']   = !empty($r['review_date'])
                ? date('M d, Y', strtotime($r['review_date']))
                : '';
        }
        unset($r);
        $row['reviews'] = $reviews;

        // ─── Boolean cast (PostgREST returns 't'/'f' or true/false inconsistently) ──
        if (isset($row['isDelete'])) {
            $row['isDelete'] = $row['isDelete'] === true
                || $row['isDelete'] === 'true'
                || $row['isDelete'] === 't';
        }

        return $row;
    }

    private function decodeJsonb($val, $default)
    {
        if ($val === null)       return $default;
        if (is_array($val))      return $val;
        if (is_string($val)) {
            $decoded = json_decode($val, true);
            return $decoded === null ? $default : $decoded;
        }
        return $default;
    }
}
```

### §3. Minimal Model template (copy & rename)
```php
<?php
namespace Sovereign\Models;

class <Entity>Model extends BaseModel
{
    public function __construct(\Sovereign\Core\SupabaseClient $api)
    {
        parent::__construct($api, '<table_name>');
        // Only set if you need embedded 1:N reads:
        // $this->embedDefault = '*,<child_table>(*)';
    }

    protected function format(array $row): array
    {
        // Alias DB keys → template keys here.
        // Cast booleans, decode JSONB, prepend storage URLs.
        return $row;
    }
}
```

### §4. Usage (from a Controller or v1 endpoint)
```php
use Sovereign\Models\AgentModel;

$api    = \Sovereign\supabaseClient();
$model  = new AgentModel($api);

$agent  = $model->resolve($_GET['id']);          // UUID only
if (!$agent) {
    \Sovereign\respondError(404, 'Agent not found');
}

$all    = $model->all(['isDelete' => 'false']);  // list
$paged  = $model->paginate(1, 20);               // paginated list
```

## 🛡️ Guardrails

- **`format()` is MANDATORY** even if it's a pass-through — it normalizes booleans from PostgREST's `'t'/'f'/'true'/'false'` inconsistency. Without it, template conditionals like `v-if="user.isDelete"` render on every seed-with-`'f'` row.
- **`embedDefault` is the PostgREST embed string** — `'*,agent_reviews(*)'` fetches the parent + all related reviews in one request. For three-level deep, chain: `'*,agent_reviews(*,reviewer(*))'`. But note: on local Docker Supabase, embeds can fail with PGRST200 (stale FK cache) — if so, fall back to two-query joins in the Controller.
- **`eq('isDelete', 'false')`** — pass the STRING `'false'`, not the boolean `false`. PostgREST URL-encodes the value; the boolean gets stringified to empty. SovereignQuery's `formatValue()` handles the cast, but hand-written `eq` calls should pass string.
- **`$returnRow=false` for anon INSERT** — when the Model creates a row on a table without anon SELECT (e.g., `agent_leads`), pass `create($data, returnRow: false)`. Otherwise PostgREST returns `[]` (RLS blocks the RETURNING) and you think the INSERT failed.
- **JSONB decode defensively** — seed data may be JSON string OR already-parsed array depending on the seeder. `decodeJsonb()` handles both + null.
- **Nested hydration sorts client-side** — PostgREST embeds don't let you order child rows. Do `usort` in `format()`.
- **Model is stateless per request** — instantiate in the Controller, pass the shared `SupabaseClient`. Don't cache Model instances globally.
- **Run `composer dump-autoload`** after creating a new Model. Without it, PSR-4 can't find the class even if the file exists.

## ✅ Verify

```bash
# 1. PHP parse
php -l api/Models/BaseModel.php
php -l api/Models/AgentModel.php

# 2. Autoload + instantiate
composer dump-autoload
php -r "
  require 'vendor/autoload.php';
  \$m = new Sovereign\Models\AgentModel(\Sovereign\supabaseClient());
  var_dump(count(\$m->all()));
"
# Expected: int(<seed count>) (e.g., 4 for the canonical quizLaa seed)

# 3. resolve() happy path
php -r "
  require 'vendor/autoload.php';
  \$m = new Sovereign\Models\AgentModel(\Sovereign\supabaseClient());
  \$uuid = \$m->all()[0]['id'];
  \$row = \$m->resolve(\$uuid);
  var_dump(\$row['name'], count(\$row['reviews']));
"
# Expected: string (agent name) + int (review count)

# 4. resolve() reject non-UUID
php -r "
  require 'vendor/autoload.php';
  \$m = new Sovereign\Models\AgentModel(\Sovereign\supabaseClient());
  var_dump(\$m->resolve('john-agent'));
"
# Expected: NULL (slug rejected per 2026-04-17 directive)
```

## ♻️ Rollback
```bash
rm -f api/Models/<Entity>Model.php
composer dump-autoload
# Any Controller that imported this Model fatals immediately — easier debug than silent failure.
```

## → Next Step
**[09-controllers-layer](../09-controllers-layer/skill.md)** — Controllers orchestrate the Model + ship JSON via `respond()`.
