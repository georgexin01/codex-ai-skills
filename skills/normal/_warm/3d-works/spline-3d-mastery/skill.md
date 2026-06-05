---
name: spline-3d-mastery
description: "SPLINE 3D MASTERY — LEVEL 7 / V16 SKILL"
triggers: ["spline", "spline 3d", "3d", "3d works", "spline mastery", "spline 3d mastery"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.1
status: warm
auto_load: false
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: SKILL
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# SPLINE 3D MASTERY — LEVEL 7 / V16 SKILL

[!IMPORTANT]
Spline is the industry standard for Interactivity-First 3D. In Level 7 design, the AI doesn't just build a scene; it builds a bridge between the user and the 3D space.

---

## 1. CORE CONCEPTS

*   Interactive Triggers: Mouse hover/click events that trigger 3D animations (Scale, Rotation, Material change).
*   Magnetic Cursors: UI elements that are "pulled" toward 3D objects using Raycasting.
*   MSDF Text in 3D: High-performance, razor-sharp text rendered within the 3D canvas.
*   Environment States: Transitioning between a "Frost state" and a "Glow state" within a single 3D scene.

---

## 2. IMPLEMENTATION (R3F + SPLINE LOGIC)

### 2.1 The "Magnetic" Interaction
```javascript
// Level 7 Raycasting Logic
const raycaster = new THREE.Raycaster();
const mouse = new THREE.Vector2();

window.addEventListener('mousemove', (e) => {
  mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
  mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
  
  raycaster.setFromCamera(mouse, camera);
  const intersects = raycaster.intersectObjects(scene.children);
  
  if (intersects.length > 0) {
    // Apply "Magnetic" pull to cursor-outline
    gsap.to(cursorOutline, { 
      x: e.clientX, 
      y: e.clientY, 
      scale: 2, 
      duration: 0.3 
    });
  }
});
```

---

## 3. AUDIT PROMPT (GEMINI V16)

When auditing a Spline-based 3D site, the AI MUST check:
1.  Hierarchy: Is the 3D scene the background or a foreground element? (Level 7 = Seamless integration).
2.  Response Time: Is there any lag between mouse move and 3D reaction? (Target: < 16ms).
3.  Depth: Does the UI overlap the 3D model correctly (Z-indexing)?

---

Skill: Spline 3D Mastery V1.0 (2026-04-02)
Status: ACTIVE. Current Target: Interactive Arctic Configurator.

