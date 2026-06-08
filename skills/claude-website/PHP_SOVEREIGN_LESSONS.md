---
name: php-sovereign-lessons
description: "Field-tested gotchas for Sovereign PHP + Supabase REST backend. Harvested from angel-interior + VIPBillion builds. Read before any PHP API work."
triggers: ["php error", "supabase rest", "pgrst", "401", "403", "php api", "sovereign php", "rest endpoint"]
phase: reference
version: 1.0
status: authoritative
last_updated: "2026-06-08"
---

# PHP Sovereign + Supabase REST — Field Lessons

> Append-only. New lessons go at the bottom of the matching section. Never delete.

---

## 1. Auth Headers — The Most Common Failure Point

**Problem:** PostgREST returns `PGRST301` or `42501` (permission denied) on writes.

**Root cause checklist:**
1. Wrong key — website writes need the **service key**, not the publishable/anon key
2. Missing `X-Project-Id` header — required when using the multi-project proxy
3. Schema not in `db_schema` allowlist on the PostgREST config
4. RLS policy blocks the role being used

**Fix pattern:**
```php
// Server-side writes: always use service key
$headers = [
    'apikey: ' . SUPABASE_SERVICE_KEY,
    'Authorization: Bearer ' . SUPABASE_SERVICE_KEY,
    'Content-Type: application/json',
    'X-Project-Id: ' . PROJECT_ID,   // required for multi-project proxy
];
```

---

## 2. Never Use Anon Key for Server-Side Writes

The anon key is for public browser reads only. Any PHP endpoint that writes to Supabase must use the service key. Mixing them causes silent RLS failures where the write appears to succeed (200) but inserts 0 rows.

---

## 3. Schema Prefix on Every Query

PostgREST endpoint must include schema path:
```
https://[host]/rest/v1/[table]   ← WRONG — hits public schema
https://[host]/rest/v1/[schema].[table]  ← not standard PostgREST
```

Correct: set `db_schema` in PostgREST config to include your schema, then call:
```
GET /rest/v1/orders   (with Accept-Profile: vipbillion header)
```

Or use the `Content-Profile` / `Accept-Profile` headers:
```php
$headers[] = 'Accept-Profile: vipbillion';   // for reads
$headers[] = 'Content-Profile: vipbillion';  // for writes
```

---

## 4. PowerShell Curl Hides Real Errors

When testing PHP REST calls from PowerShell, the raw error body gets mangled. Always test with a PHP script that `var_dump`s the full curl response, not via PowerShell `Invoke-WebRequest`.

```php
// Debug helper — add temporarily, remove before commit
$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
var_dump(['code' => $httpCode, 'body' => $response]);
```

---

## 5. Composer PSR-4 Autoload After Adding New Classes

After creating a new class under `Sovereign\`:
```bash
composer dump-autoload
```
Forgetting this causes `Class not found` errors that look like file path issues.

---

## 6. PHP `include` Path is Relative to Entry Point, Not the File

Use `__DIR__` for includes inside class files:
```php
require_once __DIR__ . '/../config/env.php';   // ✅ correct
require_once '../config/env.php';               // ❌ breaks when called from subdirectory
```

---

## 7. Angel Interior Verified Pattern — Order Create Path

The confirmed working order-create flow from VIPBillion:
- Endpoint: `POST /rest/v1/orders` with `Content-Profile: [schema]`
- Key: service key in both `apikey` and `Authorization: Bearer`
- Header: `X-Project-Id: [project_id]`
- Verification: check inserted row `id` in response body, not just HTTP 201
