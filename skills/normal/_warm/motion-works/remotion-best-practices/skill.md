---
name: remotion-best-practices
description: "Remotion Best Practices Skill (Kit 2.0)"
triggers: ["remotion", "video", "motion works", "react video", "remotion best practices"]
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

# Remotion Best Practices Skill (Kit 2.0)

This skill enables Antigravity to create high-performance, frame-synchronized animations for websites and motion graphics using the Remotion framework.

## Core Principles
- Frame-Synchronization: Always use `useCurrentFrame()` to drive animations.
- Interpolation: Use the `interpolate()` helper for smooth, eased transitions.
- Composition: Structure animations into modular `Composition` and `Sequence` components.
- Performance: Optimize heavy renders by offloading complex 3D logic to lightweight Three.js components when possible.

## Animation Hooks
```typescript
import { useCurrentFrame, interpolate, spring, useVideoConfig } from 'remotion';

// Example: Smooth Entrance
const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const opacity = interpolate(frame, [0, 20], [0, 1], { extrapolateRight: 'clamp' });
const scale = spring({ frame, fps, from: 0.8, to: 1 });
```

## Motion Website Integration
Animations designed in Remotion should be convertible to:
1. High-Quality MP4: For background sliders.
2. React Components: For interactive web scenes.
3. Lottie/JSON: For lightweight UI micro-interactions.

