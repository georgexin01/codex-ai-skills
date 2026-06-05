---
name: website-09-controllers-layer
description: "Step 09 — api/Controllers/: BaseController with processRequest dispatch (resource vs collection) + validate() + response helpers. Per-entity Controllers override processResourceRequest / processCollectionRequest."
triggers: ["controllers layer", "base controller", "processRequest", "processResourceRequest", "processCollectionRequest", "validate", "method dispatch"]
phase: 2-engine
requires: [website-08-models-layer]
unlocks: [website-10-error-handler, website-11-router-v1-endpoints]
output_format: php_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 09 — Controllers Layer (the `api/Controllers/` pillar)

## 🎯 When to Use
After Models exist (Step 08). Controllers are the glue between v1 endpoint adapters (Step 11) and Models. They handle HTTP verb dispatch, validation, and response envelope shaping.

## ⚠️ Dependencies
- **08-models-layer** — Controllers consume entity Models.
- **02-env-loader** — Controllers use the `Sovereign\respond()` / `respondError()` / `writeLog()` / `getRequestData()` helpers.

## 📋 Procedure

1. **Create `api/Controllers/BaseController.php`** — Code Vault §1. Handles method dispatch + validation + response helpers.
2. **For each entity**, create `api/Controllers/<Entity>Controller.php`:
   - Extend `BaseController`
   - Inject the Model in the constructor
   - Override `processResourceRequest($method, $id)` for `/resource?id=X` routes (GET/PATCH/DELETE single)
   - Override `processCollectionRequest($method)` for `/resource` routes (GET list / POST create)
   - Set `$requiredFields` for create-time validation
3. **Run `composer dump-autoload`** after adding each new Controller.

## 📦 Code Vault

### §1. `api/Controllers/BaseController.php` — abstract parent
```php
<?php
/**
 * Sovereign BaseController — HTTP dispatch + validation primitives.
 *
 * Children override processResourceRequest / processCollectionRequest
 * and use the inherited validate() + response helpers.
 */

namespace Sovereign\Controllers;

use function Sovereign\getRequestData;
use function Sovereign\respond;
use function Sovereign\respondError;
use function Sovereign\writeLog;

abstract class BaseController
{
    /** Supabase client injected by the endpoint adapter. */
    protected \Sovereign\Core\SupabaseClient $api;

    /** Child sets this; validate() checks all on create. */
    protected array $requiredFields = [];

    public function __construct(\Sovereign\Core\SupabaseClient $api)
    {
        $this->api = $api;
    }

    /**
     * Single public entry point. Dispatches by (method, id) pair.
     *
     * - id present  → processResourceRequest  (/resource?id=X — GET/PATCH/DELETE)
     * - id absent   → processCollectionRequest (/resource — GET/POST)
     */
    public function processRequest(string $method, ?string $id = null): void
    {
        writeLog(sprintf('%s %s (id=%s)', $method, $_SERVER['REQUEST_URI'] ?? '?', $id ?? '-'));

        if ($id !== null && $id !== '') {
            $this->processResourceRequest($method, $id);
        } else {
            $this->processCollectionRequest($method);
        }
    }

    /** Override for single-record routes: /resource?id=X */
    protected function processResourceRequest(string $method, string $id): void
    {
        $this->methodNotAllowed();
    }

    /** Override for list-or-create routes: /resource */
    protected function processCollectionRequest(string $method): void
    {
        $this->methodNotAllowed();
    }

    /** Short-circuit 405. */
    protected function methodNotAllowed(): void
    {
        respondError(405, 'Method not allowed');
    }

    /**
     * Parse body + check required fields.
     *   isUpdate=false → every $requiredFields entry must be present
     *   isUpdate=true  → missing fields are OK (partial update)
     */
    protected function validate(bool $isUpdate = false): array
    {
        $data = getRequestData();

        if (empty($data) && !$isUpdate) {
            respondError(400, 'Request body is required');
        }

        if (!$isUpdate) {
            $missing = [];
            foreach ($this->requiredFields as $field) {
                if (!isset($data[$field]) || $data[$field] === '') $missing[] = $field;
            }
            if (!empty($missing)) {
                respondError(400, 'Missing required fields: ' . implode(', ', $missing));
            }
        }

        return $data;
    }

    /** Convenience wrappers. */
    protected function ok($results = null, ?array $pagination = null): void
    {
        respond(true, $results, null, $pagination, 200);
    }

    protected function created($results = null): void
    {
        respond(true, $results, null, null, 201);
    }
}
```

### §2. `api/Controllers/AgentController.php` — example (GET only)
```php
<?php
/**
 * AgentController — GET /api/v1/agents + GET /api/v1/agents?id={uuid}
 */

namespace Sovereign\Controllers;

use Sovereign\Models\AgentModel;

class AgentController extends BaseController
{
    private AgentModel $model;

    public function __construct(\Sovereign\Core\SupabaseClient $api)
    {
        parent::__construct($api);
        $this->model = new AgentModel($api);
    }

    /** GET /agents?id=X */
    protected function processResourceRequest(string $method, string $id): void
    {
        if ($method !== 'GET') { $this->methodNotAllowed(); return; }

        $agent = $this->model->resolve($id);
        if (!$agent) { \Sovereign\respondError(404, 'Agent not found'); return; }

        $this->ok($agent);
    }

    /** GET /agents */
    protected function processCollectionRequest(string $method): void
    {
        if ($method !== 'GET') { $this->methodNotAllowed(); return; }

        $rows = $this->model->all([], '*');
        $this->ok($rows, ['total' => count($rows)]);
    }
}
```

### §3. `api/Controllers/LeadController.php` — example (POST with validation)
```php
<?php
/**
 * LeadController — POST /api/v1/leads (anon submits contact form).
 * No GET/list endpoint — leads are not anon-readable.
 */

namespace Sovereign\Controllers;

use Sovereign\Models\LeadModel;
use function Sovereign\isValidEmail;

class LeadController extends BaseController
{
    private LeadModel $model;

    protected array $requiredFields = ['agent_profile_id', 'name'];

    public function __construct(\Sovereign\Core\SupabaseClient $api)
    {
        parent::__construct($api);
        $this->model = new LeadModel($api);
    }

    /** POST /leads */
    protected function processCollectionRequest(string $method): void
    {
        if ($method !== 'POST') { $this->methodNotAllowed(); return; }

        $data = $this->validate();                // throws 400 if missing required fields

        // Extra validation — email format if provided
        if (!empty($data['email']) && !isValidEmail($data['email'])) {
            \Sovereign\respondError(400, 'Invalid email address');
            return;
        }

        // Anon INSERT to a table without anon SELECT → returnRow=false mandatory
        $result = $this->model->create([
            'agent_profile_id' => $data['agent_profile_id'],
            'name'             => trim($data['name']),
            'email'            => $data['email'] ?? null,
            'phone'            => $data['phone'] ?? null,
            'message'          => $data['message'] ?? null,
            'isDelete'         => false,
        ], returnRow: false);

        if (!$result) {
            \Sovereign\respondError(500, 'Failed to submit lead.');
            return;
        }

        $this->created(['submitted' => true]);
    }
}
```

### §4. Minimal Controller template (copy & rename)
```php
<?php
namespace Sovereign\Controllers;

use Sovereign\Models\<Entity>Model;

class <Entity>Controller extends BaseController
{
    private <Entity>Model $model;
    protected array $requiredFields = [/* 'field1', 'field2' */];

    public function __construct(\Sovereign\Core\SupabaseClient $api)
    {
        parent::__construct($api);
        $this->model = new <Entity>Model($api);
    }

    protected function processResourceRequest(string $method, string $id): void
    {
        switch ($method) {
            case 'GET':    $this->handleGet($id);    break;
            case 'PATCH':  $this->handleUpdate($id); break;
            case 'DELETE': $this->handleDelete($id); break;
            default:       $this->methodNotAllowed();
        }
    }

    protected function processCollectionRequest(string $method): void
    {
        switch ($method) {
            case 'GET':  $this->handleList();   break;
            case 'POST': $this->handleCreate(); break;
            default:     $this->methodNotAllowed();
        }
    }

    private function handleGet(string $id): void
    {
        $row = $this->model->find($id);
        if (!$row) { \Sovereign\respondError(404, '<Entity> not found'); return; }
        $this->ok($row);
    }

    private function handleList(): void
    {
        $rows = $this->model->all();
        $this->ok($rows, ['total' => count($rows)]);
    }

    private function handleCreate(): void
    {
        $data = $this->validate();
        $row  = $this->model->create($data, returnRow: true);
        if (!$row) { \Sovereign\respondError(500, 'Create failed'); return; }
        $this->created($row);
    }

    private function handleUpdate(string $id): void
    {
        $data = $this->validate(isUpdate: true);
        $row  = $this->model->update($id, $data);
        if (!$row) { \Sovereign\respondError(404, '<Entity> not found'); return; }
        $this->ok($row);
    }

    private function handleDelete(string $id): void
    {
        $ok = $this->model->softDelete($id);
        if (!$ok) { \Sovereign\respondError(404, '<Entity> not found'); return; }
        $this->ok(['deleted' => true]);
    }
}
```

## 🛡️ Guardrails

- **Controllers ship JSON, not HTML** — every public method ends in `respond*()` or an inherited `ok()/created()/methodNotAllowed()`. HTML templates live in Step 12 and call Models directly; Controllers are pure API.
- **Two-method surface** — `processResourceRequest` + `processCollectionRequest`. Do NOT add `processHomepageRequest` or other business routes. The v1 adapter (Step 11) pre-parses the URL and picks which one to call.
- **`validate()` before any write** — every POST/PATCH calls `$this->validate()` or `$this->validate(isUpdate: true)`. Skipping it = missing-field crashes from Model layer.
- **`$requiredFields` is a flat list** — only "must exist AND not empty" semantics. For conditional requirements (X OR Y), validate manually after `validate()` returns.
- **`returnRow: false` for anon-write tables** — when the Controller's Model.create() targets an anon-insert-only table (`agent_leads`), pass `returnRow: false`. Otherwise the Model returns `null` and the Controller wrongly 500s.
- **`respondError()` short-circuits** — it `exit;`s. Code after it is dead. Plan control flow to return EITHER early via respondError OR fall through to ok().
- **Log every request** — `writeLog()` fires inside `processRequest`. Don't disable it; the API log is the only visibility into what anon traffic does.
- **Controllers NEVER import `SupabaseClient`** — they receive it via constructor from the v1 adapter. This makes Controllers unit-testable with a mock client (even though this stack doesn't ship tests yet).
- **One Model per Controller, typically** — a Controller that loads three Models is a code smell; the third Model is probably a join, not a standalone entity.
- **`composer dump-autoload`** after adding a new Controller. Without it, PSR-4 can't find the class.

## ✅ Verify

```bash
# 1. PHP parse
php -l api/Controllers/BaseController.php
php -l api/Controllers/AgentController.php
php -l api/Controllers/LeadController.php

# 2. Controllers autoload
composer dump-autoload

# 3. Simulate dispatch
php -r "
  require 'vendor/autoload.php';
  \$api = \Sovereign\supabaseClient();
  \$c   = new Sovereign\Controllers\AgentController(\$api);
  // Can't call processRequest in CLI without exit — but instantiation itself validates the class.
  echo 'ok';
"
# Expected: ok

# 4. End-to-end via v1 adapter (after Step 11 lands)
curl -s "http://localhost:8080/api/v1/agents" | jq
# Expected: { success: true, results: [...], pagination: { total: 4 } }

curl -s "http://localhost:8080/api/v1/agents?id=<uuid>" | jq
# Expected: { success: true, results: { id, name, reviews: [...] } }

# 5. POST lead
curl -s -X POST "http://localhost:8080/api/v1/leads" \
  -H "Content-Type: application/json" \
  -d '{"agent_profile_id":"<uuid>","name":"Test Lead","email":"t@x.com"}'
# Expected: { success: true, results: { submitted: true } }
```

## ♻️ Rollback
```bash
rm -f api/Controllers/<Entity>Controller.php
composer dump-autoload
# The matching v1 adapter (e.g. api/v1/<entity>.php) will fatal at `new <Entity>Controller(...)`.
```

## → Next Step
**[10-error-handler](../10-error-handler/skill.md)** — global `Lib/ErrorHandler.php` so unhandled exceptions serialize to the same JSON envelope as explicit `respondError()`.
