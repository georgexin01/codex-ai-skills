---
name: website-14-seo-structured-data
description: "Step 14 — SEO structured data: create lib/schema.php with JSON-LD (modern) + explain Schema Meta old version (HTML Microdata). Auto-generates WebSite, LocalBusiness, Person, BreadcrumbList, WebPage, BlogPosting per page. Single include in htmlHead.php."
triggers: ["json-ld", "schema.org", "structured data", "seo schema", "ld+json", "schema meta", "microdata", "rich results", "breadcrumb schema", "local business schema"]
phase: 3-seo
requires: [website-11-router-v1-endpoints]
unlocks: []
output_format: php_file
version: 1.0
status: authoritative
reference_project: website-angel-interior
last_updated: "2026-06-02"
---

# Step 14 — SEO Structured Data (JSON-LD + Schema Meta)

## 🎯 When to Use
After the router and templates are wired (Step 11+). Run this step on every new Sovereign PHP website to install Google-readable structured data that powers rich results, business panels, and breadcrumbs in search.

Run it as one of the final steps before handoff or before going live.

## 🤝 Cooperation Note

This step handles **structured data / JSON-LD**, not the admin SEO settings table.

If the user asks for:
- SEO tables
- SEO settings CRUD in admin
- auto-generated page meta rows

first consult:
- [`../../claude/seo-tables-planner/skill.md`](../../claude/seo-tables-planner/skill.md)

Then use this step only for the website-side structured-data layer after the SEO storage plan is defined.

---

## 📖 Concept Reference

### What is JSON-LD?
`<script type="application/ld+json">` — a JSON block placed in `<head>` that tells Google, Bing, and other search engines exactly what your page, business, and content are. **Google's #1 recommended format.** Does not touch your HTML markup at all.

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "My Business",
  "address": { "@type": "PostalAddress", "addressLocality": "Toronto" }
}
</script>
```

### What is Schema Meta (old version / HTML Microdata)?
The legacy approach — `itemscope`, `itemtype`, `itemprop` attributes added directly to HTML tags. Still valid but hard to maintain and mixes structure into markup. JSON-LD replaced it.

```html
<!-- OLD way — HTML Microdata -->
<div itemscope itemtype="https://schema.org/LocalBusiness">
  <span itemprop="name">My Business</span>
  <span itemprop="addressLocality">Toronto</span>
</div>
```

**Decision rule:** Always use JSON-LD (in `lib/schema.php`). Never add microdata attributes to templates. They produce the same SEO result but JSON-LD is cleaner, easier to update, and isolated from UI.

---

## 📋 Procedure

1. **Research the project** — read `lib/initData.php`, `lib/htmlHead.php`, `index.php` (route map), and all `template/*.php` files. Note every route, `$pageName` value, and available data variables (e.g. `$post`, `$routeCategory`).
2. **Gather business facts** — name, address city/region/country, email, phone, social URLs, logo path, services. Pull from `initData.php` / `api/core/.env` / site content.
3. **Create `lib/schema.php`** — Code Vault §1. Central file. Outputs one `<script type="application/ld+json">` block per schema.
4. **Replace old JSON-LD in `lib/htmlHead.php`** — Code Vault §2. Remove any existing `<script type="application/ld+json">` block and replace with a single `<?php include __DIR__ . '/schema.php'; ?>`.
5. **Verify** — Code Vault §3. Check each page type outputs the right number of blocks and valid JSON.

---

## 📦 Code Vault

### §1. `lib/schema.php` — complete template

> **Adapt every `$_sd_*` constant** to the project. Replace business name, address, social URLs, etc. Also adapt the page-type detection `if/elseif` chain to match the project's actual `$pageName` values from `initData.php`.

```php
<?php
/**
 * Sovereign SEO — Structured Data (JSON-LD)
 * One file generates all schema.org blocks for every page.
 * Include from lib/htmlHead.php AFTER initData.php has run.
 *
 * Outputs <script type="application/ld+json"> blocks only.
 * No HTML microdata — JSON-LD is the modern standard.
 */

// ── Shared constants (ADAPT THESE per project) ──────────────────────────────
$_sd_base        = $siteBase ?? ('https://' . ($_SERVER['HTTP_HOST'] ?? 'example.com'));
$_sd_pageUrl     = $pageUrl  ?? ($_sd_base . ($_SERVER['REQUEST_URI'] ?? '/'));
$_sd_name        = 'BUSINESS NAME';                     // ← change
$_sd_designer    = 'OWNER NAME';                        // ← change
$_sd_tagline     = 'SHORT TAGLINE';                     // ← change
$_sd_description = 'FULL META DESCRIPTION';             // ← change
$_sd_logo        = $_sd_base . '/favicon/web-app-manifest-512x512.png'; // ← change path if needed
$_sd_instagram   = $instagramUrl ?? 'https://www.instagram.com/handle'; // ← change
$_sd_tiktok      = $tiktokUrl    ?? 'https://www.tiktok.com/@handle';   // ← change if applicable
$_sd_email       = $ctemail      ?? 'hello@example.com';                // ← change
$_sd_phone       = $ctcontact    ?? '+1 (000) 000-0000';                // ← change
$_sd_city        = 'CITY';                              // ← change
$_sd_region      = 'REGION';                            // ← change (e.g. ON, KL)
$_sd_country     = 'CA';                                // ← change ISO 2-letter
$_sd_lat         = '0.000000';                          // ← change geo coords
$_sd_lng         = '0.000000';                          // ← change geo coords
$_sd_services    = [                                    // ← change per business
    'Service One',
    'Service Two',
];
$_sd_page        = strtolower($pageName ?? 'home');

// ── 1. WebSite ───────────────────────────────────────────────────────────────
$_sd_website = [
    '@context'      => 'https://schema.org',
    '@type'         => 'WebSite',
    '@id'           => $_sd_base . '/#website',
    'name'          => $_sd_name,
    'alternateName' => $_sd_designer,
    'description'   => $_sd_tagline,
    'url'           => $_sd_base . '/',
    'inLanguage'    => 'en-CA',
    'publisher'     => ['@id' => $_sd_base . '/#organization'],
];

// ── 2. LocalBusiness / Organization ─────────────────────────────────────────
$_sd_org = [
    '@context'      => 'https://schema.org',
    '@type'         => ['LocalBusiness', 'ProfessionalService'],
    '@id'           => $_sd_base . '/#organization',
    'name'          => $_sd_name,
    'alternateName' => $_sd_designer,
    'description'   => $_sd_description,
    'url'           => $_sd_base . '/',
    'logo'          => [
        '@type'  => 'ImageObject',
        'url'    => $_sd_logo,
        'width'  => 512,
        'height' => 512,
    ],
    'image'         => $_sd_logo,
    'email'         => $_sd_email,
    'telephone'     => $_sd_phone,
    'address'       => [
        '@type'           => 'PostalAddress',
        'addressLocality' => $_sd_city,
        'addressRegion'   => $_sd_region,
        'addressCountry'  => $_sd_country,
    ],
    'geo'           => [
        '@type'     => 'GeoCoordinates',
        'latitude'  => $_sd_lat,
        'longitude' => $_sd_lng,
    ],
    'areaServed'    => [
        ['@type' => 'City',                'name' => $_sd_city],
        ['@type' => 'AdministrativeArea',  'name' => $_sd_region],
        ['@type' => 'Country',             'name' => $_sd_country],
    ],
    'priceRange'         => '$$',
    'currenciesAccepted' => 'CAD',
    'openingHours'       => 'Mo-Fr 09:00-18:00',
    'serviceType'        => $_sd_services,
    'sameAs'             => array_filter([$_sd_instagram, $_sd_tiktok]),
    'founder'            => ['@id' => $_sd_base . '/#person'],
];

// ── 3. Person (owner / author) ───────────────────────────────────────────────
$_sd_person = [
    '@context'   => 'https://schema.org',
    '@type'      => 'Person',
    '@id'        => $_sd_base . '/#person',
    'name'       => $_sd_designer,
    'jobTitle'   => 'Owner',                            // ← change
    'description'=> $_sd_description,
    'url'        => $_sd_base . '/',
    'image'      => $_sd_logo,
    'worksFor'   => ['@id' => $_sd_base . '/#organization'],
    'address'    => [
        '@type'           => 'PostalAddress',
        'addressLocality' => $_sd_city,
        'addressRegion'   => $_sd_region,
        'addressCountry'  => $_sd_country,
    ],
    'sameAs'     => array_filter([$_sd_instagram, $_sd_tiktok]),
];

// ── 4. BreadcrumbList — adapts per page ──────────────────────────────────────
// Add one elseif per route in index.php. Match exact $pageName values.
$_sd_bc = [['@type' => 'ListItem', 'position' => 1, 'name' => 'Home', 'item' => $_sd_base . '/']];

if ($_sd_page === 'about us') {
    $_sd_bc[] = ['@type' => 'ListItem', 'position' => 2, 'name' => 'About', 'item' => $_sd_base . '/about'];
} elseif ($_sd_page === 'blog') {
    $_sd_bc[] = ['@type' => 'ListItem', 'position' => 2, 'name' => 'Blog', 'item' => $_sd_base . '/blogs'];
} elseif ($_sd_page === 'contact') {
    $_sd_bc[] = ['@type' => 'ListItem', 'position' => 2, 'name' => 'Contact', 'item' => $_sd_base . '/contact'];
} elseif (isset($post) && !empty($post['title'])) {
    // Blog detail — 3 levels: Home › Blog › Post Title
    $_sd_bc[] = ['@type' => 'ListItem', 'position' => 2, 'name' => 'Blog', 'item' => $_sd_base . '/blogs'];
    $_sd_bc[] = ['@type' => 'ListItem', 'position' => 3, 'name' => $post['title'], 'item' => $_sd_pageUrl];
}
// ADD MORE elseif BLOCKS here as the project grows new routes.

$_sd_breadcrumb = [
    '@context'        => 'https://schema.org',
    '@type'           => 'BreadcrumbList',
    'itemListElement' => $_sd_bc,
];

// ── 5. WebPage — type changes per page ───────────────────────────────────────
$_sd_wpt = 'WebPage';
if ($_sd_page === 'about us')                       $_sd_wpt = 'AboutPage';
elseif ($_sd_page === 'contact')                    $_sd_wpt = 'ContactPage';
elseif (isset($post) && !empty($post['title']))     $_sd_wpt = 'Article';

$_sd_webpage = [
    '@context'    => 'https://schema.org',
    '@type'       => $_sd_wpt,
    '@id'         => $_sd_pageUrl . '#webpage',
    'url'         => $_sd_pageUrl,
    'name'        => $metaTitle ?? $_sd_name,
    'description' => $metaDescription ?? $_sd_description,
    'inLanguage'  => 'en-CA',
    'isPartOf'    => ['@id' => $_sd_base . '/#website'],
    'about'       => ['@id' => $_sd_base . '/#organization'],
    'breadcrumb'  => ['@id' => $_sd_pageUrl . '#breadcrumb'],
];

// ── 6. BlogPosting — blog detail only ────────────────────────────────────────
// $post must be set by blog-details.php before htmlHead.php is included.
$_sd_blog = null;
if (isset($post) && !empty($post['title'])) {
    $_sd_blog = [
        '@context'         => 'https://schema.org',
        '@type'            => 'BlogPosting',
        '@id'              => $_sd_pageUrl . '#article',
        'mainEntityOfPage' => ['@id' => $_sd_pageUrl . '#webpage'],
        'headline'         => $post['title'],
        'description'      => $post['excerpt'] ?? '',
        'image'            => !empty($post['hero']) ? $post['hero'] : $_sd_logo,
        'author'           => ['@id' => $_sd_base . '/#person'],
        'publisher'        => ['@id' => $_sd_base . '/#organization'],
        'datePublished'    => $post['published_at'] ?? ($post['created_at'] ?? ''),
        'dateModified'     => $post['updated_at']   ?? ($post['published_at'] ?? ($post['created_at'] ?? '')),
        'inLanguage'       => 'en-CA',
        'url'              => $_sd_pageUrl,
    ];
}

// ── Output all schemas ────────────────────────────────────────────────────────
foreach (array_filter([$_sd_website, $_sd_org, $_sd_person, $_sd_breadcrumb, $_sd_webpage, $_sd_blog]) as $_sd_s) {
    echo '<script type="application/ld+json">' . "\n";
    echo json_encode($_sd_s, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP);
    echo "\n</script>\n";
}
unset($_sd_website, $_sd_org, $_sd_person, $_sd_breadcrumb, $_sd_webpage, $_sd_blog, $_sd_bc, $_sd_s, $_sd_wpt, $_sd_page);
```

---

### §2. `lib/htmlHead.php` — replace old JSON-LD block

Find any existing `<script type="application/ld+json">...</script>` block and replace the entire thing with one line:

```php
<!-- JSON-LD Structured Data (schema.org) -->
<?php include __DIR__ . '/schema.php'; ?>
```

Place it **after** all `<meta>` tags and **before** the CSS `<link>` tags.

If no JSON-LD exists yet, add the include at the same position.

---

### §3. Verification — per page type

```bash
# Start PHP server
php -S 127.0.0.1:8000 index.php

# Count ld+json blocks per page (expect 5 on most pages, 6 on blog detail)
curl -s http://127.0.0.1:8000/         | grep -o 'application/ld+json' | wc -l
curl -s http://127.0.0.1:8000/about    | grep -o 'application/ld+json' | wc -l
curl -s http://127.0.0.1:8000/blogs    | grep -o 'application/ld+json' | wc -l
curl -s http://127.0.0.1:8000/contact  | grep -o 'application/ld+json' | wc -l
curl -s "http://127.0.0.1:8000/blogs/{real-slug}" | grep -o 'application/ld+json' | wc -l

# Expected counts:
# / about blogs contact    → 5 blocks (WebSite, LocalBusiness, Person, BreadcrumbList, WebPage)
# /blogs/{slug}            → 6 blocks (+ BlogPosting)

# Validate JSON is well-formed (no PHP parse errors leaking into output)
curl -s http://127.0.0.1:8000/ | grep -A 50 'application/ld+json' | head -60

# Validate with Google (after site goes live):
# https://search.google.com/test/rich-results
# https://validator.schema.org/
```

---

### §4. Schema block summary — what each block does

| Block | Type | Pages | Google Rich Result |
|---|---|---|---|
| WebSite | `WebSite` | All | Site name in Knowledge Panel, Sitelinks |
| LocalBusiness | `LocalBusiness` + `ProfessionalService` | All | Business Panel (address, phone, hours) |
| Person | `Person` | All | Author card, entity disambiguation |
| BreadcrumbList | `BreadcrumbList` | All | `Home › Blog › Post Title` under search result URL |
| WebPage | `WebPage` / `AboutPage` / `ContactPage` / `Article` | All | Page type signal |
| BlogPosting | `BlogPosting` | Blog detail only | Article rich result with date + author |

---

### §5. What Schema Meta (old version / Microdata) looks like — reference only

> **Do NOT implement this.** Shown here for reference so you understand what the "old way" was. Use JSON-LD (§1) instead.

```html
<!-- OLD — HTML Microdata (do not use) -->
<div itemscope itemtype="https://schema.org/LocalBusiness">
  <span itemprop="name">Angel Interior Design</span>
  <div itemprop="address" itemscope itemtype="https://schema.org/PostalAddress">
    <span itemprop="addressLocality">Toronto</span>
    <span itemprop="addressRegion">ON</span>
    <span itemprop="addressCountry">CA</span>
  </div>
  <span itemprop="telephone">+1 (416) 000-0000</span>
  <a itemprop="url" href="https://example.com">Website</a>
</div>
```

Why it was replaced:
- Mixes data into presentation HTML — hard to maintain
- Requires changing every template file when data changes
- JSON-LD is a single block, isolated from markup, easier to update
- Google treats both identically — JSON-LD wins on maintainability

---

## 🛡️ Guardrails

- **Research all `$pageName` values first** before writing the BreadcrumbList chain. A mismatch (e.g. `'about'` vs `'about us'`) silently skips the breadcrumb level.
- **`$post` must be set before `htmlHead.php` runs** for BlogPosting to fire. In `blog-details.php`, `$post` must be fetched and `$pageName = $post['title']` set before `include('lib/htmlHead.php')`.
- **`$siteBase` must not have trailing slash** — the `#website`, `#organization`, `#person` IDs are concatenated directly.
- **Do not hardcode `http://` in schema** — always use `$siteBase` which is auto-detected from `$_SERVER['HTTPS']`.
- **`JSON_HEX_TAG | JSON_HEX_AMP` are mandatory** on `json_encode` — prevents XSS if any data value contains `<script>` or `&`.
- **Clean up temp variables** — unset all `$_sd_*` at the end of schema.php to avoid polluting the template's variable scope.
- **One include, not per-template** — never copy schema blocks into individual templates. All logic lives in `lib/schema.php`.

## ✅ Done when

- [ ] `lib/schema.php` created with correct business info
- [ ] `lib/htmlHead.php` has `<?php include __DIR__ . '/schema.php'; ?>` replacing old JSON-LD
- [ ] Homepage returns 5 `ld+json` blocks with `200 OK`
- [ ] Blog detail returns 6 `ld+json` blocks, BlogPosting has real headline + image
- [ ] BreadcrumbList on inner pages has correct `position` + `item` URLs
- [ ] `php -l lib/schema.php` passes with no errors

## → Reference Project
`website-angel-interior` — see `lib/schema.php` for the live implementation.
Installed 2026-06-02. Verified all pages return correct blocks.

## → Next Step
Go live / deploy. After deploy, submit to Google Search Console and test at `https://search.google.com/test/rich-results`.
