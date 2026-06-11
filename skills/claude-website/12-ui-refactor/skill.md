---
name: website-12-ui-refactor
description: "Step 12 — PHP templates (home.php, review.php): server-rendered HTML with out()/htmlspecialchars XSS guard, No Profile Image fallback, Model consumption pattern."
triggers: ["ui refactor", "php templates", "home.php", "review.php", "htmlspecialchars", "out helper", "no profile image", "personal-image-placeholder"]
phase: 3-orchestration
requires: [website-11-router-v1-endpoints]
unlocks: [website-13-brain-hardening]
output_format: php_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 12 — UI Refactor (PHP templates)

## 🎯 When to Use
After the router can dispatch to template files (Step 11). This step defines how PHP templates consume Models + render safe HTML.

## ⚠️ Dependencies
- **11-router-v1-endpoints** — `$api` (SupabaseClient) is available globally in templates because `index.php` instantiates it before `include_once`.
- **08-models-layer** — templates call Models directly: `$agent = (new AgentModel($api))->resolve($_GET['agent_id']);`.

## 📋 Procedure

1. **Create `home.php`** at project root — Code Vault §1. Agent landing page. Reads `$_GET['agent_id']`, resolves via `AgentModel`, 404s on null.
2. **Create `review.php`** at project root — Code Vault §2. Per-agent review list. Uses `$parts[0]` for the agent_id (the router sets `$_GET['agent_id']` to `"{uuid}/review"` — see the known bug flagged in the snapshot and the fix below).
3. **Create `404.php`** — Code Vault §3.
4. **Create `template/header.php` + `template/footer.php`** (optional but recommended).
5. **Every dynamic value passes through `out()`** — XSS discipline. Code Vault §4.
6. **No Profile Image fallback** — every `<img>` has a fallback block. Code Vault §5.

## 📦 Code Vault

### §1. `home.php` — agent landing page
```php
<?php
/**
 * Agent landing page.
 * URL: /agents/{uuid}
 * $_GET['agent_id'] is set by router.php's {agent_id} capture.
 */

use Sovereign\Models\AgentModel;

// $api is already instantiated in index.php — available here

$id    = $_GET['agent_id'] ?? '';
$model = new AgentModel($api);
$agent = $model->resolve($id);

if (!$agent) {
    http_response_code(404);
    include __DIR__ . '/404.php';
    exit;
}
?><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
  <title><?php out($agent['name']); ?> — <?php out($agent['company']); ?></title>
  <meta name="description" content="<?php out($agent['description']); ?>">
  <link rel="stylesheet" href="/css/app.css">
</head>
<body>

<?php include __DIR__ . '/template/header.php'; ?>

<main class="agent-profile">
  <section class="hero">
    <?php if (!empty($agent['photo'])): ?>
      <img class="hero-photo" src="<?php out($agent['photo']); ?>" alt="<?php out($agent['name']); ?>">
    <?php else: ?>
      <div class="personal-image-placeholder" aria-label="No profile image">
        <span class="material-symbols-outlined">person</span>
      </div>
    <?php endif; ?>

    <h1 class="hero-name"><?php out($agent['name']); ?></h1>
    <p class="hero-title"><?php out($agent['title']); ?></p>
    <p class="hero-company"><?php out($agent['company']); ?></p>
  </section>

  <?php if (!empty($agent['description'])): ?>
  <section class="about">
    <h2>About</h2>
    <p><?php out($agent['description']); ?></p>
  </section>
  <?php endif; ?>

  <?php if (!empty($agent['skills']) && is_array($agent['skills'])): ?>
  <section class="skills">
    <h2>Expertise</h2>
    <ul>
      <?php foreach ($agent['skills'] as $skill): ?>
        <li><?php out(is_array($skill) ? ($skill['label'] ?? '') : $skill); ?></li>
      <?php endforeach; ?>
    </ul>
  </section>
  <?php endif; ?>

  <?php if (!empty($agent['reviews'])): ?>
  <section class="reviews-preview">
    <h2>What clients say (<?= count($agent['reviews']) ?>)</h2>
    <?php foreach (array_slice($agent['reviews'], 0, 3) as $r): ?>
      <blockquote>
        <p><?php out($r['text']); ?></p>
        <cite>— <?php out($r['name']); ?>, <?php out($r['date']); ?></cite>
      </blockquote>
    <?php endforeach; ?>
    <a href="/agents/<?php out($agent['id']); ?>/review">See all reviews →</a>
  </section>
  <?php endif; ?>

  <!-- Lead capture form (anon INSERT via POST /api/v1/leads.php) -->
  <section class="lead-form">
    <h2>Contact <?php out(explode(' ', $agent['name'])[0]); ?></h2>
    <form id="leadForm" data-agent-id="<?php out($agent['id']); ?>">
      <input type="text"   name="name"    placeholder="Your name"    required>
      <input type="email"  name="email"   placeholder="Email">
      <input type="tel"    name="phone"   placeholder="Phone">
      <textarea            name="message" placeholder="How can I help?"></textarea>
      <button type="submit">Send</button>
      <p class="form-status" role="status"></p>
    </form>
  </section>
</main>

<?php include __DIR__ . '/template/footer.php'; ?>

<script src="/js/lead-form.js"></script>
</body>
</html>
```

### §2. `review.php` — all reviews for an agent
```php
<?php
use Sovereign\Models\AgentModel;

// ⚠️ Router sets $_GET['agent_id'] to "{uuid}/review" for this route
// (capture-everything-after-prefix semantics). Strip the trailing segment.
$raw   = $_GET['agent_id'] ?? '';
$parts = explode('/', rtrim($raw, '/'));
$id    = $parts[0] ?? '';

$model = new AgentModel($api);
$agent = $model->resolve($id);

if (!$agent) {
    http_response_code(404);
    include __DIR__ . '/404.php';
    exit;
}
?><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
  <title>Reviews — <?php out($agent['name']); ?></title>
  <link rel="stylesheet" href="/css/app.css">
</head>
<body>
<?php include __DIR__ . '/template/header.php'; ?>

<main class="reviews-page">
  <header>
    <a href="/agents/<?php out($agent['id']); ?>">← Back to <?php out($agent['name']); ?></a>
    <h1>All reviews (<?= count($agent['reviews']) ?>)</h1>
  </header>

  <?php if (empty($agent['reviews'])): ?>
    <p class="empty">No reviews yet — be the first.</p>
  <?php else: ?>
    <ul class="review-list">
      <?php foreach ($agent['reviews'] as $r): ?>
        <li class="review">
          <header>
            <?php if (!empty($r['photo'])): ?>
              <img src="<?php out($r['photo']); ?>" alt="<?php out($r['name']); ?>">
            <?php else: ?>
              <div class="personal-image-placeholder" aria-label="No reviewer photo">
                <span class="material-symbols-outlined">person</span>
              </div>
            <?php endif; ?>
            <div>
              <strong><?php out($r['name']); ?></strong>
              <time><?php out($r['date']); ?></time>
              <span class="rating">
                <?php for ($i = 0; $i < $r['rating']; $i++): ?>★<?php endfor; ?>
              </span>
            </div>
          </header>
          <p><?php out($r['text']); ?></p>
        </li>
      <?php endforeach; ?>
    </ul>
  <?php endif; ?>
</main>

<?php include __DIR__ . '/template/footer.php'; ?>
</body>
</html>
```

### §3. `404.php` — branded not-found
```php
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
  <title>Not found</title>
  <link rel="stylesheet" href="/css/app.css">
</head>
<body class="error-page">
  <main>
    <h1>404</h1>
    <p>That page doesn't exist.</p>
    <a href="/">← Back home</a>
  </main>
</body>
</html>
```

### §4. `out()` discipline — the XSS gate
```php
<!-- RIGHT -->
<h1><?php out($agent['name']); ?></h1>
<a href="/agents/<?php out($agent['id']); ?>">link</a>
<p title="<?php out($agent['tagline']); ?>">hover me</p>

<!-- WRONG — raw interpolation, XSS vulnerable -->
<h1><?= $agent['name'] ?></h1>
<?php echo $agent['description']; ?>
```

### §5. "No Profile Image" CSS fallback
```css
/* css/app.css — add once, applies everywhere */
.personal-image-placeholder {
  aspect-ratio: 1 / 1;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #e5e7eb;   /* gray-200 */
  color: #6b7280;        /* gray-500 */
  border-radius: 50%;
  font-size: 2rem;
  position: relative;
}
.personal-image-placeholder::after {
  content: "no image";
  font-size: 0.625rem;   /* 10px */
  letter-spacing: 0.15em;
  text-transform: uppercase;
  font-weight: 500;
  position: absolute;
  bottom: -1.25rem;
  opacity: 0.6;
}
```

### §6. Lead-form submit — vanilla JS
```js
// js/lead-form.js
(() => {
  const form = document.getElementById('leadForm');
  if (!form) return;
  const status = form.querySelector('.form-status');

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    status.textContent = 'Sending…';

    const payload = {
      agent_profile_id: form.dataset.agentId,
      name:    form.name.value.trim(),
      email:   form.email.value.trim() || null,
      phone:   form.phone.value.trim() || null,
      message: form.message.value.trim() || null,
    };

    try {
      const res = await fetch('/api/v1/leads.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body:    JSON.stringify(payload),
      });
      const json = await res.json();
      if (json.success) {
        status.textContent = 'Thanks — we will be in touch.';
        form.reset();
      } else {
        status.textContent = json.error?.message ?? 'Failed to submit.';
      }
    } catch {
      status.textContent = 'Network error — please try again.';
    }
  });
})();
```

## 🛡️ Guardrails

- **`out()` every dynamic value** — the XSS gate. No raw `<?= $var ?>`, no unescaped `echo`. Grep for `<?= ` as a regression check.
- **Viewport=412** (same rule as frontend Step 01) — phone browsers must match Chrome DevTools F12 simulation.
- **No Profile Image fallback** — every `<img>` wrapped in `<?php if (!empty($row['photo'])): ?>…<?php else: ?><div class="personal-image-placeholder">…</div><?php endif; ?>`. Broken image icons are never acceptable.
- **404 via `http_response_code(404)` + include** — not `header('Location: /404')`. Redirecting a 404 is a SEO mistake.
- **`$api` is global via `index.php`** — templates use it directly. Don't re-instantiate `SupabaseClient` in the template.
- **Review.php's `$parts[0]` quirk** — the router's `{agent_id}` capture grabs everything after `/agents/`, so `/agents/<uuid>/review` produces `$_GET['agent_id'] = "<uuid>/review"`. Strip the trailing segment; don't try to fix the router.
- **Templates call Models, not SovereignQuery directly** — if a template has `$api->from('...')->select(...)`, move it into a Model.
- **Iterate JSONB arrays defensively** — `if (!empty($agent['skills']) && is_array($agent['skills']))`. Seeded JSONB can be null, string, or array.
- **Forms post to `/api/v1/*.php`** — never to the template itself. Separation: PHP templates render, JSON endpoints mutate.
- **Include `template/header.php` + `footer.php`** — avoid copy-pasting `<head>` + nav across pages.

## ✅ Verify

```bash
# 1. PHP parse
php -l home.php
php -l review.php
php -l 404.php

# 2. Render a seeded agent
php -S localhost:8080 -t .
# In another terminal:
curl -s "http://localhost:8080/agents/<uuid>" | grep -o '<title>.*</title>'
# Expected: <title>John Tan — LAA</title>

# 3. XSS smoke — seed a title with <script>, confirm it's escaped
psql "$DATABASE_URL" -c "UPDATE \"quizLaa\".\"agent_profiles\" SET title='<script>alert(1)</script>' WHERE slug='john-agent';"
curl -s "http://localhost:8080/agents/<uuid>" | grep -c '&lt;script&gt;'
# Expected: >= 1 (escaped) — if 0, out() is being bypassed somewhere

# 4. Non-UUID rejection
curl -s -o /dev/null -w '%{http_code}' "http://localhost:8080/agents/john-agent"
# Expected: 404

# 5. Lead form
curl -s -X POST "http://localhost:8080/api/v1/leads.php" \
  -H "Content-Type: application/json" \
  -d '{"agent_profile_id":"<uuid>","name":"UI Test"}' | jq .success
# Expected: true
```

## ♻️ Rollback
```bash
rm -f home.php review.php 404.php
rm -rf template/
# Router routes are dead targets — every page URL 500s on missing include.
```

## → Next Step
**[13-brain-hardening](../13-brain-hardening/skill.md)** — save architecture summary into `LAA_PROJECT_SNAPSHOT.md` for future sessions.

## Free Visual Asset Fallback

For PHP landing pages or public website templates that need richer visuals but no image-generation tool is available, apply:

`C:\Users\user\.codex\skills\normal\design\FREE_VISUAL_ASSET_SOURCING.md`

Use stock/CDN images, downloaded local assets, Material Symbols, inline SVG, and CSS art as prototype visuals. Keep source/license records and use PHP fallback blocks so missing images never break the page.
