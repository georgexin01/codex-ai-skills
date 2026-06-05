---
name: website-03-composer-autoload
description: "Step 03 — composer.json: PSR-4 autoload for Sovereign\\Core, Models, Controllers + files autoload for Config.php + Helper.php. Install vlucas/phpdotenv."
triggers: ["composer autoload", "composer json", "psr-4", "sovereign namespace", "files autoload", "composer install", "dump-autoload"]
phase: 1-foundation
requires: [website-02-env-loader]
unlocks: [website-04-schema-building, website-07-rest-client, website-08-models-layer, website-09-controllers-layer]
output_format: config
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 03 — Composer Autoload (the `api/vendor/` pillar)

## 🎯 When to Use
After `api/Config.php` + `api/Helper.php` exist (Step 02). Before any class using `namespace Sovereign\Core\*` is instantiated.

## ⚠️ Dependencies
- **02-env-loader** — Config.php + Helper.php need to be autoload-reachable.
- **Composer installed** — `composer --version` must work. If not: `brew install composer` / `choco install composer` / download from getcomposer.org.

## 📋 Procedure

1. **Create `composer.json`** at project root — copy Code Vault §1. Declares PSR-4 for 3 namespaces + `files` autoload for 2 procedural files.
2. **Install dependencies** — run `composer install`. Creates `vendor/` + `composer.lock`.
3. **Require `vendor/autoload.php`** in any entry point (index.php, router.php, v1/*.php) — Code Vault §2.
4. **After any new Model/Controller file** — run `composer dump-autoload`. Refreshes the classmap so PSR-4 finds new classes without a full `composer install`.

## 📦 Code Vault

### §1. `composer.json`
```json
{
  "name": "sovereign/<website-name>",
  "description": "Sovereign PHP + Supabase REST — agent landing / reviews",
  "type": "project",
  "require": {
    "php": ">=8.0",
    "vlucas/phpdotenv": "^5.5"
  },
  "autoload": {
    "psr-4": {
      "Sovereign\\Core\\": "api/core/",
      "Sovereign\\Models\\": "api/Models/",
      "Sovereign\\Controllers\\": "api/Controllers/",
      "Sovereign\\Lib\\": "api/Lib/"
    },
    "files": [
      "api/Config.php",
      "api/Helper.php"
    ]
  },
  "config": {
    "optimize-autoloader": true,
    "sort-packages": true
  }
}
```

### §2. Entry-point boot (every `.php` that's a URL target)
```php
<?php
// index.php / router.php / api/v1/*.php
require_once __DIR__ . '/vendor/autoload.php';

use Sovereign\Core\SupabaseClient;
use Sovereign\Controllers\AgentController;

// Helpers are globally available via `files` autoload — no use statement needed,
// but call them via the namespace:
\Sovereign\respond(true, ['hello' => 'world']);
```

### §3. Autoload refresh after adding Models/Controllers
```bash
# After creating api/Models/NewEntityModel.php or api/Controllers/NewEntityController.php:
composer dump-autoload
# Expected output: "Generated optimized autoload files containing NN classes"
```

### §4. `api/core/` namespace layout (PSR-4 mapping in action)
```
api/core/                                         namespace Sovereign\Core
├── SupabaseClient.php      ← Sovereign\Core\SupabaseClient
├── SupabaseConfig.php      ← Sovereign\Core\SupabaseConfig
├── SovereignQuery.php      ← Sovereign\Core\SovereignQuery
└── SovereignStorage.php    ← Sovereign\Core\SovereignStorage

api/Models/                                        namespace Sovereign\Models
├── BaseModel.php           ← Sovereign\Models\BaseModel
├── AgentModel.php          ← Sovereign\Models\AgentModel
└── ReviewModel.php         ← Sovereign\Models\ReviewModel

api/Controllers/                                   namespace Sovereign\Controllers
├── BaseController.php      ← Sovereign\Controllers\BaseController
├── AgentController.php     ← Sovereign\Controllers\AgentController
└── ReviewController.php    ← Sovereign\Controllers\ReviewController

api/Lib/                                           namespace Sovereign\Lib
└── ErrorHandler.php        ← Sovereign\Lib\ErrorHandler
```

## 🛡️ Guardrails

- **`Sovereign\\` double backslash in JSON** — PSR-4 keys in JSON require escaped backslashes: `"Sovereign\\Core\\": "..."`. A single backslash is a JSON parse error.
- **Path is relative to composer.json** — `"api/core/"` means the folder next to composer.json. No leading slash. Trailing slash is required.
- **`files` autoload** loads the listed PHP files on every request (via `vendor/autoload.php`). Use ONLY for files containing functions or global constants (`Config.php`, `Helper.php`). Never put classes there — let PSR-4 handle classes.
- **Run `dump-autoload` after creating new Model/Controller** — optimize-autoloader caches a classmap. Without the refresh, new classes throw "Class not found" even though the file exists.
- **`optimize-autoloader: true`** — builds a classmap for production-speed lookups. In dev you may prefer removing it to auto-discover new files without `dump-autoload`, but leave it on for the spec.
- **`vendor/` is gitignored** — regenerate with `composer install`; `composer.lock` IS committed (pins exact versions for reproducible builds).
- **Don't `require_once 'SupabaseConfig.php'` manually** — SupabaseClient.php even has a comment warning about this (double-load fatal on Windows when path casing differs). Let Composer handle it.
- **Namespace casing matters on Linux** — `Sovereign\Core\SupabaseClient` must match the file path `api/core/SupabaseClient.php` exactly. `api/Core/...` vs `api/core/...` is a case-sensitive lookup failure on Linux hosts.
- **One `vendor/` per project** — do NOT nest vendored composer installs. Flat at project root.

## ✅ Verify

```bash
# 1. Composer install runs clean
composer install
# Expected: "Generating optimized autoload files" + 0 errors

# 2. Classes resolve via PSR-4
php -r "require 'vendor/autoload.php'; new Sovereign\Core\SupabaseClient();"
# Expected: no output (silent success) — a "Class not found" means path/case is wrong

# 3. Files autoload — procedural function reachable
php -r "require 'vendor/autoload.php'; var_dump(\Sovereign\isUuid('not-a-uuid'));"
# Expected: bool(false)

# 4. Check composer.lock is NOT in .gitignore
grep -c "composer.lock" .gitignore
# Expected: 0 (composer.lock IS committed)

# 5. Check vendor/ IS in .gitignore
grep -c "vendor/" .gitignore
# Expected: >= 1
```

## ♻️ Rollback
```bash
rm -rf vendor/ composer.lock
rm -f composer.json
# Anything that used `require 'vendor/autoload.php'` will fatal.
```

## → Next Step
**[04-schema-building](../04-schema-building/skill.md)** — SQL DDL in the `quizLaa` schema. UUID PKs, soft-delete, timestamps.
Parallel: **[07-rest-client](../07-rest-client/skill.md)** can be drafted once autoload works.
