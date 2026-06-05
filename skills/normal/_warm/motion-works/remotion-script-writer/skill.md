---
name: remotion-script-writer
description: "Remotion Script Writer Skill (Kit 2.0)"
triggers: ["remotion", "video script", "motion works", "video writing", "remotion script writer"]
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

# Remotion Script Writer Skill (Kit 2.0)

This skill enables Antigravity to analyze existing website code and suggest specific "Motion Points" for kinetic enhancements.

## Scripting Capabilities
- Transition Suggestions: Find where page segments transition and recommend smooth fade, slide, or 3D rotations.
- Kinetic Typography: Identify bold headings and suggest "Scramble", "Blur-In", or "Typewriter" animations.
- Reveal Logic: Suggest reveal animations using `IntersectionObserver` or GSAP's `ScrollTrigger`.

## Logic Flow
1. Analyze Index.html: Identify main sections and interactive elements.
2. Propose Scene: Create a Remotion-style logic for each section (e.g. "Section Reveal Scene 1").
3. Execute Code: Write the corresponding CSS/JS for the website.

## Integration Hooks
- Use `gsap` for real-time web reveals.
- Use `remotion-rendered` MP4s for high-fidelity backgrounds.

