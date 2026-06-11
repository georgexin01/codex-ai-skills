---
name: ai-studio-bridge
description: "Google AI Studio Vision Bridge (Vision Pulse)"
triggers: ["ai studio bridge", "ai_studio_bridge", "google studio vision"]
phase: reference
model_hint: codex-gpt-5.3
version: 1.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 1.0
  n: ai_studio_bridge
  graph:
    req: [global_rule_map]
    rel: [design-matrix]
  l: |-
  </dna_node>
---

# Google AI Studio Vision Bridge (Vision Pulse)

## 1. Protocol: Vision -> Code Mapping
When analyze user sketches or screenshots (F1), use GEMINI 2.0 PRO logic:
- Step 1: Component Detection (Buttons, Inputs, Cards).
- Step 2: Layer Extraction (Determine Z-Index and Flex-Hierarchy).
- Step 3: Color/Typography Pulse (Sample Hex codes and font families).

## 2. Multimodal Extraction
If the user provides a PDF or Image, force analysis of:
- Interaction Intention (What does the user want this to do?).
- Design Pattern (Is it Material Design? Apple Hig? 欧美 Standard?).

## 3. Automation Hook
Output a Structured JSON format for AI Studio handoff: `{"vision": "pulse", "components": [], "style": {}}`.
