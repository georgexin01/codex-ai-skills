---
name: pwa-favicon-meta-setup
description: "Authoritative recipe for PWA install + favicon + Open Graph + Twitter Card + Apple/Microsoft meta tag wiring. Apply to every wRider-style web app at scaffold time so the install banner, share previews, and home-screen icons all light up on first deploy."
triggers: ["pwa", "favicon", "manifest", "open graph", "og image", "twitter card", "apple touch icon", "theme color", "site.webmanifest", "meta tags"]
phase: 1-scaffold
version: 1.0.0
status: authoritative
date_authored: "2026-05-05"
project: "c:/Users/user/Desktop/wRider"
companion: "./wrider_complete_recipe.md"
---

# 🛡️ PWA + Favicon + Meta — Drop-in Recipe

> **Goal**: any new web app gets installable PWA + crisp favicons across
> Android/iOS/desktop + branded share previews on the **first** commit.
> No second-pass clean-up.

---

## ⚠️ ROBOTS META — PERMANENT RULE: noindex, nofollow ON ALL ENVS

Every website (dev, staging, production) must have `noindex, nofollow` as the global default. Set it in the shared head partial (e.g. `htmlHead.php`, `_head.html`, `layout.vue`):

```html
<meta name="robots" content="noindex, nofollow">
```

**This rule applies to production builds too.** Never auto-switch to `index, follow`.
Only change when the user explicitly instructs: *"enable SEO indexing"* / *"set to index, follow"*.
AI must treat this as a user-gated setting — not something changed automatically during any build or deploy task.

---

## 0 · The 7-file favicon set (drop into `public/`)

| File | Size | Purpose |
|---|---|---|
| `favicon.ico` | multi-res | Legacy browser tab + Windows pinned site |
| `favicon.svg` | scalable | Modern desktop + dark-mode aware (recommended) |
| `favicon-96x96.png` | 96×96 | Android Chrome tab + bookmark fallback |
| `apple-touch-icon.png` | 180×180 | iOS home-screen icon (rounded automatically by iOS) |
| `web-app-manifest-192x192.png` | 192×192 | Android home-screen + splash (PWA) |
| `web-app-manifest-512x512.png` | 512×512 | Android splash, app drawer, share preview |
| `site.webmanifest` | JSON | PWA install metadata |

**Generation source**: <https://realfavicongenerator.net> with the brand SVG.

**Maskable icon rule**: 192/512 PNGs MUST have a safe-zone — keep all
visible glyphs inside the **inner 80%** circle. Anything beyond gets
chopped on Android adaptive icons.

---

## 1 · `<head>` meta tag suite — copy-paste template

Use this verbatim in every new app. Replace four placeholders:
`{{TITLE}}`, `{{DESC}}`, `{{SITE_NAME}}`, `{{LOCALE}}`
(e.g. `en_MY`, `en_US`).

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />

    <title>{{TITLE}}</title>
    <meta name="description" content="{{DESC}}" />

    <!-- Favicons -->
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <link rel="icon" type="image/png" sizes="96x96" href="/favicon-96x96.png" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />

    <!-- PWA -->
    <link rel="manifest" href="/site.webmanifest" />
    <meta name="theme-color" content="#8c3df4" />
    <meta name="application-name" content="{{SITE_NAME}}" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="default" />
    <meta name="apple-mobile-web-app-title" content="{{SITE_NAME}}" />
    <meta name="msapplication-TileColor" content="#8c3df4" />
    <meta name="msapplication-config" content="none" />
    <meta name="format-detection" content="telephone=no" />

    <!-- Open Graph -->
    <meta property="og:type" content="website" />
    <meta property="og:site_name" content="{{SITE_NAME}}" />
    <meta property="og:title" content="{{TITLE}}" />
    <meta property="og:description" content="{{DESC}}" />
    <meta property="og:image" content="/web-app-manifest-512x512.png" />
    <meta property="og:locale" content="{{LOCALE}}" />

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="{{TITLE}}" />
    <meta name="twitter:description" content="{{DESC}}" />
    <meta name="twitter:image" content="/web-app-manifest-512x512.png" />
  </head>
  …
</html>
```

### Why each block

| Block | Why it exists |
|---|---|
| `viewport width=device-width` | **Corrected 2026-05-05.** Earlier guidance hardcoded `width=412` to match DevTools S20 Ultra simulation, but real-world phones (CSS width 360–390) overflow the right edge under that rule. `device-width` adapts to every device. See `design/app/03-config-hardening/skill.md` for the full rationale. |
| Multi-format favicon | SVG for crisp modern, PNG-96 for Android tabs, ICO for Windows pinned, apple-touch for iOS home. |
| `theme-color #8c3df4` | Brand violet — colors Android URL bar + iOS notch + PWA splash chrome. **MUST match** `theme_color` in `site.webmanifest`. |
| `apple-mobile-web-app-*` | Enables iOS "Add to Home Screen" full-screen mode + branded standalone title. |
| `msapplication-TileColor` | Windows pinned-site tile background — mirror to brand color. |
| `format-detection telephone=no` | Stops iOS Safari auto-linking phone-number-shaped digits in dispatch/admin UIs. |
| OG tags | Slack/WhatsApp/iMessage/FB share previews. The 512 PNG works for `summary` cards. |
| Twitter `summary` (not `summary_large_image`) | 512 square asset is square-friendly; large-image cards demand 1200×630 which we don't ship in the favicon set. Upgrade only when a marketing 1200×630 OG image exists. |

---

## 2 · `site.webmanifest` schema — wRider canonical

```json
{
  "name": "{{FULL_NAME}}",
  "short_name": "{{HOME_SCREEN_LABEL}}",
  "description": "{{DESC}}",
  "id": "/?source=pwa",
  "start_url": "/?source=pwa",
  "scope": "/",
  "display": "standalone",
  "orientation": "portrait-primary",
  "lang": "en-MY",
  "dir": "ltr",
  "theme_color": "#8c3df4",
  "background_color": "#fbfbfb",
  "categories": ["business", "logistics", "productivity"],
  "icons": [
    { "src": "/web-app-manifest-192x192.png", "sizes": "192x192", "type": "image/png", "purpose": "maskable any" },
    { "src": "/web-app-manifest-512x512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable any" },
    { "src": "/favicon.svg", "sizes": "any", "type": "image/svg+xml", "purpose": "any" }
  ],
  "shortcuts": [
    {
      "name": "{{LONG_LABEL}}",
      "short_name": "{{SHORT_LABEL}}",
      "description": "{{ONE_LINER}}",
      "url": "/{{ROUTE}}?source=pwa-shortcut",
      "icons": [{ "src": "/web-app-manifest-192x192.png", "sizes": "192x192" }]
    }
  ]
}
```

### Field-by-field rationale

| Field | Rule |
|---|---|
| `name` vs `short_name` | `name` shows in install dialog ("wRider Admin Console"); `short_name` shows under home-screen icon (max ~12 chars: "wRider Admin"). |
| `id` & `start_url` | Both include `?source=pwa` so analytics can split installed-app traffic from web traffic. `id` is the PWA identity primary key — keep it stable forever. |
| `scope: "/"` | App owns the whole origin. Children pages stay inside the standalone shell. |
| `display: "standalone"` | No browser chrome — feels native. Avoid `fullscreen` (loses status bar) unless game/video. |
| `orientation: "portrait-primary"` | Matches the 412px viewport contract. |
| `theme_color` | **Must match** the `<meta name="theme-color">` exactly. |
| `background_color` | Splash background while JS boots. Keep paper `#fbfbfb` so first paint is not black. |
| `categories` | Used by Android app library & Chrome Web Store. Pick from the [W3C manifest categories list](https://github.com/w3c/manifest/wiki/Categories). |
| `icons` `purpose: "maskable any"` | One asset serves both the masked adaptive icon AND the legacy "any" purpose — saves shipping two PNGs. Requires 80% safe-zone art. |
| `shortcuts` | Long-press the home-screen icon → quick deep-links. Cap at **3** (Android shows max 4, the launcher counts as 1). |

### Per-app shortcut menus (wRider canon)

**Admin** — `/jobs/new`, `/map`, `/payroll`
**Driver** — `/` (missions), `/map`, `/wallet`

Each shortcut URL appends `?source=pwa-shortcut` so analytics can attribute usage.

---

## 3 · Theme-color strategy

Three places must agree on the brand color, otherwise Android URL bar
flickers between violet and white during navigation:

1. `<meta name="theme-color" content="#8c3df4" />` in `index.html`
2. `theme_color: "#8c3df4"` in `site.webmanifest`
3. (Optional) iOS status bar via `apple-mobile-web-app-status-bar-style`
   — `default` (white text on brand) / `black-translucent` (overlay).

> ⚠️ The user's brand violet is `#8c3df4`. Background paper is `#fbfbfb`.
> Never substitute a different shade without explicit instruction.

---

## 4 · Maskable icon design rules

1. **Safe zone**: keep visible glyph within the inner 80% of the canvas
   (radius = 40% of the side). Android masks adaptive icons into circles,
   squircles, rounded rects — anything outside the safe zone may be cut.
2. **No transparency in the safe zone** — fill it with the brand
   background color so the masked shape always has a solid backplate.
3. **Same source for 192 + 512** — render the 512 first, downscale
   bicubic to 192. Keeps line weights coherent across sizes.

---

## 5 · Verification checklist

After wiring, verify in this order:

1. **`vite build`** — ensure the manifest passes JSON validation.
2. **Chrome DevTools → Application → Manifest** — should list:
   icons (3), shortcuts (3), no warnings.
3. **Lighthouse → PWA audit** — must hit "Installable" green.
4. **Chrome address bar install prompt** — three-dot menu shows
   "Install {{SHORT_NAME}}".
5. **Mobile share test** — paste deployed URL into WhatsApp/Slack;
   preview shows brand image + title + description.
6. **iOS home screen** — Safari Share → Add to Home Screen → label is
   `apple-mobile-web-app-title`, icon is `apple-touch-icon.png`.

---

## 6 · Common mistakes (and the fix)

| Mistake | Symptom | Fix |
|---|---|---|
| Missing `apple-touch-icon.png` | iOS home-screen shows blurry screenshot of page | Drop a 180×180 PNG and link it. |
| `theme-color` ≠ manifest `theme_color` | Android URL bar flickers on navigation | Sync both to one constant. |
| `purpose: "any"` only on PNG | Adaptive icon on Android shows white halo | Change to `purpose: "maskable any"` and respect 80% safe zone. |
| `start_url: "/"` without `?source=pwa` | Cannot distinguish PWA vs browser traffic in analytics | Append the `?source=pwa` query. |
| Icons not in `public/` | 404 on `/web-app-manifest-512x512.png` after build | Vite/CRA both serve `public/` at root — drop files there, not in `src/assets/`. |
| `viewport width=412` (or any hardcoded number) | Right edge clips on every phone whose CSS width ≠ 412 — header gradient, footer tabs, status badges all truncate | Use `width=device-width` (the safety viewport). The old 412 rule is deprecated. |
| `maximum-scale=1.0` + `user-scalable=no` | Pinch-zoom blocked, WCAG 1.4.4 failure | Remove both — fix font-size ≥16px on inputs instead if you were using them to suppress iOS zoom-on-focus. |
| Twitter `summary_large_image` with 512 sq | Card crops weirdly in Twitter | Use `summary` until a 1200×630 OG image exists. |
| `display: "browser"` | Install button never appears in Chrome | Use `standalone` (or `minimal-ui`). |
| 4+ shortcuts | Overflow gets dropped on Android | Cap at 3. |

---

## 7 · How to apply on a fresh wRider-style project

```
1. realfavicongenerator.net → upload brand SVG → download zip
2. Extract 7 files into webApp-{name}/public/
3. Replace site.webmanifest with the canonical schema (§2 above)
4. Replace index.html <head> with the meta suite (§1 above)
5. Fill the four placeholders {{TITLE}} {{DESC}} {{SITE_NAME}} {{LOCALE}}
6. npm run build → confirm dist/ contains all 7 favicon files at root
7. Run the §5 verification checklist
```

Total time: ~6 minutes for a clean app.

---

## 🔗 Companion files

- [`wrider_complete_recipe.md`](./wrider_complete_recipe.md) — full
  rebuild manifest; this PWA setup is referenced from §1 (design tokens)
  and §11 (CI rules).
- [`wrider_design_senses.md`](./wrider_design_senses.md) — aesthetic
  senses (theme color, weight, smoothing) that the meta tags inherit.
- [`wrider_chat_mining.md`](./wrider_chat_mining.md) — protocol for
  evolving these standards from observed user edits.
- [`../../../Desktop/wRider/BLUEPRINT.md`](../../../Desktop/wRider/BLUEPRINT.md)
  — architectural manifest; §14 KNOWLEDGE TREE references this file.

---

**Authored:** 2026-05-05 · v1.0.0
