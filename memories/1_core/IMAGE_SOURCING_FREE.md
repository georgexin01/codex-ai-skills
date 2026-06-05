---
name: image-sourcing-free
description: "Authoritative knowledge file for the free image-sourcing waterfall. When an AI needs images for a website or app and the user has no paid image-gen budget, follow this waterfall: Pollinations.ai (free generation) → Unsplash CDN direct (curated stock) → Lorem Picsum (random placeholder) → Material Symbols / Lucide / Heroicons (icons) → CSS-art / SVG fallback. Includes URL patterns, code examples, license notes, and rate-limit guidance verified 2026-05-11."
type: reference
tier: 1
phase: design
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "codex-gpt-5.3"]
related:
  - "2_governance/sovereign_framework_mastery.md"
  - "0_apex/GROUND_KERNEL.md"
  - "1_core/UI_DNA_MASTER.md"
version: 1.0
date: 2026-05-11
status: authoritative
triggers:
  - "generate images"
  - "create images for project"
  - "image generation"
  - "ai generate images"
  - "free image gen"
  - "property images"
  - "hero image"
  - "placeholder images"
  - "openai billing"
  - "image api key"
  - "替我生成图片"
---

# Free Image Sourcing Waterfall

> **Use this when:** the user asks an AI to "generate images", populate a website/app with photos, fill in missing visuals, or replace placeholder art — and there is no paid budget for OpenAI Images / Midjourney / Imagen.
>
> **Why this exists:** on 2026-05-11 a working `ecoworld` project was blocked by `billing_hard_limit_reached` on OpenAI Images. Pollinations.ai produced production-quality results for free with no API key. This file makes that path reusable across future projects and AI agents (Codex, Gemini, Claude Code).

## 0. Decision tree (read first)

```
User wants images
│
├── For decorative / hero / lifestyle / property / abstract → POLLINATIONS.AI (§1)
│       text → unique generated photo, free, no key
│
├── Need a SPECIFIC real thing (real person, real building, real product) → UNSPLASH CDN (§2)
│       hand-picked photo IDs → real photographer's photo, free, attribution
│
├── Need a generic photo placeholder with no semantic constraint → LOREM PICSUM (§3)
│       random Unsplash photo, free, no curation needed
│
├── Need icons / pictograms / UI symbols → MATERIAL SYMBOLS / LUCIDE / HEROICONS (§4)
│       free, comprehensive, font or SVG
│
└── Truly no internet OR want full control → INLINE SVG / CSS GRADIENT (§5)
        category-coded artwork, zero network dependency
```

---

## 1. Pollinations.ai — free text-to-image generation (recommended primary)

### 1.1 URL pattern (verified 2026-05-11)

```
https://image.pollinations.ai/prompt/{URL_ENCODED_PROMPT}?width=1600&height=900&model=flux&seed=42&nologo=true&private=true
```

- **No API key required** for the public endpoint.
- Plain HTTP GET → returns `image/jpeg`. Just save the response body.
- Verified producing high-quality Malaysian property photos (e.g. Iskandar Puteri terrace homes, Eco Galleria retail plaza at golden hour) at flux model resolution.

### 1.2 Query parameters

| Param | Values | Notes |
|---|---|---|
| `width` / `height` | any integer | Common: 1600×900 (hero), 1024×768 (4:3 card), 1024×1024 (square) |
| `model` | `flux` / `sana` / `turbo` | `flux` = highest quality (recommended). `turbo` = fastest. `sana` = default/legacy. |
| `seed` | integer | Same seed + prompt → reproducible. Vary seed to get variations. |
| `nologo` | `true` | Strip the "Pollinations" watermark — set this for production. |
| `private` | `true` | Don't add image to public feed. |
| `enhance` | `true` / `false` | Auto-enhance prompt — usually leave `false` to keep your prompt verbatim. |

### 1.3 Rate / etiquette

- No documented hard rate limit on the public endpoint, but **be polite**: insert ~500 ms sleep between requests when batch-generating, and set a `User-Agent` header identifying your app.
- For high-volume / production use, the `gen.pollinations.ai` v2 endpoint exists with publishable keys — only switch if you start getting throttled.

### 1.4 PHP example (battle-tested in `ecoworld/scripts/generate-images.php`)

```php
$prompt = 'aerial view of premium Johor Bahru EcoWorld township at Iskandar Puteri, lush tropical garden boulevard, modern double-storey terrace homes with clay-tile roofs, palm-lined avenue, warm Malaysian morning light, cinematic property hero, realistic, no text, no logo';
$url = 'https://image.pollinations.ai/prompt/' . rawurlencode($prompt)
     . '?' . http_build_query([
         'width' => 1600, 'height' => 900,
         'model' => 'flux', 'seed' => 42,
         'nologo' => 'true', 'private' => 'true',
     ]);
$bin = file_get_contents($url, false, stream_context_create([
    'http' => ['timeout' => 180, 'header' => "User-Agent: MyApp-Generator/1.0\r\n"],
]));
file_put_contents('uploads/generated/hero/eco-township.jpg', $bin);
```

### 1.5 PowerShell example (when on Windows)

```powershell
$prompt = 'modern Malaysian house, Johor Bahru, tropical landscaping, golden hour'
$enc = [System.Uri]::EscapeDataString($prompt)
$url = "https://image.pollinations.ai/prompt/${enc}?width=1024&height=768&model=flux&nologo=true&seed=42"
Invoke-WebRequest -Uri $url -OutFile 'uploads/generated/sample.jpg' -TimeoutSec 180 -UseBasicParsing
```

### 1.6 Node example

```js
import fs from 'node:fs/promises';
const prompt = encodeURIComponent('your prompt here');
const url = `https://image.pollinations.ai/prompt/${prompt}?width=1024&height=768&model=flux&nologo=true&seed=42`;
const res = await fetch(url, { headers: { 'User-Agent': 'MyApp/1.0' } });
await fs.writeFile('out.jpg', Buffer.from(await res.arrayBuffer()));
```

### 1.7 Prompt-craft for property / website / app

Property photos respond best to **editorial-real-estate-photography** language. Anchor the prompt with:

- **Locale** ("Johor Bahru / Iskandar Puteri", "Klang Valley", "Penang coastal")
- **Architectural style** ("double-storey terrace home, clay-tile roof", "shop-office row", "high-rise with green podium")
- **Light** ("warm morning light", "golden hour", "blue-sky weekday")
- **Lifestyle** ("families walking", "outdoor dining", "cycling lane")
- **Aesthetic** ("cinematic", "premium editorial property campaign", "clean luxury mood")
- **Negatives** (`no text, no logo` — Pollinations honours these in prompt)
- **Aspect ratio** (`16:9`, `4:3`, `1:1`)

---

## 2. Unsplash CDN — curated stock (no API key for direct URLs)

When you need **a specific real photo** (a known photographer's work, e.g. a particular car model or a real Eco Majestic billboard), hand-pick photo IDs from unsplash.com and use direct CDN URLs:

```
https://images.unsplash.com/photo-1568844293986-8d0400bd4745?auto=format&fit=crop&w=1600&q=80
```

- The `photo-XXX` ID is stable. No API key needed for direct embeds.
- Unsplash License: free for commercial + non-commercial, **attribution recommended** but not legally required for the photo itself. Read https://unsplash.com/license.
- For API search (50 req/hr free demo tier), request a key at https://unsplash.com/developers.

**When to use over Pollinations:** when the user wants a *real* recognizable place / object / brand, or when the AI-generated version looks "wrong" (e.g. fake-looking signage, incorrect car logos).

---

## 3. Lorem Picsum — random Unsplash placeholder

```
https://picsum.photos/seed/{seed}/{width}/{height}
https://picsum.photos/800/600?random=1
```

- No key. Returns a random curated Unsplash photo at requested dimensions.
- Use for **placeholder development** when content is undefined. Replace with Pollinations or Unsplash before launch.

---

## 4. Free icon systems

| System | URL | Style | Best for |
|---|---|---|---|
| **Material Symbols** | `https://fonts.googleapis.com/icon?family=Material+Symbols+Rounded` | 3 weights × 7 fill / grade axes | Web + mobile; ~3000 icons; loaded as font |
| **Lucide** | https://lucide.dev | Clean, line-art | React/Vue components; tree-shakeable |
| **Heroicons** | https://heroicons.com | Tailwind-flavored line + solid | Static SVG drop-in |
| **Phosphor** | https://phosphoricons.com | 6 weights, soft style | Dense UIs with thin/duotone needs |
| **Iconify** | https://iconify.design | Unified API over 200+ icon sets | When user can't decide which set |

All free, MIT/Apache/CC license.

---

## 5. Inline SVG / CSS-art fallback (zero network)

When generating images on-the-fly is impossible (offline, sandbox), render **category-coded SVG illustrations** inline. Example: see `ecoworld/lib/components.php::eco_unit_art()` — generates a per-category sky-gradient + foreground silhouette (terrace home / retail row / road / park / high-rise) entirely in PHP-emitted SVG, with `tone`-driven variation so 400 cards aren't identical.

Use this as the *permanent fallback*: even after Pollinations generates real photos, keep the SVG so missing files don't render as broken images.

---

## 6. Implementation pattern — the "swap-on-arrival" contract

The codebase pattern that makes this safe to run incrementally:

```php
// lib/components.php
function eco_unit_media(array $unit): void {
    $image = $unit['image'] ?? null;
    if ($image && is_file(__DIR__ . '/../' . $image)) {
        echo '<img src="/' . htmlspecialchars($image) . '" alt="..." loading="lazy" decoding="async">';
    } else {
        echo eco_unit_art($unit);  // SVG fallback
    }
}
```

The renderer **never breaks** if an image is missing. Run the generator at any time to populate `uploads/generated/`; the next page render automatically swaps SVG → `<img>`. Generate incrementally — hero first, then slideshow, then masonry batches.

---

## 7. AI automation contract — when the user says "generate images"

**Default workflow** (Claude Code / Codex / Gemini should follow this):

1. **Detect intent:** user mentions "generate images / create images / make property images / fill placeholder images / 生成图片".
2. **Check for existing infrastructure:**
   - `scripts/generate-images.php` (or `.js` / `.ps1`) → if exists, just run it.
   - `data/visuals.php` / image-prompt registry → if exists, use as prompt source.
   - `uploads/generated/` or `public/images/generated/` → save destination.
3. **If infrastructure missing:** scaffold it. Reference `ecoworld/scripts/generate-images.php` as the canonical template.
4. **Default to Pollinations.ai (§1)** for new generations. No API key prompt to user — just run.
5. **Generate incrementally:** hero → slideshow → masonry first 20 → on user approval, batch the rest. Don't generate 400 images on first run.
6. **Verify:** read 1–2 generated files with the Read tool to confirm quality before declaring done.
7. **Document:** append a CHANGE LOG entry in `BLUEPRINT.md` listing what was generated and which slot.
8. **Never overwrite** images that already exist unless user passes `--force` or explicitly says "regenerate".
9. **Cooperate** if another AI (codex / gemini) is also working: check for `uploads/generated/IMAGE_SOURCES.md` first; respect existing slot names.

**Do NOT:**

- ❌ Ask the user for an OpenAI / Imagen / Midjourney API key as a first step. Default to free.
- ❌ Generate hundreds of images on the first run without user approval (network + disk cost).
- ❌ Tell the user "I can't generate images" — you can, via Pollinations, with no key.
- ❌ Save generated images outside `uploads/generated/` or the project's documented image folder.

---

## 8. Why this beats the alternatives

| Path | Cost | Key needed | Quality | Speed | Notes |
|---|---|---|---|---|---|
| **Pollinations.ai** | $0 | No | High (flux) | ~5–15 s | Recommended default |
| OpenAI Images (gpt-image-1) | $0.04+/image | Yes | Very high | ~10 s | Hits billing limits fast |
| Gemini Imagen | per token | Yes | High | ~5 s | Requires Google Cloud |
| Midjourney | $10+/mo | Yes (Discord) | Highest | varies | Not scriptable easily |
| Stable Diffusion local | $0 + GPU | No | High | ~10 s + setup | Requires user's GPU + 30GB model |
| Unsplash search | $0 | Yes (free tier) | Real photos | <1 s | Limited to existing photos |
| Lorem Picsum | $0 | No | Variable | <1 s | Random / placeholder only |

**Conclusion:** Pollinations.ai is the right default for AI-driven image automation. Switch only when the user explicitly opts into a paid tier or has a specific licensing need.

---

## 9. Verification record

- 2026-05-11 — Tested `https://image.pollinations.ai/prompt/{prompt}?width=1600&height=900&model=flux&nologo=true&seed=42` via PowerShell `Invoke-WebRequest`. Returned 123 KB valid JPEG of "aerial premium Johor Bahru EcoWorld township" in ~10 seconds. Visually verified production-quality.
- 2026-05-11 — Generated 5 slideshow images for `ecoworld` project via `php scripts/generate-images.php --slot=slideshow` in ~10 seconds total. All visually production-ready.
- 2026-05-11 — Codex's competing OpenAI path returned `billing_hard_limit_reached` on the same project; Pollinations was unblocked.

---

*Created by Claude (Opus 4.7, 1M context) during EcoWorld redesign 2026-05-11. Cross-referenced by `design/website/IMAGE_GENERATION_FREE.md`, `design/app/IMAGE_GENERATION_FREE.md`, and `C:/Users/user/.claude/skills/free-image-generation/SKILL.md`.*
