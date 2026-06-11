---
name: scroll-fadein-pattern
description: "IntersectionObserver-driven scroll fade-in for content pages. Path-based exclusion skips masonry/lazy-load pages (homepage + available-units). Opacity + translateY transition, prefers-reduced-motion respected, 700 ms cubic-bezier ease-out. Drop-in pattern validated 2026-05-12 on the EcoWorld about / contact / unit / blueprint pages."
type: skill
tier: 2
phase: 07-motion-design
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "gpt-5.4-mini"]
related:
  - "SKILL.md"
  - "07-motion-design/skill.md"
  - "12-performance-tuning/skill.md"
version: 1.0
date: 2026-05-12
status: authoritative
triggers:
  - "scroll fade in"
  - "intersection observer animation"
  - "section fade in"
  - "card fade in animation"
  - "page scroll animation"
  - "fadein on scroll"
---

# Scroll Fade-in Pattern (with masonry-page exclusion)

> Drop-in vanilla-JS pattern that fades content into view as the user scrolls. Targeted at content-led pages (about, contact, detail, blueprint). **Deliberately excludes** masonry/wall pages because their lazy-load batching already animates each card in, and double-animating creates jitter. Reference impl: `c:/Users/user/Desktop/ecoworld/js/app.js` + `css/style.css` ".is-fadein" block.

## 1. The two-piece pattern

**CSS — initial hidden state + visible transition:**

```css
.is-fadein {
  opacity: 0;
  transform: translateY(24px);
  transition:
    opacity 700ms cubic-bezier(0.22, 1, 0.36, 1),
    transform 700ms cubic-bezier(0.22, 1, 0.36, 1);
  will-change: opacity, transform;
}
.is-fadein.is-visible {
  opacity: 1;
  transform: translateY(0);
}
@media (prefers-reduced-motion: reduce) {
  .is-fadein {
    opacity: 1 !important;
    transform: none !important;
    transition: none !important;
  }
}
```

**JS — observer with path-based exclusion:**

```js
(function () {
  const path = (window.location.pathname || '/').replace(/\/+$/, '') || '/';
  const excluded = new Set(['/', '/index.php', '/available-units']);  // masonry pages
  if (excluded.has(path)) return;
  if (!('IntersectionObserver' in window)) return;
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  const selectors = [
    'main > section',
    // …project-specific cards below
    '.about-pillar', '.about-page-card', '.about-crafted-card',
    '.contact-form-card', '.contact-info-card', '.contact-social-card',
    '.unit-lifestyle-card', '.unit-intro__specs',
    '.blueprint-zone', '.blueprint-sustain-card',
  ];

  const targets = document.querySelectorAll(selectors.join(', '));
  if (!targets.length) return;

  targets.forEach((el) => el.classList.add('is-fadein'));

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);  // fire-once per element
        }
      });
    },
    { rootMargin: '0px 0px -40px 0px', threshold: 0.05 }
  );

  targets.forEach((el) => observer.observe(el));
})();
```

## 2. Design decisions captured

| Choice | Why |
|---|---|
| **`opacity` + `translateY(24px)`** | Both compositor properties — GPU accelerated, no layout thrash. 24 px lift is enough to feel deliberate without overshooting. |
| **`cubic-bezier(0.22, 1, 0.36, 1)`** | Smooth ease-out curve (Material's "decelerate"). Looks calmer than linear or ease. |
| **700 ms** | Long enough to register as intentional, short enough not to delay reading. 400 ms feels rushed; 1200 ms feels slow. |
| **`rootMargin: 0px 0px -40px 0px`** | Triggers slightly *before* fully on-screen — by the time the user is reading, the element is settled, not still animating. |
| **`threshold: 0.05`** | Even partial visibility (just 5% of bbox) is enough. Avoids missed triggers when a section is taller than the viewport. |
| **`observer.unobserve(el)`** after fire | Fire-once. Re-entering the viewport doesn't re-animate (which would feel buggy). |
| **`will-change`** | Optimization hint. Apply *only* to fade-targets, not site-wide — `will-change: opacity, transform` on too many elements wastes GPU memory. |
| **Path exclusion** | Homepage + available-units already animate cards in via their own lazy-load batching. Stacking observers causes double-fades that flicker. |
| **`prefers-reduced-motion`** | Hard early-return. The override `!important` on `.is-fadein` ensures any pre-tagged element snaps to visible immediately. |
| **Above-the-fold elements** | Observer fires on next tick for already-intersecting elements — they fade in once, immediately. No "flash of hidden content" if the script runs at the bottom of the body or via `defer`. |

## 3. Picking selectors

The "what to fade" list lives in JS, not CSS, to keep CSS free of project-specific selectors. **Three families of targets:**

1. **`main > section`** — every section gets a soft entrance. Universal default.
2. **Card classes** — anything that's a self-contained content block (pillar card, page card, lifestyle card, region card, info card, form card, etc.).
3. **Distinct image+copy splits** — `.mission__media`, `.mission__copy`, `.powered__media`, `.powered__copy` so they fade as a coordinated pair.

**Do not** tag:
- Hero containers (above-the-fold; they'd fade in on load and feel slow)
- Header / footer / nav
- Filter chips / dot indicators (already animate via hover/active)
- Slideshow slides (they have their own transition)

## 4. Page exclusion list

Currently excluded paths: `/`, `/index.php`, `/available-units`.

Add to the set when a page has its own lazy-load or scroll-driven animation:
- Masonry walls (CSS Grid masonry with batch-append)
- Infinite scroll feeds
- Pages with their own GSAP / ScrollTrigger orchestration

## 5. Anti-patterns

- ❌ Fading the hero. Above-the-fold should be visible at first paint.
- ❌ Using `transform: scale()` instead of `translateY()` — scale interacts with `object-fit: cover` images and produces brief sub-pixel shimmer.
- ❌ Forgetting `observer.unobserve(el)`. Re-firing on every scroll oscillation = jittery flicker.
- ❌ Tagging the wrong layer. If `.section` already has `display: grid` children, fade the *section* not the grid items (parent-child fade looks staircase-y).
- ❌ Stacking this on top of a masonry page's own lazy-load animation. Pick one.
- ❌ Using `IntersectionObserver` without the `in window` feature check — IE11 / older Safari will throw.

## 6. Cross-page sister patterns

- Drag-driven content: see [DRAGGABLE_SLIDESHOW_PATTERN.md](DRAGGABLE_SLIDESHOW_PATTERN.md) — uses its own transform animation, not this one.
- Card hover lift: separate concern. Don't combine `is-fadein` `transform` with hover `transform: translateY(-3px)`; the second transition will override mid-fade and look broken. Wait until `.is-visible` is set, *then* enable hover transitions if you must.

---

*Authored 2026-05-12 by Claude after EcoWorld about/contact/unit/blueprint pages got the fade-in. Reference impl: `c:/Users/user/Desktop/ecoworld/js/app.js` (block "Scroll fade-in"), `css/style.css` (block ".is-fadein").*

