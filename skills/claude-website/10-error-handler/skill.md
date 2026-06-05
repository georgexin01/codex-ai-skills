---
name: website-10-error-handler
description: "Step 10 — api/Lib/ErrorHandler.php: global exception + error-to-exception converter. Uniform JSON envelope, dev-verbose / prod-masked, logs every crash to the api log."
triggers: ["error handler", "exception handler", "lib errorhandler", "set_exception_handler", "set_error_handler", "crash reporting"]
phase: 2-engine
requires: [website-09-controllers-layer]
unlocks: [website-11-router-v1-endpoints]
output_format: php_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 10 — Error Handler (the `api/Lib/` pillar)

## 🎯 When to Use
After Controllers exist (Step 09). Before endpoint adapters (Step 11) — because the adapters register the handler on every request.

Without this step, an unhandled exception in a Controller outputs a raw PHP stack trace (or blank page in prod), breaking the uniform `{success, results, error}` envelope your frontend/admin code assumes.

## ⚠️ Dependencies
- **09-controllers-layer** — exists so there's code to catch exceptions from.
- **03-composer-autoload** — `Sovereign\\Lib\\` PSR-4 mapped to `api/Lib/` (added in Step 03 Code Vault §1).

## 📋 Procedure

1. **Create `api/Lib/ErrorHandler.php`** — Code Vault §1. Two static methods: `handleException()` (top-level catch) + `handleError()` (PHP errors → ErrorException).
2. **Register in every entry point** — Code Vault §2. `index.php`, `router.php`, `api/v1/*.php`. Registration must happen AFTER `vendor/autoload.php` but BEFORE any controller logic.
3. **Verify** — throw a test exception from a Controller; expect a JSON envelope with HTTP status matching the exception code.

## 📦 Code Vault

### §1. `api/Lib/ErrorHandler.php`
```php
<?php
/**
 * Sovereign ErrorHandler — uniform crash + log handling.
 *
 * Converts raw PHP errors to ErrorException so they bubble to
 * handleException(), which serializes them into our JSON envelope.
 */

namespace Sovereign\Lib;

use function Sovereign\respond;
use function Sovereign\writeLog;

class ErrorHandler
{
    /**
     * Top-level exception catcher.
     * Masks internal details in production; verbose in dev.
     */
    public static function handleException(\Throwable $e): void
    {
        $env   = \Sovereign\getConfig()['__env'] ?? 'dev';
        $isDev = ($env === 'dev');

        // Exception code → HTTP status — clamp to 4xx/5xx
        $code = $e->getCode() ?: 500;
        if ($code < 400 || $code > 599) $code = 500;

        $detail = [
            'code'    => $code,
            'message' => $isDev ? $e->getMessage() : 'Internal server error',
        ];
        if ($isDev) {
            $detail['file']  = $e->getFile();
            $detail['line']  = $e->getLine();
            // trace intentionally omitted — too verbose for JSON; see log for it
        }

        writeLog(
            '[Exception] ' . $e->getMessage() . ' @ ' . $e->getFile() . ':' . $e->getLine(),
            'ERROR',
        );

        respond(false, null, $detail, null, $code);
    }

    /**
     * Converts PHP errors (E_NOTICE, E_WARNING, etc.) to exceptions so
     * handleException() can format them uniformly.
     */
    public static function handleError(int $no, string $str, string $file, int $line): bool
    {
        // Respect @-suppressed errors
        if (!(error_reporting() & $no)) return false;
        throw new \ErrorException($str, 0, $no, $file, $line);
    }
}
```

### §2. Registration boilerplate (every URL-targetable `.php`)
```php
<?php
// api/v1/agents.php  (or index.php / router.php — any entry point)

require_once __DIR__ . '/../../vendor/autoload.php';

use Sovereign\Lib\ErrorHandler;

// Register handlers BEFORE any business logic.
set_exception_handler([ErrorHandler::class, 'handleException']);
set_error_handler([ErrorHandler::class, 'handleError']);

// CORS preflight — must run before autoload-dependent code if preflight can arrive.
$origin    = $_SERVER['HTTP_ORIGIN'] ?? '';
$allowedOr = \Sovereign\getConfig()['allowedOrigins'] ?? [];
if ($origin && in_array($origin, $allowedOr, true)) {
    header("Access-Control-Allow-Origin: {$origin}");
    header('Access-Control-Allow-Methods: GET, POST, PATCH, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    header('Access-Control-Max-Age: 86400');
}
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// ... business logic (Controller dispatch) ...
```

### §3. Thrown error → JSON envelope (what the caller sees)
```json
// Dev mode — verbose
{
  "success": false,
  "results": null,
  "error": {
    "code": 500,
    "message": "Undefined array key \"reviews\"",
    "file": "/app/api/Models/AgentModel.php",
    "line": 72
  }
}

// Production mode — masked
{
  "success": false,
  "results": null,
  "error": {
    "code": 500,
    "message": "Internal server error"
  }
}
```

### §4. Explicit HTTP status via exception code (pattern)
```php
// In a Controller or Model, when you want a specific HTTP status:
throw new \RuntimeException('Agent not found', 404);
// → handleException will emit HTTP 404 with the message in dev, "Internal server error" in prod.

// For user-facing 4xx, prefer respondError() (it won't be masked in prod):
\Sovereign\respondError(404, 'Agent not found');
```

## 🛡️ Guardrails

- **Dev vs prod masking** — in production, exception messages are replaced with `"Internal server error"`. This prevents leaking framework internals, query fragments, or PII. Dev mode passes the real message through. The `$isDev` switch is driven by `APP_ENV` in `.env`.
- **Code clamp to 4xx/5xx** — `$e->getCode()` defaults to 0 if not set. `handleException` coerces 0 → 500, and anything outside 400-599 → 500. Don't fight this; set codes explicitly via `throw new \RuntimeException($msg, 404)` when you want a specific status.
- **`set_error_handler` converts notices/warnings to exceptions** — without it, an undefined-index warning on `$row['foo']` prints inline HTML into your JSON response (breaking parse) without triggering the exception handler. This line is load-bearing.
- **Respect `@` suppression** — `if (!(error_reporting() & $no)) return false;` lets code like `@mkdir(...)` stay silent. Don't remove this; uploadImage() in Helper.php relies on it.
- **Write to the API log** — every exception hits `writeLog('[Exception] ...', 'ERROR')`. In prod where the message is masked, the log is your ONLY trace. Never swallow exceptions without logging.
- **No stack trace in JSON** — even in dev. Stack traces are noisy in a JSON envelope, and prod would leak internals. If you need the trace, tail the log file (`api/logs/api.log`).
- **Register BEFORE business code** — if you `require 'AgentController.php'` before `set_exception_handler`, a fatal during class loading won't be caught.
- **`respond()` exits, so `handleException` exits too** — don't chain code after either.
- **CORS lives next to the handler** — both must run before Controller dispatch. Keep them co-located in the entry point so reviewers see the whole "pre-business" stanza in one place.
- **OPTIONS preflight returns 204** — don't accidentally run the Controller on OPTIONS. The `exit;` after the preflight block is mandatory.

## ✅ Verify

```bash
# 1. PHP parse
php -l api/Lib/ErrorHandler.php

# 2. Autoload
composer dump-autoload
php -r "
  require 'vendor/autoload.php';
  class_exists('Sovereign\\Lib\\ErrorHandler') ? print('ok') : print('MISSING');
"
# Expected: ok

# 3. Simulate thrown exception via endpoint
# Put this in a test endpoint temporarily:
#   throw new \RuntimeException('Test exception', 418);
# Then curl it:
curl -i "http://localhost:8080/api/v1/test"
# Expected (dev): HTTP 418, body {success:false, error:{code:418, message:"Test exception", file:..., line:...}}

# 4. Warning → exception
#   In a test endpoint:  $x = $undefined_var;
# Expected: HTTP 500, body {success:false, error:{code:500, message:"Undefined variable: undefined_var", ...}}

# 5. Log was written
tail -5 api/logs/api.log
# Expected: a line "[Exception] Test exception @ /app/.../endpoint.php:N"
```

## ♻️ Rollback
```bash
rm -f api/Lib/ErrorHandler.php
# Remove the set_exception_handler / set_error_handler lines from every entry point.
# Uncaught exceptions now render raw PHP stack traces (or blank pages in prod).
# You will regret this; revert quickly.
```

## → Next Step
**[11-router-v1-endpoints](../11-router-v1-endpoints/skill.md)** — `api/v1/*.php` adapters + root `index.php` static passthrough + `router.php` get/post dispatch.
