---
name: stitch-bridge
description: "Google Stitch Logic Bridge"
triggers: ["stitch bridge", "stitch_bridge", "google stitch logic"]
phase: reference
model_hint: codex-gpt-5.3
version: 1.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 1.0
  n: stitch_bridge
  graph:
    req: [stitch-app-developer, stitch-ui-design]
    rel: [frontend-design]
  l: |-
  </dna_node>
---

# Google Stitch Logic Bridge

## 1. Protocol: Local -> Stitch Handoff
When translating a mission to Stitch, force the "Hierarchical Prompting" structure:
- 1.1: Core Utility & Purpose
- 1.2: Screen-by-Screen Breakdown
- 1.3: Visual Theme & Aesthetic (Montserrat/Minimalist/Glassmorphic)
- 1.4: Functional Dependencies (OTP, Login, DB Schema)

## 2. Western Design Enforcement (P0)
- Layout: Large White-space, Montserrat/Poppins typography.
- Accessibility: WCAG 2.1 Contrast (4.5:1).
- Components: Priority on Modal Dialogs and Animated Sliders.

## 3. Automation Hook
If `new project` is detected locally, output the formatted 1.1->1.4 text block immediately.
