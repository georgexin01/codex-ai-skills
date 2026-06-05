---
name: interactive-ui-bridge
description: "Interactive UI Hyper-Protocol"
triggers: ["interactive ui bridge", "interactive_ui_bridge", "interactive hyper"]
phase: reference
model_hint: codex-gpt-5.3
version: 1.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 1.0
  n: interactive_ui_bridge
  graph:
    req: [dna_global]
    rel: []
  l: |-
  </dna_node>
---

# Interactive UI Hyper-Protocol

## 1. Goal
Minimize user fatigue by providing "one-click" response options within the chat interface.

## 2. Formatting Standards
Always format [a], [b], and [c] options as clickable Markdown Links (Buttons):
- Standard Format: `[ [Option Identifier] Option Label ](#)`
- Example: `[ [a] Yes, Proceed ](#)`

## 3. Usage Rules
- Apply to all binary or multi-choice questions.
- Avoid verbose explanations within the buttons; keep it concise (1-5 words).
- Use high-density summaries for the options to save horizontal space.

## 4. UI Fallback
If the host environment does not support link-clicking, the format remains highly readable and distinct for manual typing.
