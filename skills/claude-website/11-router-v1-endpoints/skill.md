---
name: website-11-router-v1-endpoints
description: "Step 11 — api/v1/ + index.php + router.php: endpoint adapters (one .php per resource) + static passthrough + get/post dispatch + UUID-only resolution."
triggers: ["router", "endpoints", "v1", "index.php", "router.php", "static passthrough", "uuid only", "cli-server", "get route"]
phase: 3-orchestration
requires: [website-09-controllers-layer, website-10-error-handler]
unlocks: [website-12-ui-refactor]
output_format: php_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 11 — Router + v1 Endpoints (the `api/v1/` pillar)

## 🎯 When to Use
After Controllers + ErrorHandler (Steps 09 + 10). This step exposes the HTTP surface — two separate concerns that both live here:

1. **Page routes** (`index.php` + `router.php`) — user-visible HTML pages (`/agents/{uuid}`, `/agents/{uuid}/review`). Server-rendered via PHP templates (Step 12).
2. **API endpoints** (`api/v1/*.php`) — JSON endpoints for fetch()-style consumers. Each file is a thin adapter that wires the HTTP verb + URL params to a Controller.

## ⚠️ Dependencies
- **09-controllers-layer** — Controllers dispatch by method + id.
- **10-error-handler** — registered at the top of every entry point so uncaught exceptions serialize to the standard envelope.

## 📋 Procedure

### Part A — Page router
1. **Create `router.php`** at project root — Code Vault §1. `get()`, `post()`, `put()`, `patch()`, `delete()`, `route()` helpers using `{param}` dynamic segments.
2. **Create `index.php`** at project root — Code Vault §2. Static passthrough FIRST (before autoload), then router registration.
3. **Register routes** in `index.php` — `get('/agents/{agent_id}', '/home.php')`, `get('/agents/{agent_id}/review', '/review.php')`, etc.

### Part B — API endpoints
1. **Create `api/v1/<resource>.php`** per resource — Code Vault §3. One file = one controller.
2. **Wire id fallback** — `$_GET['id'] ?? $_GET['<resource>_id'] ?? null` — accept both standard and resource-named query keys.
3. **Dispatch** — `(new <Entity>Controller(supabaseClient()))->processRequest($_SERVER['REQUEST_METHOD'], $id);`

### Part C — Serve
1. **Dev**: `php -S localhost:8080 -t .` — the cli-server static passthrough in `index.php` serves JS/CSS/assets before falling through to the router.
2. **Prod**: Apache or nginx — point DocumentRoot at project root, add a rewrite rule to route non-file URLs to `index.php`.

## 📦 Code Vault

### §1. `router.php` — URL dispatch helpers
```php
<?php
session_start();

/**
 * GET route — supports {dynamic} segments (one per route).
 * Example: get('/agents/{agent_id}', '/home.php')
 *   → $_GET['agent_id'] = <captured value>
 *   → include /home.php
 *   → exit
 */
function get($route, $path_to_include)
{
    $request_uri = strtok($_SERVER['REQUEST_URI'], '?');
    $route       = rtrim($route, '/');
    $request_uri = rtrim($request_uri, '/');

    if (strpos($route, '{') !== false) {
        $dynamic_part = substr($route, strpos($route, '{') + 1, -1);
        $base_route   = substr($route, 0, strpos($route, '{'));
        if (strpos($request_uri, $base_route) === 0) {
            $dynamic_value = substr($request_uri, strlen($base_route));
            $_GET[$dynamic_part] = $dynamic_value;
            include_once __DIR__ . $path_to_include;
            exit;
        }
    } else {
        if ($request_uri === $route) {
            include_once __DIR__ . $path_to_include;
            exit;
        }
    }
}

function post($route, $path_to_include)   { if ($_SERVER['REQUEST_METHOD'] == 'POST')   route($route, $path_to_include); }
function put($route, $path_to_include)    { if ($_SERVER['REQUEST_METHOD'] == 'PUT')    route($route, $path_to_include); }
function patch($route, $path_to_include)  { if ($_SERVER['REQUEST_METHOD'] == 'PATCH')  route($route, $path_to_include); }
function delete($route, $path_to_include) { if ($_SERVER['REQUEST_METHOD'] == 'DELETE') route($route, $path_to_include); }
function any($route, $path_to_include)    { route($route, $path_to_include); }

/**
 * Multi-segment route dispatcher with $param placeholders + 404 fallback.
 */
function route($route, $path_to_include)
{
    $callback = $path_to_include;
    if (!is_callable($callback) && !strpos($path_to_include, '.php')) {
        $path_to_include .= '.php';
    }

    if ($route == "/404") {
        include_once __DIR__ . "/$path_to_include";
        exit();
    }

    $request_url = filter_var($_SERVER['REQUEST_URI'], FILTER_SANITIZE_URL);
    $request_url = rtrim($request_url, '/');
    $request_url = strtok($request_url, '?');

    $route_parts       = explode('/', $route);
    $request_url_parts = explode('/', $request_url);
    array_shift($route_parts);
    array_shift($request_url_parts);

    if ($route_parts[0] == '' && count($request_url_parts) == 0) {
        include_once __DIR__ . "/$path_to_include";
        exit();
    }
    if (count($route_parts) != count($request_url_parts)) return;

    $parameters = [];
    for ($i = 0; $i < count($route_parts); $i++) {
        $route_part = $route_parts[$i];
        if (preg_match("/^[$]/", $route_part)) {
            $route_part = ltrim($route_part, '$');
            array_push($parameters, $request_url_parts[$i]);
            $$route_part = $request_url_parts[$i];
        } elseif ($route_parts[$i] != $request_url_parts[$i]) {
            return;
        }
    }

    if (is_callable($callback)) {
        call_user_func_array($callback, $parameters);
        exit();
    }
    include_once __DIR__ . "/$path_to_include";
    exit();
}

// ─── Template-side helpers ────────────────────────────────

function out($text) { echo htmlspecialchars($text); }

function set_csrf()
{
    if (!isset($_SESSION['csrf'])) $_SESSION['csrf'] = bin2hex(random_bytes(50));
    echo '<input type="hidden" name="csrf" value="' . $_SESSION['csrf'] . '">';
}

function is_csrf_valid()
{
    if (!isset($_SESSION['csrf']) || !isset($_POST['csrf'])) return false;
    return $_SESSION['csrf'] === $_POST['csrf'];
}

function active($current_page)
{
    $parts = explode('/', $_SERVER['REQUEST_URI']);
    if ($current_page === end($parts)) echo 'active';
}
```

### §2. `index.php` — front controller (static passthrough + router)
```php
<?php
/**
 * Sovereign Router Entry Point
 *
 * Flow:
 *   1. Static file passthrough (cli-server only) — JS/CSS/assets short-circuit
 *   2. vendor/autoload.php + router.php + ErrorHandler
 *   3. Route table — get/post/route
 */

// ─── 1. Static passthrough — MUST run before autoload ───
// Without this, requests for /js/app.js return HTML from the router,
// breaking every script tag on the page.
if (PHP_SAPI === 'cli-server') {
    $path = realpath(__DIR__ . parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
    if ($path && is_file($path)) {
        return false;   // let the built-in server serve the file as-is
    }
}

// ─── 2. Boot ─────────────────────────────────────────────
require_once __DIR__ . '/api/vendor/autoload.php';
require_once __DIR__ . '/router.php';

use Sovereign\Core\SupabaseClient;
use Sovereign\Lib\ErrorHandler;

set_exception_handler([ErrorHandler::class, 'handleException']);
set_error_handler([ErrorHandler::class, 'handleError']);

$request_uri = $_SERVER['REQUEST_URI'];
error_log('[Sovereign Router] Processing: ' . $request_uri);

// Shared API client — available to every included template
$api = new SupabaseClient();

// ─── 3. Routes ───────────────────────────────────────────

get(route: '/', path_to_include: '/home.php');

// Agent landing — UUID only (AgentModel::resolve rejects non-UUID)
get(route: '/agents/{agent_id}',        path_to_include: '/home.php');
get(route: '/agents/{agent_id}/review', path_to_include: '/review.php');

// 404 fallback
route('/404', '/404.php');
```

### §3. `api/v1/agents.php` — JSON API adapter (one per resource)
```php
<?php
/**
 * Entry: /api/v1/agents.php
 *   GET    /api/v1/agents                 → list
 *   GET    /api/v1/agents?id={uuid}       → single
 */

declare(strict_types=1);
date_default_timezone_set('Asia/Kuala_Lumpur');

require_once __DIR__ . '/../vendor/autoload.php';

use Sovereign\Controllers\AgentController;
use Sovereign\Lib\ErrorHandler;
use function Sovereign\supabaseClient;

set_exception_handler([ErrorHandler::class, 'handleException']);
set_error_handler([ErrorHandler::class, 'handleError']);

// CORS preflight
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$allow  = \Sovereign\getConfig()['allowedOrigins'] ?? [];
if ($origin && in_array($origin, $allow, true)) {
    header("Access-Control-Allow-Origin: {$origin}");
    header('Access-Control-Allow-Methods: GET, POST, PATCH, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
}
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// Accept id | agent_id | slug — dispatcher decides what to do with it
$id = $_GET['id'] ?? $_GET['agent_id'] ?? $_GET['slug'] ?? null;

(new AgentController(supabaseClient()))->processRequest($_SERVER['REQUEST_METHOD'], $id);
```

### §4. `api/v1/leads.php` — anon-write endpoint
```php
<?php
declare(strict_types=1);
date_default_timezone_set('Asia/Kuala_Lumpur');
require_once __DIR__ . '/../vendor/autoload.php';

use Sovereign\Controllers\LeadController;
use Sovereign\Lib\ErrorHandler;
use function Sovereign\supabaseClient;

set_exception_handler([ErrorHandler::class, 'handleException']);
set_error_handler([ErrorHandler::class, 'handleError']);

// (CORS preflight — same block as §3)

(new LeadController(supabaseClient()))->processRequest($_SERVER['REQUEST_METHOD'], null);
```

### §5. Apache `.htaccess` (for non-cli-server hosts)
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]

RewriteRule ^ index.php [L]

<FilesMatch "^\.">
  Require all denied
</FilesMatch>

<FilesMatch "\.(js|css|png|jpg|jpeg|gif|svg|webp|woff2?)$">
  Header set Cache-Control "public, max-age=31536000, immutable"
</FilesMatch>
```

### §6. nginx (equivalent rewrite)
```nginx
location / {
  try_files $uri $uri/ /index.php?$args;
}

location ~ \.php$ {
  include fastcgi_params;
  fastcgi_pass   unix:/var/run/php-fpm.sock;
  fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
}

location ~ /\. { deny all; }
```

## 🛡️ Guardrails

- **STATIC PASSTHROUGH before autoload** — the `PHP_SAPI === 'cli-server'` block in `index.php` MUST run before `require 'vendor/autoload.php'`. Without it, `/js/app.js` returns the router's HTML, every `<script>` tag breaks, site looks unstyled in dev.
- **One v1 adapter per resource** — don't merge multiple resources into one `.php`. The file's job is: pick a controller, wire the id, dispatch. ~20 lines each.
- **Register ErrorHandler at TOP of every entry point** — `index.php` AND each `api/v1/*.php`. Each file is an independent entry; they don't inherit handlers from each other.
- **CORS preflight before dispatch** — the `OPTIONS` short-circuit must come before the Controller is instantiated. Else preflight fails and the browser refuses the real request.
- **UUID-only routing** — `AgentModel::resolve()` rejects non-UUID. So `/agents/john-agent` returns 404. Do NOT add a "slug fallback" without updating the Model's resolve — the website snapshot flags this was intentionally removed on 2026-04-17.
- **`get/post/put/patch/delete` exit on match** — these helpers `exit;` after including the template. Routes are first-match-wins based on declaration order. Put specific routes before general ones.
- **`{agent_id}` captures EVERYTHING after the prefix** — `/agents/{agent_id}` matches `/agents/xxx/yyy/zzz` with agent_id = `xxx/yyy/zzz`. For multi-segment, use `$param` syntax via `route()`.
- **File extension auto-added by `route()`** — NOT by `get()`. `get('/x', '/home.php')` needs the `.php` explicitly.
- **`session_start()`** at the top of router.php — already done. Don't call twice.
- **`out()` for every template echo of user data** — `<?php out($row['name']); ?>`. This is the XSS gate; Step 12 enforces it more.
- **Anon INSERT endpoints use `returnRow: false`** — enforced in the Controller (Step 09).

## ✅ Verify

```bash
# 1. Boot the dev server (from project root)
php -S localhost:8080 -t .

# 2. Static passthrough — expect actual file content
curl -s http://localhost:8080/js/app.js | head -1
# Expected: first line of app.js (NOT HTML)

# 3. Page route
curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/agents/<uuid>
# Expected: 200

# 4. 404 (non-UUID)
curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/agents/john-agent
# Expected: 404

# 5. API — list
curl -s http://localhost:8080/api/v1/agents.php | jq '.results | length'
# Expected: <seed count>

# 6. API — single
curl -s "http://localhost:8080/api/v1/agents.php?id=<uuid>" | jq '.results.name'

# 7. CORS preflight
curl -i -X OPTIONS http://localhost:8080/api/v1/agents.php -H "Origin: http://localhost:3000"
# Expected: 204 with Access-Control-Allow-Origin

# 8. POST lead (anon write)
curl -s -X POST http://localhost:8080/api/v1/leads.php \
  -H "Content-Type: application/json" \
  -d '{"agent_profile_id":"<uuid>","name":"Smoke"}' | jq
# Expected: { success: true, results: { submitted: true } }
```

## ♻️ Rollback
```bash
rm -f index.php router.php
rm -f api/v1/*.php
# All URLs now 404 from the HTTP layer.
```

## → Next Step
**[12-ui-refactor](../12-ui-refactor/skill.md)** — PHP templates (`home.php`, `review.php`) that consume `$api` + Models to render HTML with htmlspecialchars + "No Profile Image" fallback.
