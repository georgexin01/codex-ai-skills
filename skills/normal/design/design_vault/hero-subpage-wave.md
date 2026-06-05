---
name: hero-subpage-wave
description: "Design Snippet: Subpage Hero (ZETA V5.3)"
triggers: ["hero subpage wave", "hero-subpage-wave", "design snippet subpage"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: hero-subpage-wave
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Design Snippet: Subpage Hero (ZETA V5.3)

Type: HERO_SECTION
DNA: CINEMATIC_ATMOSPHERE
Context: Subpage consistency (About, Services, Portfolio)

## 🎨 VISUAL STRUCTURE
Uses a `hero-wave-wrap` with nested `stars-layer` and absolute-positioned `meteor` elements.

```html
<section class="hero-wave-wrap">
  <div class="wave-container">
    <div class="stars-layer"></div>
    <div class="meteor meteor-1"></div>
    <div class="meteor meteor-2"></div>
    <div class="meteor meteor-3"></div>
  </div>
  <div class="container">
    <div class="hero-content" style="max-width: 800px; margin: 0 auto; text-align: center">
      <span class="font-mono">// [SECTION_TAG]</span>
      <h1>[MAIN_HEADLINE]</h1>
      <p>[DESCRIPTION_TEXT]</p>
    </div>
  </div>
</section>
```

## 🛠️ CSS TOKENS
- Height: `min-height: 400px` to `600px`.
- Perspective: Deep parallax-style star layers.
- Meteor Animation: Staggered `@keyframes meteor` with 45deg trajectory.

---
ZETA Design Vault — Subpage Hero Pattern

