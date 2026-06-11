---
name: shader-glsl
description: "SHADER GLSL — LEVEL 7 CORE SKILL"
triggers: ["shader", "glsl", "shader glsl", "3d", "3d works", "webgl shader"]
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

# SHADER GLSL — LEVEL 7 CORE SKILL

[!IMPORTANT]
Shaders (GLSL) are the secret sauce for "Master" websites. They allow for pixel-level distortion, liquid effects, and high-performance visual magic.

---

## 1. CORE CONCEPTS (LEVEL 7)

*   Vertex Shader: Manipulate geometry positions (e.g., creating wave-like distortions on a plane).
*   Fragment Shader: Manipulate pixel colors (e.g., creating liquid flows, noise, or chromatic aberration).
*   Uniforms: Variables passed from JS to GLSL (e.g., `uTime`, `uMouse`, `uResolution`).

---

## 2. ELITE PATTERNS

### 2.1 The "Liquid Water" Distortion
```glsl
// Fragment Shader
precision mediump float;
uniform float uTime;
uniform sampler2D uTexture;
varying vec2 vUv;

void main() {
  vec2 uv = vUv;
  uv.y += sin(uv.x * 10.0 + uTime) * 0.01; // Core Wave Math
  vec4 color = texture2D(uTexture, uv);
  gl_FragColor = color;
}
```

### 2.2 Noise & Grain (Level 7 Aesthetic)
```glsl
float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}
// Use to create premium film grain overlays.
```

---

## 3. MASTER OPTIMIZATION

| Optimization | Rule |
|--------------|------|
| Power-of-Two | Textures MUST be sized in powers of 2 (512x512, 1024x1024). |
| Precision | Use `precision lowp float` for effects where high math accuracy isn't critical to save GPU cycles. |
| Bake First | If a shader doesn't need to respond to user input, bake it into a static image/video. |

---

Skill: Shader GLSL V1.0 (2026-04-02)
Status: ACTIVE. Current Target: Immersive Textures.

