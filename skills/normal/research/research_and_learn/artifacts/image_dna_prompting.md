---
name: image-dna-prompting
description: "Image & Project DNA Prompting Methodology (Gemini Nano Message)"
triggers: ["image dna prompting", "image_dna_prompting", "image project prompting"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: image_dna_prompting
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Image & Project DNA Prompting Methodology (Gemini Nano Message)

This guide documents the Image DNA and Project DNA extraction logic for achieving 100% control over design systems and asset generation.

## 1. Extracting Metadata DNA
Instead of general image descriptions, you extract the technical "Metadata DNA" into a structured JSON schema.

### Metadata Extraction Prompt:
"Analyze this image and extract all technical and visual metadata into a structured JSON schema. Include objects, style, colors, lighting, composition, and optics (lens/angle)."

### JSON Structure Example
The DNA usually follows this logic:
```json
{
  "subject": {
    "description": "Person eating pizza",
    "details": {
      "hair": "brown",
      "outfit": "red hoodie"
    }
  },
  "style": {
    "type": "Hyper-realistic photography",
    "color_palette": ["warm", "orange", "deep-brown"],
    "lighting": "Natural sunset light, rim lighting"
  },
  "technical": {
    "camera": "Sony A7R IV",
    "lens": "35mm f/1.4",
    "depthoffield": "shallow",
    "focus": "sharp on eyes"
  }
}
```

## 2. Surgical Metadata Editing
Once you have the JSON metadata map, you can modify it with total surgical precision.

### Targeted Modification Workflow:
1. Target Key: Identify the field to change (e.g., `lighting.sources`).
2. Surgical Command: Prompt the AI: 
"Update the JSON metadata of this image; Change the key `lighting.sources` to 'Neon Red' but keep all other technical keys unchanged: [Paste JSON]."

## 3. High-Fidelity Technical Prompts
To extract the *photography style* alone for use as a template:

Style Extraction Prompt:
"Describe the photography techniques, optics, and lighting in this image in JSON format. Do not include the subject."

### Use as a Template:
"Generate a photo of a futuristic astronaut using this photography style JSON: [Paste Technical JSON]"

## 4. Consistent Characters and Faces
To maintain character consistency across different scenes:
1. Extract the character's physical DNA from a base image.
2. Use that JSON block in every future prompt.
3. Only modify the `context`, `pose`, and `location` fields in the JSON.

---

## 🏗️ 5. Project DNA (The DESIGN.yaml Concept)
For large-scale projects, Image DNA is scaled into a Project DNA file, commonly named `DESIGN.yaml`. This serves as the Single Source of Truth.

### File Structure:
- Style Archetype: The high-level aesthetic (e.g., "Futuristic Cyberpunk").
- Asset DNA: Reusable prompts for all images in the project.
- Color Calibration: Specific HEX codes and palette rules.
- Component Rules: How UI elements (buttons, cards) should look.

## 🍌 6. Nano Banana (Asset Logic)
Nano Banana is the methodology for generating assets that are "perfectly fitted" to a project's UI.

### Logic:
1. Context Check: Read the component's purpose (e.g., "Hero Section of a Tech Landing Page").
2. DNA Inject: Pull the project's visual style from `DESIGN.yaml`.
3. Generation: Prompt the AI: "Generate a [component-specific asset] using the [Project DNA] rules: [Paste DNA Block]".
4. Placement: The asset is automatically injected into the React/HTML code at the correct location.

---

[!TIP]
This "Nano Message" approach works best when you provide the AI with a starting JSON structure rather than a long paragraph of text. It forces the model to respect specific technical constraints.

