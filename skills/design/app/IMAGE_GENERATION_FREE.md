---
name: image-generation-free-app
description: "When building a Vue 3 + Capacitor mobile app and the user asks AI to generate images (lifestyle, onboarding, category icons, banner cards), follow this skill. Defaults to free Pollinations.ai (no API key) and scaffolds `scripts/generate-images.ts` if missing. Mobile-app variant of design/website/IMAGE_GENERATION_FREE.md."
type: skill
tier: 2
phase: 02-asset-orchestration
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "gpt-5.4-mini"]
related:
  - "SKILL.md"
  - "02-asset-orchestration/skill.md"
  - "../../../memories/1_core/IMAGE_SOURCING_FREE.md"
  - "../website/IMAGE_GENERATION_FREE.md"
version: 1.0
date: 2026-05-11
status: authoritative
triggers:
  - "generate images for app"
  - "create onboarding images"
  - "generate banner cards"
  - "make lifestyle images for mobile app"
  - "category illustrations"
  - "image generation free mobile"
---

# Skill — Free Image Generation for Mobile Apps (Vue 3 + Capacitor)

> **Sister docs:**
> - [knowledge/IMAGE_SOURCING_FREE.md](../../../memories/1_core/IMAGE_SOURCING_FREE.md) — master strategy
> - [design/website/IMAGE_GENERATION_FREE.md](../website/IMAGE_GENERATION_FREE.md) — PHP/website variant
>
> This file is the **mobile-app procedure**. The image-gen strategy is identical (Pollinations.ai default), but storage location, bundling, and runtime constraints differ.

## When this skill fires

Trigger on any of:

- "generate [onboarding / banner / lifestyle / category] images for [the app]"
- "fill in the missing photos in the Vue app"
- "create banner cards for the home tab"
- OpenAI / Imagen API blocked
- A Vue/Capacitor app has `src/assets/img/` slots or `public/img/` references that are empty

## Mobile-specific constraints

| Constraint | Implication |
|---|---|
| **Bundle size** | Don't import every image into the Vite bundle. Put generated assets in `public/img/` (served as-is) or load remote URLs at runtime. |
| **Retina** | Generate at 2× target display size — a 200×150 card should source a 400×300 image. Use `width=800&height=600` for safety. |
| **Mobile bandwidth** | Compress generated JPEGs to <100 KB before bundling. Add a `--max-kb=100` post-process step. |
| **App store review** | Generated images of recognizable real people / brands can fail review. Use generic / abstract scenes. |
| **Offline mode** | If Capacitor + offline support — bundle critical images into `public/img/` so they ship with the binary; load nice-to-have images from CDN. |
| **Dark mode** | Generate 2 variants per slot (`*-light.jpg` and `*-dark.jpg`) when the app supports a theme switcher. |

## Procedure

### Step 1 — Check infrastructure

Look for:

| Path | Meaning |
|---|---|
| `scripts/generate-images.ts` / `.js` | Existing generator — use it |
| `src/data/visuals.ts` / `src/constants/imagePrompts.ts` | Existing prompt registry |
| `public/img/generated/` or `src/assets/img/generated/` | Existing slot folder |

### Step 2 — Scaffold `scripts/generate-images.ts` if missing

```ts
// scripts/generate-images.ts
// Run: node --experimental-strip-types scripts/generate-images.ts --slot=banners
import fs from 'node:fs/promises';
import path from 'node:path';
import { visuals } from '../src/data/visuals.ts';

const BASE = 'https://image.pollinations.ai/prompt/';
const ROOT = path.resolve(import.meta.dirname, '..');

const slot = process.argv.find(a => a.startsWith('--slot='))?.split('=')[1] ?? 'all';
const force = process.argv.includes('--force');

type Job = { path: string; prompt: string; w: number; h: number; seed: number };
const jobs: Job[] = [];

// hero / banners
if (slot === 'banner' || slot === 'all') {
  visuals.banners.forEach((b, i) => jobs.push({
    path: `public/img/generated/banner/${b.key}.jpg`,
    prompt: b.prompt, w: 1200, h: 800, seed: 42 + i,
  }));
}
// category cards
if (slot === 'category' || slot === 'all') {
  visuals.categories.forEach((c, i) => jobs.push({
    path: `public/img/generated/category/${c.key}.jpg`,
    prompt: c.prompt, w: 800, h: 600, seed: 100 + i,
  }));
}

for (const [i, j] of jobs.entries()) {
  const abs = path.join(ROOT, j.path);
  await fs.mkdir(path.dirname(abs), { recursive: true });
  try {
    await fs.access(abs);
    if (!force) { console.log(`[${i+1}/${jobs.length}] skip ${j.path}`); continue; }
  } catch {}

  const url = `${BASE}${encodeURIComponent(j.prompt)}?width=${j.w}&height=${j.h}&model=flux&seed=${j.seed}&nologo=true&private=true`;
  const res = await fetch(url, { headers: { 'User-Agent': 'MyApp-Gen/1.0' } });
  if (!res.ok) { console.log(`[${i+1}/${jobs.length}] FAIL ${j.path}`); continue; }
  const buf = Buffer.from(await res.arrayBuffer());
  await fs.writeFile(abs, buf);
  console.log(`[${i+1}/${jobs.length}] OK ${j.path} (${buf.length}b)`);
  await new Promise(r => setTimeout(r, 500));
}
```

### Step 3 — Prompt-craft for mobile context

Mobile slots are typically smaller and more iconic than website slots. Lean into:

- **Vertical orientation** (`height > width`) for portrait phone hero/onboarding screens
- **Strong centered subject** with breathing room (text overlays land on top in-app)
- **Simpler scenes** (a single hero element vs. busy aerial) — less visual noise on small displays
- **Brand-safe** (USER_DNA Industrial palette: violet/teal/dark gradients with glow)

### Step 4 — Storage location

- `public/img/generated/` → served raw at `/img/generated/...`, NOT bundled by Vite
- `src/assets/img/generated/` → bundled (use for tiny / always-loaded images)
- Capacitor: `public/` ships inside the app binary in production — keep file count and total size manageable

### Step 5 — Reference in code

```vue
<!-- Static reference (public/img/, not bundled) -->
<img src="/img/generated/banner/spring-promo.jpg" loading="lazy" />

<!-- Bundled with hashing (src/assets/, Vite-handled) -->
<img :src="bannerUrl" />
<script setup>
import bannerUrl from '@/assets/img/generated/banner/spring-promo.jpg?url';
</script>

<!-- Remote (no bundling, leverage CDN cache) -->
<img :src="`/img/generated/category/${cat.key}.jpg`" loading="lazy" />
```

### Step 6 — Runtime safety

When loading from `/img/generated/`, always pair with a fallback for missing files:

```vue
<img :src="src" @error="onMissing" />
<script setup>
const onMissing = (e) => { e.target.src = '/img/fallback/placeholder.svg'; };
</script>
```

Always ship a `placeholder.svg` (e.g. category-coded gradient) so a missing generated image never renders as a broken-image icon on a phone.

### Step 7 — Document

Append to `BLUEPRINT.md` (project root):

```markdown
### YYYY-MM-DD - [AI Name] - Mobile image batch

- Generator: Pollinations.ai flux, free
- Slots filled: banner (5), category (8)
- Total: 13 images, 1.2 MB, all <100 KB after compression
- Bundle impact: 0 (in public/img/, not Vite-bundled)
```

## Anti-patterns (mobile-specific)

- ❌ Generating at 4K resolution then shipping unscaled — kills app size + first paint.
- ❌ Bundling generated images into `src/assets/` when they're 50+ files (Vite produces 50+ chunk imports).
- ❌ Loading 20 cards' images simultaneously on the home tab — use `loading="lazy"` and intersection observers.
- ❌ Forgetting the SVG fallback — Capacitor offline mode + missing generated image = blank card.
- ❌ Using `width=device-width` style numbers from CLAUDE.md viewport rule as image dimensions. **Image dimensions ≠ viewport meta.** Generate at intentional aspect ratios.

## Reference implementation

Mobile app generator pattern (TypeScript / Node):
- *(No live mobile-app reference yet — first production run pending. Until then, mirror the PHP/website reference at [ecoworld/scripts/generate-images.php](../../../../Desktop/ecoworld/scripts/generate-images.php) and adapt to TS.)*

---

*Created 2026-05-11 by Claude (Opus 4.7). Pairs with website variant for full coverage of the design/* skill family.*

