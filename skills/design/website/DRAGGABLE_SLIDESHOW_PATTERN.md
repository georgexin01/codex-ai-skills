---
name: draggable-slideshow-pattern
description: "Full-bleed 60/40 split slideshow + soft-gradient copy panel for property/product detail heroes. Drag-to-swipe (pointer + touch), autoplay every 5 s, dot navigation, keyboard ArrowLeft/Right, prefers-reduced-motion. Zero dependencies. Validated 2026-05-12 against EcoWorld unit page after the user asked for a wall-to-wall slideshow with copy on the right."
type: skill
tier: 2
phase: 05-hero-cinematics
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "gpt-5.4-mini"]
related:
  - "SKILL.md"
  - "05-hero-cinematics/skill.md"
  - "ECOWORLD_COLOR_SYSTEM.md"
version: 1.0
date: 2026-05-12
status: authoritative
triggers:
  - "draggable slideshow"
  - "swipe slideshow"
  - "image carousel pointer"
  - "hero slideshow"
  - "unit detail slideshow"
  - "full bleed slideshow"
  - "no border radius slideshow"
---

# Draggable Slideshow + Soft-Gradient Copy Pattern

> Two-column hero for property / product / portfolio detail pages: **edge-to-edge slideshow on the left (60%)** and a soft mint→gold gradient copy panel on the right (40%). Slideshow is pointer/touch draggable, autoplays every 5 s, supports dot nav + keyboard. Zero JS libs. Reference impl: `c:/Users/user/Desktop/ecoworld/template/unit.php` + `js/app.js` (Unit slideshow block).

## 1. Why full-bleed, why 60/40

- The slideshow is the **primary visual** — radius and shadow on it make it look "boxed" and reduce immersion. Strip both.
- 60/40 split puts more weight on the visual without starving the copy column of breathing room. 50/50 makes the headline feel cramped; 70/30 buries the CTAs.
- **No gap** between the two columns — the gradient panel meets the photo edge directly, creating a magazine-spread feel.
- On mobile, the grid collapses to single-column (`grid-template-columns: 1fr` below 900 px).

## 2. Markup

```html
<section class="detail-split">
  <div class="detail-split__inner">

    <div class="slideshow" data-slideshow>
      <div class="slideshow__track" data-slideshow-track>
        <figure class="slideshow__slide is-active" data-slideshow-slide>
          <img src="/img/unit-1.jpg" alt="…" loading="eager" draggable="false">
        </figure>
        <figure class="slideshow__slide" data-slideshow-slide>
          <img src="/img/unit-2.jpg" alt="…" loading="lazy" draggable="false">
        </figure>
        <!-- … -->
      </div>
      <div class="slideshow__dots" role="tablist">
        <button type="button" class="slideshow__dot is-active" data-slideshow-dot="0" aria-label="Slide 1"></button>
        <!-- … -->
      </div>
    </div>

    <div class="detail-hero">
      <div class="detail-hero__inner">
        <span class="section-kicker">REGION / TYPE</span>
        <h1>Eco Land Unit 007</h1>
        <p>A compact discovery card for buyers comparing EcoWorld-style opportunities.</p>
        <div class="hero__actions">
          <a class="button" href="tel:…">Call Sales</a>
          <button class="button button--ghost" type="button" data-share>Share</button>
        </div>
      </div>
    </div>

  </div>
</section>
```

Per-unit slide composition: **own image first, then 2–3 cyclically rotated cover photos** (use unit id % poolLength so each unit gets a distinct sequence). Don't show the same 4 images for every unit.

## 3. CSS

```css
.detail-split { width: 100%; max-width: 100%; margin: 0; padding: 0; }
.detail-split__inner {
  display: grid;
  grid-template-columns: 60% 40%;
  gap: 0;
  align-items: stretch;
}
@media (max-width: 899.98px) {
  .detail-split__inner { grid-template-columns: 1fr; }
}

/* Slideshow — no radius, no shadow, full-bleed */
.slideshow {
  position: relative;
  width: 100%;
  aspect-ratio: 4 / 3;
  overflow: hidden;
  background: var(--eco-paper);
  border-radius: 0;
  box-shadow: none;
  border: 0;
  cursor: grab;
  touch-action: pan-y;
  user-select: none;
}
.slideshow.is-dragging { cursor: grabbing; }
.slideshow__track { position: absolute; inset: 0; }
.slideshow__slide {
  position: absolute; inset: 0; margin: 0;
  opacity: 0;
  transform: scale(1.02);
  transition: opacity 600ms ease, transform 800ms ease;
  pointer-events: none;
}
.slideshow__slide.is-active { opacity: 1; transform: scale(1); }
.slideshow__slide img {
  width: 100%; height: 100%;
  object-fit: cover; display: block;
  pointer-events: none;
}
/* Drag-shift feedback */
.slideshow.is-dragging .slideshow__slide.is-active {
  transform: translateX(var(--drag-x, 0px)) scale(1);
  transition: none;
}
@media (prefers-reduced-motion: reduce) {
  .slideshow__slide { transition: opacity 200ms linear; transform: none !important; }
}

.slideshow__dots {
  position: absolute; left: 50%; bottom: 18px;
  transform: translateX(-50%);
  display: flex; gap: 8px; z-index: 2;
  padding: 8px 14px;
  background: rgba(255,255,255,0.42);
  backdrop-filter: blur(10px);
  border-radius: 999px;
}
.slideshow__dot {
  width: 10px; height: 10px;
  border-radius: 50%; padding: 0; border: 0;
  background: rgba(255,255,255,0.55);
  box-shadow: 0 0 0 1px rgba(6,63,36,0.18);
  cursor: pointer;
  transition: background 160ms ease, transform 160ms ease;
}
.slideshow__dot:hover { transform: scale(1.15); }
.slideshow__dot.is-active {
  background: var(--eco-white);
  box-shadow: 0 0 0 1px var(--eco-green-700);
}

/* Right-side copy panel — soft mint→gold radial gradient */
.detail-hero {
  position: relative;
  padding: clamp(24px, 3vw, 40px);
  border-radius: 0; box-shadow: none; border: 0;
  background:
    radial-gradient(80% 100% at 0% 0%, rgba(28,154,80,0.18), transparent 55%),
    radial-gradient(60% 100% at 100% 0%, rgba(212,160,23,0.20), transparent 60%),
    var(--eco-white);
  display: flex; align-items: center;
}
.detail-hero__inner { display: grid; gap: 12px; width: 100%; }
.detail-hero h1 {
  margin: 0;
  font-family: Georgia, "Times New Roman", serif;
  font-size: clamp(30px, 3.4vw, 46px);
  line-height: 1.08;
  font-weight: 700;
  color: var(--eco-green-900);
}
.detail-hero h1::after { content: "."; color: var(--cat-leisure); }
```

## 4. Drag + autoplay JS (drop-in, vanilla, no deps)

```js
document.querySelectorAll('[data-slideshow]').forEach((root) => {
  const slides = Array.from(root.querySelectorAll('[data-slideshow-slide]'));
  const dots = Array.from(root.querySelectorAll('[data-slideshow-dot]'));
  if (slides.length <= 1) return;

  let index = 0, autoplayId = null;
  const AUTOPLAY_MS = 5000, DRAG_THRESHOLD = 50;
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const setIndex = (n) => {
    index = (n + slides.length) % slides.length;
    slides.forEach((s, i) => s.classList.toggle('is-active', i === index));
    dots.forEach((d, i) => d.classList.toggle('is-active', i === index));
  };
  const advance = (d) => setIndex(index + d);
  const startAutoplay = () => {
    if (reducedMotion) return;
    stopAutoplay();
    autoplayId = setInterval(() => advance(1), AUTOPLAY_MS);
  };
  const stopAutoplay = () => { if (autoplayId) { clearInterval(autoplayId); autoplayId = null; } };

  dots.forEach((d) => d.addEventListener('click', () => {
    setIndex(Number(d.dataset.slideshowDot));
    startAutoplay();
  }));

  // Pointer drag
  let pid = null, startX = 0, currX = 0, dragging = false;
  root.addEventListener('pointerdown', (e) => {
    if (e.button !== undefined && e.button !== 0) return;
    pid = e.pointerId; startX = e.clientX; currX = 0; dragging = true;
    root.classList.add('is-dragging');
    root.setPointerCapture?.(pid);
    stopAutoplay();
  });
  root.addEventListener('pointermove', (e) => {
    if (!dragging || e.pointerId !== pid) return;
    currX = e.clientX - startX;
    root.style.setProperty('--drag-x', `${currX}px`);
  });
  const onUp = (e) => {
    if (!dragging || (e && e.pointerId !== pid)) return;
    dragging = false;
    root.classList.remove('is-dragging');
    root.style.setProperty('--drag-x', '0px');
    try { root.releasePointerCapture?.(pid); } catch (_) {}
    pid = null;
    if (currX <= -DRAG_THRESHOLD) advance(1);
    else if (currX >= DRAG_THRESHOLD) advance(-1);
    startAutoplay();
  };
  root.addEventListener('pointerup', onUp);
  root.addEventListener('pointercancel', onUp);
  root.addEventListener('mouseleave', () => { if (dragging) onUp({ pointerId: pid, clientX: startX }); });

  // Keyboard
  root.tabIndex = 0;
  root.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight') { advance(1); startAutoplay(); }
    if (e.key === 'ArrowLeft')  { advance(-1); startAutoplay(); }
  });

  startAutoplay();
});
```

## 5. Anti-patterns

- ❌ Adding `border-radius: 28px` on the slideshow because "cards should have radius". The slideshow is a hero, not a card.
- ❌ Putting a gap between the slideshow and the copy panel — breaks the magazine-spread feel.
- ❌ Using `touch-action: none` on mobile — blocks vertical scroll. Use `pan-y` so vertical scrolls still work.
- ❌ Forgetting `draggable="false"` on `<img>` — Chrome will start a native image-drag instead of the slideshow drag.
- ❌ Using a single shared slide pool for every unit/product. Per-item rotation (id % pool length) gives each detail page distinct visuals.
- ❌ `summary_large_image` Twitter card with this layout's 4:3 aspect — use `summary` until you have a 1200×630 OG asset.

## 6. Property-site variant — 4-image slide source

```php
// Build a 4-slide gallery: the unit's own image first, then 3 from a pool
$pool = $visuals['masonry'] ?? [];
$slides = [];
if (!empty($unit['image'])) $slides[] = $unit['image'];
if (!empty($pool)) {
  $start = ((int) $unit['id']) % count($pool);
  for ($i = 0; $i < 3 && count($slides) < 4; $i++) {
    $candidate = $pool[($start + $i) % count($pool)];
    if (!in_array($candidate, $slides, true)) $slides[] = $candidate;
  }
}
```

---

*Authored 2026-05-12 by Claude during EcoWorld unit-page hero rebuild. Reference impl: `c:/Users/user/Desktop/ecoworld/template/unit.php`, `css/style.css` ".unit-slideshow*" block, `js/app.js` "Unit slideshow" block.*

