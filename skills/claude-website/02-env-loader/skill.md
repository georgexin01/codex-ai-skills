---
name: website-02-env-loader
description: "Step 02 — api/Config.php + api/Helper.php: Sovereign\\Config constant with per-env blocks + global procedural helpers (respond, getConfig, supabaseClient, upload, slug, log)."
triggers: ["env loader", "config php", "sovereign config", "respond helper", "helper php", "procedural helpers", "getConfig"]
phase: 1-foundation
requires: [website-01-config-generation]
unlocks: [website-03-composer-autoload]
output_format: php_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 02 — Env Loader (`api/Config.php` + `api/Helper.php`)

## 🎯 When to Use
After Step 01 (folder + .env exist). Before Composer autoload (Step 03).

Two files together:
- **`api/Config.php`** — declares `const Sovereign\Config` with dev/production blocks (allowed origins, storage, mail, log path).
- **`api/Helper.php`** — procedural functions in `namespace Sovereign;` (respond, getConfig, supabaseClient, upload, slug, log, email validation).

These are loaded via Composer's `files` autoload entry (Step 03), so they're available globally without manual `require`.

## ⚠️ Dependencies
- **01-config-generation** — `api/core/.env` exists with `APP_ENV` key.

## 📋 Procedure

1. **Create `api/Config.php`** — copy Code Vault §1. Per-environment blocks keyed by `APP_ENV`.
2. **Create `api/Helper.php`** — copy Code Vault §2. Procedural helpers: response envelope, dev/prod resolver, supabase client factory, upload, validators, logger.
3. **(Step 03 will register both via composer.json `files` autoload.)**

## 📦 Code Vault

### §1. `api/Config.php`
```php
<?php
namespace Sovereign;

/**
 * Sovereign Config — environment-specific config blocks.
 * Active environment resolved by APP_ENV in core/.env (default 'dev').
 *
 * Secrets (Supabase URL/anon key) live in core/.env — this file only
 * holds non-secret defaults + per-environment overrides.
 */

const Config = [
    'dev' => [
        'allowedOrigins' => [
            'http://localhost:8080',
            'http://localhost:3000',
            'http://localhost:5666',
            'http://127.0.0.1:8080',
        ],
        'storage' => [
            'bucket'        => 'quizLaa',
            'uploadsDir'    => __DIR__ . '/../uploads',
            'publicPrefix'  => '/uploads',
            'maxPhotoBytes' => 2097152,              // 2 MB
            'allowedMime'   => ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
        ],
        'mail' => [
            'enabled' => false,
            'from'    => 'noreply@laa.com.my',
        ],
        'logPath' => __DIR__ . '/logs/api.log',
    ],

    'production' => [
        'allowedOrigins' => [
            'https://laa.com.my',
            'https://www.laa.com.my',
        ],
        'storage' => [
            'bucket'        => 'quizLaa',
            'uploadsDir'    => __DIR__ . '/../uploads',
            'publicPrefix'  => '/uploads',
            'maxPhotoBytes' => 2097152,
            'allowedMime'   => ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
        ],
        'mail' => [
            'enabled' => true,
            'from'    => 'noreply@laa.com.my',
        ],
        'logPath' => __DIR__ . '/logs/api.log',
    ],
];
```

### §2. `api/Helper.php` — procedural layer
```php
<?php
/**
 * Sovereign Helper — procedural helpers used across the API layer.
 * Lives in namespace Sovereign; functions are globally available via
 * composer.json `files` autoload entry.
 */

namespace Sovereign;

/**
 * Resolve active environment config block.
 * Reads APP_ENV from core/.env (dev | production), falls back to 'dev'.
 */
function getConfig(): array
{
    static $cached = null;
    if ($cached !== null) return $cached;

    $envPath = __DIR__ . '/core/.env';
    $env = 'dev';
    if (file_exists($envPath)) {
        $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) continue;
            if (strpos($line, 'APP_ENV=') === 0) {
                $env = trim(substr($line, 8));
                break;
            }
        }
    }

    $all = Config;
    $cached = $all[$env] ?? $all['dev'];
    $cached['__env'] = $env;
    return $cached;
}

/**
 * Return a ready SupabaseClient instance.
 * Lazy-initialized; reused across the request.
 */
function supabaseClient(): \Sovereign\Core\SupabaseClient
{
    static $client = null;
    if ($client === null) $client = new \Sovereign\Core\SupabaseClient();
    return $client;
}

/**
 * Standard JSON response envelope.
 * Shape: { success, results, pagination?, error? }
 * Emits headers + echoes + exits.
 */
function respond(bool $success, $results = null, ?array $error = null, ?array $pagination = null, int $httpCode = 200): void
{
    if (!headers_sent()) {
        header('Content-Type: application/json; charset=utf-8');
        http_response_code($httpCode);
    }

    $payload = ['success' => $success];
    $payload['results'] = $results;
    if ($pagination !== null) $payload['pagination'] = $pagination;
    if ($error !== null)      $payload['error'] = $error;

    echo json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    exit;
}

/** Shortcut: respond with an error envelope. */
function respondError(int $code, string $message, int $httpCode = 0): void
{
    respond(false, null, ['code' => $code, 'message' => $message], null, $httpCode ?: $code);
}

/**
 * Parse incoming request body.
 * Priority: JSON body → multipart form-data fields → $_GET.
 */
function getRequestData(): array
{
    $raw = file_get_contents('php://input');
    if ($raw && strlen($raw) > 0) {
        $decoded = json_decode($raw, true);
        if (is_array($decoded)) return $decoded;
    }
    if (!empty($_POST)) return $_POST;
    return [];
}

/** Validate an email address. */
function isValidEmail(string $email): bool
{
    return (bool) filter_var($email, FILTER_VALIDATE_EMAIL);
}

/** Validate a Malaysian mobile number (60X). */
function isValidPhoneMY(string $phone): bool
{
    $digits = preg_replace('/\D/', '', $phone);
    return (bool) preg_match('/^60\d{8,10}$/', $digits);
}

/** Sanitize a slug — keep a-z, 0-9, hyphens only. */
function sanitizeSlug(string $input): string
{
    return preg_replace('/[^a-z0-9\-]/i', '', strtolower($input));
}

/** Detect UUID v4 format. */
function isUuid(string $input): bool
{
    return (bool) preg_match('/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i', $input);
}

/**
 * Upload a single image to the local uploads directory.
 * Validates MIME + size against config. Returns relative path on success.
 * Throws \RuntimeException on validation failure.
 */
function uploadImage(array $fileEntry, string $folder): string
{
    $cfg = getConfig()['storage'];

    if (!isset($fileEntry['tmp_name']) || !is_uploaded_file($fileEntry['tmp_name'])) {
        throw new \RuntimeException('No file uploaded.');
    }
    if ($fileEntry['size'] > $cfg['maxPhotoBytes']) {
        throw new \RuntimeException('File exceeds max size.');
    }
    // Server-side MIME detection (client-supplied 'type' is untrustworthy)
    $finfo = new \finfo(FILEINFO_MIME_TYPE);
    $mime  = $finfo->file($fileEntry['tmp_name']);
    if (!in_array($mime, $cfg['allowedMime'], true)) {
        throw new \RuntimeException('File type not allowed.');
    }

    $ext = strtolower(pathinfo($fileEntry['name'], PATHINFO_EXTENSION)) ?: 'bin';
    $destDir = rtrim($cfg['uploadsDir'], '/') . '/' . trim($folder, '/');
    if (!is_dir($destDir)) @mkdir($destDir, 0775, true);

    $fileName = bin2hex(random_bytes(8)) . '_' . time() . '.' . $ext;
    $destFull = $destDir . '/' . $fileName;
    if (!@move_uploaded_file($fileEntry['tmp_name'], $destFull)) {
        throw new \RuntimeException('Failed to save upload.');
    }

    return rtrim($cfg['publicPrefix'], '/') . '/' . trim($folder, '/') . '/' . $fileName;
}

/** Append a message to the api log file. Auto-rotates at ~5 MB. */
function writeLog(string $message, string $level = 'INFO'): void
{
    $path = getConfig()['logPath'];
    $dir  = dirname($path);
    if (!is_dir($dir)) @mkdir($dir, 0775, true);

    if (file_exists($path) && filesize($path) > 5 * 1024 * 1024) {
        @rename($path, $path . '.' . date('Ymd_His'));
    }
    $line = sprintf("[%s] [%s] %s\n", date('c'), $level, $message);
    @file_put_contents($path, $line, FILE_APPEND | LOCK_EX);
}
```

### §3. `api/core/SupabaseConfig.php` (env parser for Supabase keys — lives in core/)
```php
<?php
namespace Sovereign\Core;

/**
 * Supabase Environment Configuration Loader.
 * Reads api/core/.env — SUPABASE_URL / SUPABASE_ANON_KEY / SUPABASE_SCHEMA.
 * Called by SupabaseClient constructor (Step 07).
 */

class SupabaseConfig {
    private static $envCache = null;

    public static function loadEnv($envFile = '.env') {
        if (self::$envCache !== null) return self::$envCache;

        // Check in the same directory as this file (api/core/)
        $path = __DIR__ . '/' . $envFile;
        if (!file_exists($path)) {
            $path = __DIR__ . '/../../' . $envFile;  // fallback two levels up
        }
        if (!file_exists($path)) return [];           // silent fail for safety

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        $config = [];
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) continue;
            if (strpos($line, '=') !== false) {
                list($key, $value) = explode('=', $line, 2);
                $config[trim($key)] = trim($value);
            }
        }

        self::$envCache = $config;
        return $config;
    }

    public static function get($key, $default = null) {
        $env = self::loadEnv();
        return $env[$key] ?? $default;
    }
}
```

## 🛡️ Guardrails

- **`const Sovereign\Config`** (not a class) — defined via the `const` keyword inside `namespace Sovereign;`. This lets `getConfig()` read the map without instantiating anything. Do NOT convert to a `class Config { public const ... }` — it breaks `$all = Config;` access pattern.
- **Secrets stay in `.env`** — `Config.php` is committed to git. `api/core/.env` and `.env.production` are gitignored. NEVER hardcode URLs/keys in `Config.php`.
- **No `putenv()`** — pollutes the process env, leaks across FastCGI workers. Use `SupabaseConfig::loadEnv()` cache instead.
- **Silent-fail on missing `.env`** — `loadEnv()` returns `[]` rather than throwing. The `SupabaseClient` constructor then gets `null` keys, which surface as 401 from PostgREST — easier to debug than a boot-time fatal.
- **Response envelope consistency** — every endpoint uses `respond(success, results, error?, pagination?, httpCode?)`. Never echo raw HTML/JSON yourself.
- **`respond()` exits** — it calls `exit;`. Any code after `respond(...)` in an endpoint is dead. Plan control flow accordingly.
- **`uploadImage()` uses server-side MIME** — never trust `$_FILES['tmp_name']['type']` (client-supplied). The `finfo` extension is required.
- **Log rotation at 5 MB** — `writeLog()` auto-rotates. Don't disable this; unbounded log files fill disks.
- **Uploads folder writable** — dev needs `api/uploads/*` writable by the PHP process. `@mkdir(... 0775, true)` handles it, but the parent must exist.

## ✅ Verify

```bash
# 1. PHP parse check
php -l api/Config.php
php -l api/Helper.php
# Expected: "No syntax errors detected"

# 2. Constant + function reachability (after Step 03 composer dump-autoload)
php -r "require 'vendor/autoload.php'; var_dump(\Sovereign\getConfig()['__env']);"
# Expected: string(3) "dev" (or "production")

# 3. Response envelope (simulate endpoint)
php -r "require 'vendor/autoload.php'; \Sovereign\respond(true, ['hello'=>'world']);"
# Expected: {"success":true,"results":{"hello":"world"}}
```

## ♻️ Rollback
```bash
rm -f api/Config.php api/Helper.php api/core/SupabaseConfig.php
# Endpoints that called Sovereign\respond(), supabaseClient(), etc. will fatal immediately.
```

## 🌐 Host-Based `.env` Auto-Detection (PHP website ONLY)

> **Scope:** Applies to the **PHP website** (`api/core/SupabaseConfig.php`) ONLY.
> The Vben/Vue **admin panel is unaffected** — it uses Vite's own `--mode` env system
> (`.env.development`, `.env.production`, `pnpm dev --mode development.supabase`), a
> completely separate build-time mechanism. Never apply this PHP host-detection to the admin.

PHP has no `npm run dev` / build step, so it cannot rely on a build-time flag to pick
the env file. Instead, `SupabaseConfig::resolveEnvFile()` auto-detects by **request host**:

| Request host (`$_SERVER['HTTP_HOST']`) | Detected env | Env file | Supabase target |
|----------------------------------------|--------------|----------|-----------------|
| `localhost` / `localhost:8000` | `dev` | `.env` | `http://localhost:54321` (local Docker) |
| `127.0.0.1` / `127.0.0.1:8000` | `dev` | `.env` | `http://localhost:54321` (local Docker) |
| `interiordesign-angel.com` (any real domain) | `production` | `.env.production` | VPS Supabase |

### The two methods

```php
// Host detection — matches localhost / 127.0.0.1 with optional :port
public static function currentEnvName(): string
{
    if (self::$envName !== null) return self::$envName;
    $host = $_SERVER['HTTP_HOST'] ?? 'cli';
    $isLocal = (bool) preg_match('/^(localhost|127\.0\.0\.1)(:\d+)?$/i', $host);
    self::$envName = $isLocal ? 'dev' : 'production';
    return self::$envName;
}

// File resolver — manual override wins, else host-based auto-detect
private static function resolveEnvFile(?string $envFile = null): string
{
    if ($envFile !== null) return $envFile;

    // Manual escape hatch for debugging (e.g. force VPS from localhost)
    $override = trim((string) (getenv('SUPABASE_ENV_FILE') ?: ($_SERVER['SUPABASE_ENV_FILE'] ?? '')));
    if ($override !== '') return $override;

    // Auto-detect by host. NO hardcoded ".env.production wins" override.
    return self::currentEnvName() === 'dev' ? '.env' : '.env.production';
}
```

### Critical rule — NO hardcoded production override

A previous version had this **anti-pattern** that broke localhost detection:

```php
// ❌ WRONG — forces production even on localhost, ignores host detection
if (is_file(__DIR__ . '/.env.production')) {
    return '.env.production';
}
```

Because `.env.production` almost always exists, this branch always fired and localhost
silently used the VPS DB. **Never reintroduce a "file exists → use production" shortcut.**
Let `currentEnvName()` host detection decide.

### Consequences
- **Localhost testing now requires Supabase Docker running** (`supabase start`) because
  `.env` points to `http://localhost:54321`. This is the standard local-dev expectation.
- `SUPABASE_ENV_FILE=.env.production php -S localhost:8000` forces VPS from localhost when
  you need to debug against prod data without Docker.
- `HTTP_HOST` never contains the protocol — it is `localhost:8000`, not `https://localhost:8000`.
  The regex matches host + optional port only.

### Verify
```bash
# Local (Docker must be up) — resolves to .env / localhost:54321
curl -s "http://localhost:8000/api/v1/sketchup-resources" | head
# Real domain — resolves to .env.production / VPS Supabase
```

## → Next Step
**[03-composer-autoload](../03-composer-autoload/skill.md)** — `composer.json` + `composer install` wire both files into Composer's PSR-4 + files autoload.
