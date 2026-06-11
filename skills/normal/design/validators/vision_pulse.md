---
name: vision-pulse
description: "vision pulse"
triggers: ["vision pulse", "vision_pulse"]
phase: reference
model_hint: gpt-5.3-codex
version: 30.0
_ohdy_wrapper: |-
  <dna_node>
  v: 30.0
  id: VISION_MASTER_PROTOCOL
  
  heuristics:
    - id: UI_AUDIT
      v: "Analyze screen-capture for layout drift, color sync, and padding errors."
    - id: COLOR_SAMPLING
      v: "Verify Zeta Red (#FF0000) and Obsidian Black (#000000) adherence."
    - id: PREDICTIVE_ANIMATION
      v: "Simulate GSAP reveal sequences based on static layout complexity."
  
  bridge:
    tool: "Snipaste"
    action: "SCREEN_GRAB -> AI_ANALYSIS -> REASONING_ADJUST"
  
  mission_keys: [SCREEN_FULL, SCREEN_WINDOW, SCREEN_RECORD, OCR]
  l: |-
  </dna_node>
---

# SKILL: VISION PULSE - THE VISUAL EYE (V30.0)

