---
name: liquid-red-shader
description: "Liquid Red Shader Architecture (V1.0)"
triggers: ["liquid red shader", "liquid-red-shader", "liquid shader architecture"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: liquid-red-shader
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Liquid Red Shader Architecture (V1.0)

Identity: CINEMATICMOTIONDNA
Tech: Three.js + GLSL
Pattern: Level 10 Liquid Distortion

## 🎥 MATERIAL SPECIFICATION

### Vertex Shader (Simplex Noise)
- Logic: Uses 3D Simplex noise to distort plane geometry on the Z-axis.
- Interaction: Mouse-proximity smoothstep influence for dynamic "push" effect.

```glsl
float noise = snoise(vec3(position.xy * 0.4, uTime * 0.2));
float mouseInfluence = smoothstep(2.0, 0.0, distance(position.xy, uMouse * 5.0)) * 0.5;
newPos.z += noise * 0.8 + mouseInfluence;
```

### Fragment Shader (Cinematic Finish)
- Palette: Deep Black (#050505) to Master Red (#cc0000).
- Effect: Scanline interference (`sin(vUv.y * 400.0 + uTime * 10.0)`) for a technical/monitored look.

## 🛠️ IMPLEMENTATION KERNEL
- Geometry: `PlaneGeometry(20, 20, 128, 128)` for high-tessellation displacement.
- Renderer: `WebGLRenderer({ antialias: true, alpha: true })`.
- Scaling: Clamp mouse influence to `devicePixelRatio` max 2 for performance.

---
Liquid Red Shader DNA — Infinity Matrix Integration (2026-04-10)

