---
name: claude-website-cookbook
description: "Reusable PHP snippets referenced by multiple step files. Keeps per-step files lean; avoid duplicating. Linked from SKILL.md and individual steps."
triggers: ["cookbook", "website cookbook", "reusable snippets", "sovereign query", "model format", "static passthrough"]
phase: reference
version: 2.1
status: authoritative
last_updated: "2026-06-02"
---

# claude-website — Cookbook

Reusable PHP snippets that span multiple step files. Each recipe lives here once; step files reference by anchor.

---

## SovereignQuery chain — common shapes
<a name="sovereign-query"></a>

Full docs in Step 07. Patterns you'll reach for often:

```php
// LIST — non-deleted, ordered, first 20
$rows = $api->from('agent_profiles')
    ->select('id, display_name, bio')
    ->eq('isDelete', false)
    ->order('display_name')
    ->limit(20)
    ->get();

// SINGLE — envelope-guarded, returns the row or null
$row = $api->from('agent_profiles')
    ->select('*')
    ->eq('id', $id)
    ->single()
    ->get();

// SINGLE with OR — UUID (profile.id) OR user_id
$row = $api->from('agent_profiles')
    ->select('*')
    ->eq('isDelete', false)
    ->or("id.eq.{$id},user_id.eq.{$id}")
    ->limit(1)
    ->single()
    ->get();

// PAGINATE — offset + limit combined
$rows = $api->from('agent_reviews')
    ->select('*')
    ->eq('agent_profile_id', $profileId)
    ->eq('isDelete', false)
    ->order('review_date', false)    // false = desc
    ->range(0, 9)                    // first page, 10 items
    ->get();

// INSERT
$api->from('agent_leads')->insert([
    'agent_profile_id' => $profileId,
    'name'             => 'Test',
    'isDelete'         => false,
]);

// UPDATE
$api->from('agent_profiles')->eq('id', $id)->update(['title' => 'New']);

// DELETE (soft — recommended; use Model::softDelete())
$api->from('agent_reviews')->eq('id', $id)->update(['isDelete' => true]);
```

## Model::format() alias pattern
<a name="model-format"></a>

Every Model overrides `format()` to alias DB keys, decode JSONB, hydrate nested rows, normalize booleans. Full example in Step 08 Code Vault §2.

```php
protected function format(array $row): array
{
    // 1. Alias DB keys → template keys
    $row['name']  = $row['title']   ?? '';
    $row['photo'] = $row['avatar']  ?? '';

    // 2. Decode JSONB defensively
    $row['skills'] = $this->decodeJsonb($row['skills'] ?? null, []);

    // 3. Boolean cast (PostgREST returns inconsistent shapes)
    if (isset($row['isDelete'])) {
        $row['isDelete'] = $row['isDelete'] === true
            || $row['isDelete'] === 'true'
            || $row['isDelete'] === 't';
    }

    // 4. Sort nested collection
    $children = $row['children_table'] ?? [];
    usort($children, fn($a, $b) => strtotime($b['createdAt']) - strtotime($a['createdAt']));
    $row['children'] = $children;

    return $row;
}

private function decodeJsonb($val, $default)
{
    if ($val === null)   return $default;
    if (is_array($val))  return $val;
    if (is_string($val)) {
        $decoded = json_decode($val, true);
        return $decoded === null ? $default : $decoded;
    }
    return $default;
}
```

## Static passthrough guard
<a name="static-passthrough"></a>

Must run BEFORE `require 'vendor/autoload.php'` in `index.php`. Without it, `/js/app.js` returns HTML.

```php
if (PHP_SAPI === 'cli-server') {
    $path = realpath(__DIR__ . parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
    if ($path && is_file($path)) {
        return false;   // let cli-server serve the file as-is
    }
}
```

## Error envelope — uniform response shape
<a name="error-envelope"></a>

Every endpoint responds with this shape (success OR error). Helpers live in `api/Helper.php`.

```php
// Success
\Sovereign\respond(true, ['id' => '...', 'name' => '...']);
// → {"success":true,"results":{"id":"...","name":"..."}}

// Success with pagination
\Sovereign\respond(true, $rows, null, ['total' => 42, 'page' => 1, 'pageSize' => 10]);
// → {"success":true,"results":[...],"pagination":{"total":42,...}}

// Error — explicit HTTP status
\Sovereign\respondError(404, 'Agent not found');
// → HTTP 404, {"success":false,"error":{"code":404,"message":"Agent not found"}}

// Error — via thrown exception (handled by Lib/ErrorHandler)
throw new \RuntimeException('Bad data', 400);
// → HTTP 400, {"success":false,"error":{"code":400,"message":"Bad data",...}}
```

## CORS preflight — per entry point
<a name="cors-preflight"></a>

Every `api/v1/*.php` starts with this block. Origin list comes from `api/Config.php`.

```php
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
```

## Anon INSERT — return=minimal
<a name="return-minimal"></a>

When writing to a table that has anon INSERT but no anon SELECT (e.g., `agent_leads`), Model::create() MUST pass `returnRow: false` — otherwise the RETURNING triggered by `return=representation` is blocked by RLS and the response is empty.

```php
// Wrong — PostgREST returns [] even though the INSERT succeeded
$result = $model->create($data);

// Right — Prefer: return=minimal, no RETURNING attempted
$result = $model->create($data, returnRow: false);
if (!$result) {
    \Sovereign\respondError(500, 'Lead submission failed');
}
```

## UUID validation
<a name="uuid-validation"></a>

AgentModel::resolve() rejects non-UUID inputs. The helper lives in `api/Helper.php`.

```php
use function Sovereign\isUuid;

if (!isUuid($_GET['agent_id'] ?? '')) {
    http_response_code(404);
    include __DIR__ . '/404.php';
    exit;
}
```

## Casing-sync COALESCE (RLS)
<a name="casing-sync"></a>

Always use this when filtering by JWT project_id — different apps mint JWTs with different casing.

```sql
USING (
  "isDelete" = false
  AND "project_id" = COALESCE(
    auth.jwt() ->> 'project_id',
    auth.jwt() ->> 'projectId'
  )::uuid
)
```

## Robots meta — noindex, nofollow ALWAYS (dev + staging + production)
<a name="robots-meta"></a>

**PERMANENT RULE: Every website on every environment defaults to `noindex, nofollow`.**
This includes production builds. Never change unless the user explicitly instructs it.

```php
// lib/htmlHead.php (or equivalent shared head file)
if (!isset($metaRobot)) {
    $metaRobot = 'noindex, nofollow';   // permanent default — dev, staging, AND production
}
```

```html
<meta name="robots" content="<?= $metaRobot ?>">
```

**Rules:**
- Do NOT auto-switch to `index, follow` during production builds or SEO tasks.
- Only change when user explicitly says: *"enable indexing"* / *"set to index, follow"*.
- For Vue/React: set in `index.html` → `<meta name="robots" content="noindex, nofollow">`
- For PHP: set fallback in shared head partial as shown above.

---

## HTML-escape every dynamic echo
<a name="html-escape"></a>

Every `<?php echo $var ?>` in a template uses `out()`. This is the XSS gate.

```php
<!-- Right -->
<h1><?php out($agent['name']); ?></h1>
<a href="/agents/<?php out($agent['id']); ?>">link</a>

<!-- Wrong -->
<h1><?= $agent['name'] ?></h1>
<?php echo $agent['description']; ?>
```

## No Profile Image fallback
<a name="no-profile-image"></a>

Every `<img>` wrapped. CSS class `personal-image-placeholder` renders a grey circle + icon. No broken image icons.

```php
<?php if (!empty($row['photo'])): ?>
  <img src="<?php out($row['photo']); ?>" alt="<?php out($row['name']); ?>">
<?php else: ?>
  <div class="personal-image-placeholder" aria-label="No profile image">
    <span class="material-symbols-outlined">person</span>
  </div>
<?php endif; ?>
```

## Log every important boundary
<a name="logging"></a>

`writeLog()` from Helper.php auto-rotates at 5 MB. Use at every boundary (request, controller dispatch, exception).

```php
use function Sovereign\writeLog;

writeLog('[Auth] Login attempt for ' . $email);
writeLog('[Lead] Submitted for agent ' . $agentId);
writeLog('[Exception] ' . $e->getMessage(), 'ERROR');
```

---

## Sovereign PHP Recurring Patterns (battle-tested 2026-06-02, angel-interior)

### View tracking — RPC increment + optimistic JS (+1 with no refresh)
<a name="view-tracking"></a>

**DB — one RPC handles all view-counted tables** (extend the IF chain per table):
```sql
CREATE OR REPLACE FUNCTION schema.increment_resource_views(p_table text, p_id uuid)
  RETURNS integer LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'schema'
AS $func$
DECLARE new_views integer := 0;
BEGIN
  IF p_table = 'blog_posts' THEN
    UPDATE schema.blog_posts SET total_views = total_views + 1 WHERE id = p_id RETURNING total_views INTO new_views;
  ELSIF p_table = 'sketchup_resources' THEN
    UPDATE schema.sketchup_resources SET views = views + 1 WHERE id = p_id RETURNING views INTO new_views;
  END IF;
  RETURN COALESCE(new_views, 0);
END; $func$;
```

**PHP endpoint** (`api/v1/track-view.php`) — validate type+UUID, accept short aliases, call rpc:
```php
$allowedTypes = ['blog_posts', 'sketchup_resources', 'material_resources'];
if ($type === 'blog') $type = 'blog_posts';
// ...UUID regex guard...
$result = $client->request('rpc/increment_resource_views', 'POST', ['p_table' => $type, 'p_id' => $id], '');
echo json_encode(['views' => (int) $result['data']]);
```

**Detail template — optimistic +1, then confirm** (user sees count rise instantly, no refresh):
```php
<span id="view-label"><?= htmlspecialchars($post['view_label']) ?></span>
<script>
(function(){
  var id = <?= json_encode($post['id']) ?>;
  var el = document.getElementById('view-label');
  var n = <?= (int)($post['view_count'] ?? 0) ?>;
  function fmt(x){ return x.toLocaleString('en-US') + ' views'; }
  if (el) el.textContent = fmt(n + 1);                 // optimistic, immediate
  fetch('/api/v1/track-view', { method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({type:'blog', id:id}), keepalive:true })
    .then(function(r){ return r.ok ? r.json() : null; })
    .then(function(d){ if (d && d.views!=null && el) el.textContent = fmt(d.views); })
    .catch(function(){});
})();
</script>
```

### Per-page meta description override
<a name="meta-override"></a>

**Why:** `htmlHead.php` re-runs `initData.php` via plain `include` (not require_once), so setting `$metaDescription` directly gets reset. Use an override variable instead.

`initData.php`:
```php
$metaDescription = (!empty($pageMetaDescription))
    ? $pageMetaDescription
    : ($metaData[0]['metaDescription'] ?: 'Description');
```
Template (before `include htmlHead.php`):
```php
$excerpt = trim((string)($post['excerpt'] ?? ''));
if ($excerpt !== '') $pageMetaDescription = mb_substr($excerpt, 0, 160); // 160 = SEO max
```
Other pages set nothing → keep the site default. Same trick works for `$pageMetaTitle`, `$pageOgImage`, etc.

### URL slug routing — url column + UUID fallback
<a name="slug-routing"></a>

Add a `url TEXT UNIQUE NOT NULL` column (backfilled from title). Look up by url first, fall back to UUID so old links never break:
```php
$post = getWebsiteBlogByUrl($slug) ?? getWebsiteBlogById($slug);
// Model: findByUrl() loops listPublished() matching ($p['url'] ?? '') === $url
// Links: href="/blogs/<?= urlencode($post['url'] ?? $post['id']) ?>"
```
Backfill SQL: `lower(regexp_replace(regexp_replace(regexp_replace(title,'[^a-zA-Z0-9\s]','','g'),'\s+','-','g'),'-+$|^-+','','g'))`. No extra grants needed — new column inherits table grants.

### Google Tag Manager — install in shared partials (all pages, zero dup)
<a name="gtm-install"></a>

`lib/htmlHead.php` — Part 1, high in `<head>` after charset/viewport:
```html
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-XXXXXXX');</script>
```
`lib/header.php` — Part 2 noscript, top (header loads first in `<body>` on every page):
```html
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-XXXXXXX" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
```
**GTM ≠ GA4.** GTM is a container that tracks nothing alone. To add Google Analytics, configure a GA4 tag with the `G-XXXXXXX` Measurement ID INSIDE the GTM dashboard — do NOT also paste gtag.js in code (Google: "one Google tag per page" → double-counting).

### Swiper pagination dots — bind to DB count, never hardcode
<a name="swiper-dots"></a>
```php
<div class="swiper-pagination ...">
  <?php foreach ($slides as $i => $s): ?>
  <span class="swiper-pagination-bullet<?= $i === 0 ? ' swiper-pagination-bullet-active' : '' ?>"></span>
  <?php endforeach; ?>
</div>
```
The hero JS reads bullets from the DOM, so dot count must match the slide loop — add/remove a slide in admin and dots follow automatically.

### Generic video embed (TikTok + YouTube + any URL)
<a name="video-embed"></a>
```js
function toEmbedUrl(url){
  url = String(url||'').trim(); if(!url) return '';
  var t = url.match(/tiktok\.com\/(?:@[^/]+\/video\/|embed\/v2\/)(\d+)/i);
  if(t) return 'https://www.tiktok.com/embed/v2/'+encodeURIComponent(t[1])+'?autoplay=1&loop=1&music_info=0&description=0&rel=0';
  var y = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([\w-]{6,})/i);
  if(y) return 'https://www.youtube.com/embed/'+encodeURIComponent(y[1])+'?autoplay=1&rel=0';
  return url; // generic direct video
}
```
Drive modal media from `item.video_url` — never hardcode a single platform.

### Mobile hero image — match the admin upload ratio
<a name="mobile-hero-ratio"></a>

When an admin uploads covers at a fixed ratio (e.g. 800×500 = 16:10), set the mobile container `aspect-ratio` to the SAME ratio with `object-fit: cover` → the full image shows uncropped, no letterboxing.
```css
@media (max-width: 1000px) { .blog-hero-image { aspect-ratio: 16 / 10; } }
@media (max-width: 767px)  { .blog-hero-image { aspect-ratio: 16 / 10; } }
```
