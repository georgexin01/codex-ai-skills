---
name: unified-interaction-dna
description: "Logic Snippet: Unified Showcase & ScrollTrigger Sync"
triggers: ["unified interaction dna", "unified-interaction-dna", "logic snippet unified"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: unified-interaction-dna
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Logic Snippet: Unified Showcase & ScrollTrigger Sync

Type: INTERACTION_LOGIC
DNA: CINEMATIC_SYNC
Context: Portfolio/Showcase sections with sticky phone frames.

## 🧠 LOGIC ARCHITECTURE
Synchronizes a list of content items with a sticky visual frame (Phone/Laptop).

### 1. The Scroll-Auto Triage
- Auto-Slide: Active while the section is out of viewport (Hero state).
- Scroll-Control: `ScrollTrigger` kills the interval on enter and maps `index` to the phone's `src` URL.

```javascript
ScrollTrigger.create({
  trigger: ".showcase-items",
  start: "top 80%",
  onEnter: () => {
    isAutoSliding = false;
    clearInterval(autoSlideInterval);
  }
});
```

### 2. Galactic Cosmos Generator (Procedural Layer)
Generates 50+ stars with randomized CSS properties and animations.

```javascript
function initDynamicCosmos() {
  const container = document.querySelector(".wave-container");
  for (let i = 0; i < 50; i++) {
    const star = document.createElement("div");
    star.className = "dynamic-star";
    Object.assign(star.style, {
      width: `${Math.random() * 2.5 + 1.2}px`,
      left: `${Math.random() * 100}%`,
      animation: `star-twinkle ${Math.random() * 7 + 7}s ease-in-out infinite alternate`,
    });
    container.appendChild(star);
  }
}
```

---
ZETA Logic Vault — Unified Interaction Pattern

