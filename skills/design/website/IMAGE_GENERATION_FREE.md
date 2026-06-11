---
name: image-generation-free-website
description: "When building a PHP/HTML website and the user asks AI to generate images (hero, slideshow, masonry, gallery, blueprint), follow this skill. Defaults to free Pollinations.ai (no API key) and scaffolds `scripts/generate-images.php` if missing. Reference implementation: ecoworld project 2026-05-11."
type: skill
tier: 2
phase: 02-asset-orchestration
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "gpt-5.4-mini"]
related:
  - "SKILL.md"
  - "02-asset-orchestration/skill.md"
  - "../../../knowledge/IMAGE_SOURCING_FREE.md"
  - "ECOWORLD_COLOR_SYSTEM.md"
version: 1.0
date: 2026-05-11
status: authoritative
triggers:
  - "generate images for website"
  - "create hero image"
  - "fill in placeholder images"
  - "generate property images"
  - "make masonry photos"
  - "image generation free"
  - "openai billing blocked"
  - "ai generate images"
---

# Skill — Free Image Generation for PHP Websites

> **Sister doc:** [knowledge/IMAGE_SOURCING_FREE.md](../../../knowledge/IMAGE_SOURCING_FREE.md) — the canonical strategy, decision tree, and prompt-craft guide. This file is the **website-specific procedure** that calls that knowledge.

## When this skill fires

Trigger on any of:

- "generate images for [the website / homepage / project]"
- "create [hero / masonry / slideshow / gallery / blueprint] images"
- "fill in the missing photos"
- "replace placeholder images with real ones"
- OpenAI / Imagen / Midjourney API blocked (billing, quota, network)
- A PHP website with `uploads/generated/` or similar slot folder exists but is mostly empty

## Procedure (sequential)

### Step 1 — Check for existing infrastructure (do NOT duplicate)

Before scaffolding anything new, look for:

| Path | If exists, do |
|---|---|
| `scripts/generate-images.php` | Run it. Skip steps 2–3. |
| `scripts/generate-images.js` / `.ps1` | Use existing. |
| `data/visuals.php` or `data/visuals.json` | This is the prompt registry — read it first. |
| `api/database.php` with a `*_image_prompt` field on unit/product/post records | Per-record prompts already exist. |
| `uploads/generated/IMAGE_SOURCES.md` (or similar) | Another AI is/was working on images — read it, respect existing files, do not overwrite. |

### Step 2 — Scaffold `scripts/generate-images.php` if missing

Use the canonical template at [ecoworld/scripts/generate-images.php](../../../../Desktop/ecoworld/scripts/generate-images.php). It supports:

- `--slot=hero|slideshow|masonry|blueprint|all` — generate a single slot or everything
- `--limit=N` — generate only first N items in a slot
- `--force` — overwrite existing files (default: skip files that already exist)
- `--seed=N` — base seed for reproducibility

Adapt to the project's stack:

- **PHP/Laravel** → use `Http::get()->body()` instead of `file_get_contents()`.
- **Node** → use `fetch()` + `Buffer.from(await res.arrayBuffer())`.
- **Static HTML / no backend** → drop a one-liner PowerShell/Bash script in `scripts/` instead.

### Step 3 — Prompt-craft per slot

Pull prompts from the project's registry. If none exists, generate them on the fly using project context (BLUEPRINT.md, DESIGN.md, customer brief). Format:

```
[Locale anchor] — [subject], [architectural / scene detail], [light], [lifestyle activity], [aesthetic], [negatives], [aspect].
```

**Locale anchor examples** (replace with project's region):

- Property in Malaysia → "Johor Bahru / Iskandar Puteri", "Klang Valley (Eco Ardence / Eco Majestic style)", "Penang coastal"
- Property in Singapore → "Singapore HDB / Marine Parade district"
- Generic luxury → "Mediterranean villa estate, Côte d'Azur"

### Step 4 — Run incrementally

```
php scripts/generate-images.php --slot=hero          # 1 image, ~10s
php scripts/generate-images.php --slot=slideshow     # ~3–5 images, ~30s
php scripts/generate-images.php --slot=masonry --limit=20   # first 20 cards, ~3min
# only after user QA approval:
php scripts/generate-images.php --slot=masonry       # full batch
```

**Do NOT** kick off a 400-image batch on the first run. Generate 20–30 first, ask the user to visually QA at least one with the Read tool, only then go wider.

### Step 5 — Verify quality

After each batch:

1. `Read` 1–2 generated JPEGs to visually inspect (multimodal — you actually see the image).
2. If quality is off (wrong locale, wrong style, watermark visible), tune prompts in the registry and re-run with `--force` on the affected slot.
3. List the file with size — anything <5 KB is likely an error response, not an image.

### Step 6 — Wire up the swap-on-arrival contract

The PHP renderer must check file existence and fall back to SVG/CSS art when missing:

```php
function project_media(array $item): void {
    $image = $item['image'] ?? null;
    if ($image && is_file(__DIR__ . '/../' . $image)) {
        echo '<img src="/' . htmlspecialchars($image) . '" alt="" loading="lazy" decoding="async">';
    } else {
        echo project_svg_fallback($item);
    }
}
```

This means generation can run incrementally and the site never displays broken-image icons. See [ecoworld/lib/components.php::eco_unit_media()](../../../../Desktop/ecoworld/lib/components.php) for the reference implementation.

### Step 7 — Document the run

Append a `## 📜 CHANGE LOG` entry in the project's `BLUEPRINT.md`:

```markdown
### YYYY-MM-DD - [AI Name] - Image generation batch

- Goal: ...
- Source: Pollinations.ai flux model, free
- Slots filled: hero (1), slideshow (5), masonry first 20 of 400
- Files written: `uploads/generated/{hero,slideshow,masonry}/`
- Open for next AI: generate remaining 380 masonry tiles after user approval
```

### Step 8 — Where to save (per Codex PHP Website Structure)

Per [SKILL.md addendum](SKILL.md#codex-php-website-structure-addendum):

- `uploads/generated/<slot>/<key>.jpg` — generated production assets
- `images/` — brand/logo/manually approved assets (do NOT auto-generate into here)
- `assets/img/` — only if the project's existing structure uses that convention

## Anti-patterns

- ❌ Asking the user for an OpenAI API key as a first step. The default is FREE.
- ❌ Telling the user "I can't generate images" — Pollinations.ai needs no key.
- ❌ Generating into `images/` (reserved for brand/manually approved assets).
- ❌ Generating 400 images in one go without QA checkpoint.
- ❌ Overwriting another AI's work — always check `IMAGE_SOURCES.md` first.
- ❌ Putting Pollinations watermark in production — always set `nologo=true`.
- ❌ Generating with `width=device-width`-style hardcoded dimensions for desktop heroes — match the actual display ratio (16:9 hero, 4:3 card).

## Reference implementation

- Project: `c:/Users/user/Desktop/ecoworld/`
- Generator: [scripts/generate-images.php](../../../../Desktop/ecoworld/scripts/generate-images.php)
- Prompt source: [data/visuals.php](../../../../Desktop/ecoworld/data/visuals.php) + [api/database.php::eco_category_image_prompt()](../../../../Desktop/ecoworld/api/database.php)
- Renderer with fallback: [lib/components.php::eco_unit_media()](../../../../Desktop/ecoworld/lib/components.php)
- First production run: 2026-05-11, slot=slideshow, 5 images in ~10 seconds, all visually QA'd.

---

*Created 2026-05-11 by Claude (Opus 4.7) during EcoWorld redesign. Pairs with memories/1_core/IMAGE_SOURCING_FREE.md (master strategy) and design/app/IMAGE_GENERATION_FREE.md (mobile-app variant).*

