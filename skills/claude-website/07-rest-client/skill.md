---
name: website-07-rest-client
description: "Step 07 — api/core/SupabaseClient.php + SovereignQuery.php: PHP REST wrapper with fluent chain (from → select → eq → single → get), apikey-only auth, envelope guard, custom headers."
triggers: ["rest client", "supabaseclient.php", "sovereign query", "fluent chain", "single envelope", "apikey header", "pgrst", "php supabase wrapper"]
phase: 2-engine
requires: [website-03-composer-autoload, website-05-security-lock]
unlocks: [website-08-models-layer]
output_format: php_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 07 — REST Client (the `api/core/` pillar)

## 🎯 When to Use
After autoload works (Step 03) and RLS is in place (Step 05). This is the Sovereign engine — everything downstream (Models, Controllers, endpoints) stands on it.

## ⚠️ Dependencies
- **03-composer-autoload** — `Sovereign\Core\*` classes load via PSR-4.
- **05-security-lock** — RLS policies exist; anon queries will be filtered by them.

## 📋 Procedure

1. **Create `api/core/SupabaseClient.php`** — Code Vault §1. Low-level cURL engine + entry point for `from()` fluent queries + storage manager.
2. **Create `api/core/SovereignQuery.php`** — Code Vault §2. Fluent chain: select / filter / order / limit / single / get / insert / update / delete.
3. **Create `api/core/SovereignStorage.php`** (stub) — Code Vault §3. Storage manager; implement concrete methods when uploads are needed.
4. **Verify** PSR-4 resolution: `php -r "require 'vendor/autoload.php'; new Sovereign\Core\SupabaseClient();"` → silent success.

## 📦 Code Vault

### §1. `api/core/SupabaseClient.php`
```php
<?php
namespace Sovereign\Core;

/**
 * THE SOVEREIGN FRAMEWORK CLIENT
 *
 * Unified entry point for Fluent Queries (from()) and Storage (storage()).
 * Wraps Supabase REST — apikey-only auth, schema-aware, custom-header ready.
 */

// Core dependencies (SupabaseConfig, SovereignQuery, SovereignStorage) are
// loaded by Composer's PSR-4 autoload via composer.json (Step 03) —
// do NOT `require_once` them here. On Windows it triggers "Cannot declare
// class" double-load errors when path casing differs between composer
// and manual includes.

class SupabaseClient {
    private $url;
    private $anonKey;
    private $schema;
    private $storage;

    public function __construct() {
        $this->url     = rtrim(SupabaseConfig::get('SUPABASE_URL'), '/');
        $this->anonKey = SupabaseConfig::get('SUPABASE_ANON_KEY');
        $this->schema  = SupabaseConfig::get('SUPABASE_SCHEMA');

        $this->storage = new SovereignStorage($this->url);
    }

    /** Start a fluent query: $api->from('table')->select('*')->eq('id', 1)->get(); */
    public function from($table) {
        return new SovereignQuery($this, $table);
    }

    /** Asset / Storage Manager */
    public function storage() {
        return $this->storage;
    }

    /**
     * Low-level cURL Engine.
     *
     * @param string $path            REST path (e.g. 'agent_profiles')
     * @param string $method          HTTP method
     * @param mixed  $data            Body for POST/PATCH
     * @param string $prefer          PostgREST Prefer header (e.g. return=representation)
     * @param array  $customHeaders   Additional HTTP headers to merge
     */
    public function request($path, $method = 'GET', $data = null, $prefer = 'return=representation', $customHeaders = []) {
        $ch = curl_init();

        // APIKEY-ONLY — never add `Authorization: Bearer` with the same anon JWT.
        // PostgREST rejects duplicate JWT with "No suitable key or wrong key type".
        $headers = [
            "apikey: {$this->anonKey}",
            "Content-Type: application/json",
            "Accept-Profile: {$this->schema}",
            "Content-Profile: {$this->schema}",
        ];

        if (!empty($customHeaders)) {
            $headers = array_merge($headers, $customHeaders);
        }

        $fullUrl = "{$this->url}/rest/v1/{$path}";

        // `return=representation` triggers RETURNING — requires SELECT RLS
        // to pass on the inserted row. Pass `return=minimal` when anon-writing
        // to tables where anon has no SELECT policy (e.g. agent_leads).
        if (\in_array($method, ['POST', 'PATCH'], true) && $prefer) {
            $headers[] = "Prefer: {$prefer}";
        }

        curl_setopt($ch, CURLOPT_URL, $fullUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        if ($data) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        }

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error    = curl_error($ch);
        curl_close($ch);

        // Sovereign Diagnostic Log — visible to devs / AI for debugging
        $logHeader = "[Sovereign Debug] " . date('Y-m-d H:i:s');
        $logMsg    = "{$logHeader} | URL: {$fullUrl} | Code: {$httpCode}";

        if ($httpCode >= 400 || $error) {
            $logMsg .= " | Error: {$error} | Response: {$response}";
            error_log($logMsg);
        } else {
            $decoded = json_decode($response, true);
            $count   = is_array($decoded) ? count($decoded) : (isset($decoded['id']) ? 1 : 0);
            $logMsg .= " | Success | Records: {$count}";
            error_log($logMsg);
        }

        return [
            'status' => $httpCode,
            'data'   => json_decode($response, true),
            'error'  => $error,
        ];
    }

    /** Legacy method maintained for backward compatibility. */
    public function get($table, $query = '') {
        return $this->request($table . ($query ? '?' . $query : ''), 'GET');
    }
}
```

### §2. `api/core/SovereignQuery.php`
```php
<?php
namespace Sovereign\Core;

/**
 * Sovereign Query Builder — fluent chainable interface for PostgREST.
 * Mimics supabase-js:
 *   $api->from('agent_profiles')->select('*')->eq('user_id', $uid)->single()->get();
 */

class SovereignQuery {
    private $client;
    private $table;
    private $select  = '*';
    private $filters = [];
    private $orders  = [];
    private $limit   = null;
    private $offset  = null;
    private $single  = false;

    public function __construct($client, $table) {
        $this->client = $client;
        $this->table  = $table;
    }

    public function select($columns = '*')   { $this->select = $columns; return $this; }

    public function eq($column, $value) {
        $this->filters[] = "{$column}=eq." . urlencode($this->formatValue($value));
        return $this;
    }

    public function neq($column, $value) {
        $this->filters[] = "{$column}=neq." . urlencode($this->formatValue($value));
        return $this;
    }

    public function gt($column, $value) {
        $this->filters[] = "{$column}=gt." . urlencode($this->formatValue($value));
        return $this;
    }

    public function ilike($column, $pattern) {
        $this->filters[] = "{$column}=ilike." . urlencode($pattern);
        return $this;
    }

    /** Arbitrary operator: gte, lte, in, is, fts, etc. */
    public function filter($column, $operator, $value) {
        $this->filters[] = "{$column}={$operator}." . urlencode($this->formatValue($value));
        return $this;
    }

    /** OR group: $q->or('id.eq.X,user_id.eq.Y') */
    public function or($filterString) {
        $this->filters[] = "or=({$filterString})";
        return $this;
    }

    public function order($column, $ascending = true) {
        $this->orders[] = "{$column}." . ($ascending ? 'asc' : 'desc');
        return $this;
    }

    public function limit($limit)       { $this->limit = $limit; return $this; }
    public function range($from, $to)   { $this->offset = $from; $this->limit = ($to - $from) + 1; return $this; }

    /** Request a single row — unwraps the array envelope on success. */
    public function single() { $this->single = true; return $this; }

    private function formatValue($value) {
        if ($value === true)  return 'true';
        if ($value === false) return 'false';
        if ($value === null)  return 'null';
        return (string) $value;
    }

    public function get($headers = []) {
        $params = [];
        $params[] = "select=" . urlencode($this->select);
        foreach ($this->filters as $f) $params[] = $f;
        if (!empty($this->orders))     $params[] = "order=" . implode(',', $this->orders);
        if ($this->limit !== null)     $params[] = "limit=" . $this->limit;
        if ($this->offset !== null)    $params[] = "offset=" . $this->offset;

        if ($this->single) {
            // Accept single-object envelope — response.data is the row, not an array
            $headers[] = "Accept: application/vnd.pgrst.object+json";
        }

        $queryString = implode('&', $params);
        $response = $this->client->request(
            $this->table . ($queryString ? '?' . $queryString : ''),
            'GET', null, 'return=representation', $headers,
        );

        // ENVELOPE GUARD: when single() was used, return the record directly on 2xx
        if ($this->single) {
            $status = $response['status'] ?? 500;
            return ($status >= 200 && $status < 300) ? $response['data'] : null;
        }

        return $response;
    }

    /** INSERT — $api->from('t')->insert(['col'=>'v'])->get() (or ->get($customHeaders)) */
    public function insert($values) {
        $response = $this->client->request($this->table, 'POST', $values);
        $status = $response['status'] ?? 500;
        if ($status < 200 || $status >= 300) {
            return ['data' => [], 'error' => $response['data'] ?? null];
        }
        return $response;
    }

    /** UPDATE — $api->from('t')->eq('id', 1)->update(['col'=>'v']) */
    public function update($values) {
        $queryString = implode('&', $this->filters);
        $path = $this->table . ($queryString ? '?' . $queryString : '');
        $response = $this->client->request($path, 'PATCH', $values);
        $status = $response['status'] ?? 500;
        if ($status < 200 || $status >= 300) {
            return ['data' => [], 'error' => $response['data'] ?? null];
        }
        return $response;
    }

    /** DELETE — $api->from('t')->eq('id', 1)->delete() */
    public function delete() {
        $queryString = implode('&', $this->filters);
        $path = $this->table . ($queryString ? '?' . $queryString : '');
        $response = $this->client->request($path, 'DELETE');
        $status = $response['status'] ?? 500;
        if ($status < 200 || $status >= 300) {
            return ['data' => [], 'error' => $response['data'] ?? null];
        }
        return $response;
    }
}
```

### §3. `api/core/SovereignStorage.php` (stub — extend as needed)
```php
<?php
namespace Sovereign\Core;

/**
 * Sovereign Storage — placeholder for bucket operations.
 * Extend when the PHP layer owns uploads (most sites delegate to admin panel
 * or use local /uploads/ via Sovereign\uploadImage() in Helper.php).
 */
class SovereignStorage {
    private $baseUrl;

    public function __construct($baseUrl) {
        $this->baseUrl = $baseUrl;
    }

    /** Build a public URL for a Supabase Storage object. */
    public function publicUrl(string $bucket, string $path): string {
        return "{$this->baseUrl}/storage/v1/object/public/{$bucket}/" . ltrim($path, '/');
    }

    // upload(), remove(), list() — add when needed.
}
```

### §4. Usage examples
```php
use Sovereign\Core\SupabaseClient;

$api = \Sovereign\supabaseClient();   // from Helper.php — memoized singleton

// SELECT many
$response = $api->from('agent_profiles')
    ->select('id, display_name, bio')
    ->eq('isDelete', false)
    ->order('display_name')
    ->limit(20)
    ->get();
$rows = $response['data'];

// SELECT one (envelope-guarded — returns the row object directly)
$agent = $api->from('agent_profiles')
    ->select('*')
    ->or("id.eq.{$id},user_id.eq.{$id}")      // slug OR uuid
    ->eq('isDelete', false)
    ->single()
    ->get();
if (!$agent) {
    \Sovereign\respondError(404, 'Agent not found');
}

// INSERT with return=minimal (anon write to a table without anon SELECT)
$res = $api->from('agent_leads')
    ->insert(['agent_profile_id' => $agentId, 'name' => $name, 'email' => $email]);
// agent_leads RLS allows anon INSERT but not anon SELECT — use prefer=return=minimal
// by passing a custom header or checking status directly.
```

## 🛡️ Guardrails

- **APIKEY-ONLY auth** — the `apikey` header alone is authoritative for anon access. Never add `Authorization: Bearer` with the same anon JWT; PostgREST rejects duplicate JWT with "No suitable key or wrong key type". If you need elevated privileges, use a different client with service-role (server-side only, not in this anon-facing layer).
- **Schema binding via Accept-Profile / Content-Profile** — `Accept-Profile: quizLaa` tells PostgREST which schema to target. Missing this header = fall back to `public` schema = Rule #1 violation.
- **`return=representation` needs SELECT RLS** — when inserting to a table where anon has INSERT but NOT SELECT (e.g., `agent_leads`), use `Prefer: return=minimal` instead. Otherwise the INSERT succeeds but the RETURNING fails, and the caller gets an empty envelope.
- **Envelope guard** — `single()` unwraps the PGRST object envelope so callers get the record directly, not `['data' => ['data' => row]]`. Do not revert this — Models rely on it.
- **`urlencode` every filter value** — SovereignQuery does this for `eq/neq/gt/ilike/filter`. Do NOT add new filter methods that skip encoding; a value with `&` or `=` will corrupt the query string.
- **SSL_VERIFYPEER disabled for local dev** — the production Supabase URL has a valid cert; local Docker has self-signed. If you deploy to a host with strict egress, set `CURLOPT_SSL_VERIFYPEER = true` conditional on `APP_ENV === 'production'`.
- **Diagnostic logging via `error_log()`** — every request logs the URL + status + record count. Errors include the full response body. This is invaluable for debugging PostgREST filter mistakes; don't strip it.
- **No manual `require_once` on core files** — let Composer handle it. The comment in `SupabaseClient.php` warns about Windows double-load fatal.
- **`SupabaseClient` is stateless** — keep it that way. A new instance can be created per request, or memoized via `Sovereign\supabaseClient()` from Helper.php.

## ✅ Verify

```bash
# 1. PHP parse
php -l api/core/SupabaseClient.php
php -l api/core/SovereignQuery.php
php -l api/core/SovereignStorage.php

# 2. End-to-end smoke test against local Supabase
php -r "
  require 'vendor/autoload.php';
  \$api = \Sovereign\supabaseClient();
  \$response = \$api->from('agent_profiles')->select('id')->limit(1)->get();
  var_dump(\$response['status'], count(\$response['data'] ?? []));
"
# Expected: int(200) followed by a record count (0 if no seeds yet)

# 3. Envelope guard test — single() should return a row object, not an array
php -r "
  require 'vendor/autoload.php';
  \$api = \Sovereign\supabaseClient();
  \$row = \$api->from('agent_profiles')->select('id')->limit(1)->single()->get();
  var_dump(\$row);    // expect: array (single record) or NULL
"
```

## ♻️ Rollback
```bash
rm -f api/core/SupabaseClient.php api/core/SovereignQuery.php api/core/SovereignStorage.php
# Models/Controllers that referenced SupabaseClient fatal immediately.
```

## → Next Step
**[08-models-layer](../08-models-layer/skill.md)** — `api/Models/` — BaseModel + per-entity Models with `format()` DB→template alias.
