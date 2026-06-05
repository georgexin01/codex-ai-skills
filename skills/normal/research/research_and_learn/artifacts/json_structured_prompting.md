---
name: json-structured-prompting
description: "JSON-Structured Prompting: Surgical Mapping Mastery"
triggers: ["json structured prompting", "json_structured_prompting"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: json_structured_prompting
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# JSON-Structured Prompting: Surgical Mapping Mastery

This guide documents the Surgical Metadata Mapping protocol, a system designed to gain 100% control over AI image analysis, editing, and generation by replacing vague text prompts with machine-readable JSON maps.

---

## 🧩 1. The Metadata Mapping Protocol
Instead of describing an image, you prompt the AI to extract its complete technical "DNA" as a structured JSON object.

### Extraction Prompt:
"Analyze this image and extract all technical and visual metadata into a structured JSON schema. Include objects, style, colors, lighting, composition, and optics (lens/angle)."

### Resulting Schema (Example):
```json
{
  "file_info": {
    "dimensions": "1024x1024",
    "style": "Cinematic Hyper-realism"
  },
  "objects": {
    "main_subject": "Robotic Bear",
    "environment": "Brutalist Terminal",
    "props": ["Holographic interfaces", "Volumetric fog"]
  },
  "lighting": {
    "type": "Low-key",
    "sources": ["Neon Cyan Rim", "Purple Keylight"],
    "shadows": "Deep and soft"
  },
  "technical": {
    "camera": "Sony A7R IV (Simulated)",
    "lens": "35mm f/1.4",
    "focus": "Sharp on eyes"
  }
}
```

---

## ⚡ 2. Targeted Asset Modification (Surgical Edits)
Once you have the JSON map, you can modify specific elements with total precision. This eliminates the "randomness" of typical AI generation.

### The "Surgical" Workflow:
1. Extract: Get the JSON baseline.
2. Modify Path: Identify the specific key to change (e.g., `objects.main_subject`).
3. Re-Generate: Prompt the AI: 
"Update the JSON map of this image: Change `main_subject` to 'Golden Lion' but keep all other `lighting` and `technical` keys exactly the same: [Paste JSON]."

---

## 📸 3. Photography Learning Mode
This technique allows you to deconstruct a professional photo (e.g., a style you want to mimic) and use its "Technical DNA" as a template for other subjects.

### Logic:
1. Extract only the `lighting`, `technical`, and `style` keys from a high-quality reference image.
2. Create a "Technical Template" JSON block.
3. Prompt: "Generate a photo of [New Subject] using this Technical Template JSON: [Paste Technical JSON]."

---

## 🍌 4. Consistency via Nano Banana
By using JSON as the "Project DNA" (Single Source of Truth), you ensure that different models (e.g., Gemini 2.0 and Nano Banana) interpret the vision with 100% consistency.

---

[!TIP]
Learning Source: [Total Control: Why I Prompt Gemini with JSON](https://www.youtube.com/watch?v=gcXPW6eBB0w)
Protocol: Research and Learn V3.0 (Surgical Mapping)

