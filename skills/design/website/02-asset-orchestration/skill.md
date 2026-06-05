---
name: 02-asset-orchestration
description: "V2.0 Asset & Motion Pipeline: Orchestrating the sourcing of Cinematic Video Loops and High-Motion backgrounds. No placeholders allowed."
step: 2
version: 2.0
---

# ✨ [02] Asset & Motion Orchestration — The V2.0 Pipeline

## 🎯 Objective
To eliminate static placeholders and transition into **Motion-Driven Visuals**. This step governs how we find, describe, and integrate looping background videos and high-fidelity assets.

## 📖 The V2.0 Motion Protocol
1.  **Motion Sourcing Strategy**:
    - AI Agent must provide specific "Prompt Blueprints" for external video tools (V3, CEDANCE, Pika, Runway).
    - **Loop Prompt**: `Cinematic, professional [SUBJECT], minimalist [SETTING], soft [COLOR] lighting, SEAMLESS LOOP, NO CAMERA MOVEMENT, NO ZOOM.`
2.  **Compositional Sourcing (The Safe Zone Rule)**:
    - Request assets that have "Compositional Negative Space" (e.g., the subject is on the right, leaving the left side "quiet" for text).
    - If using Nano Banana 2 (Images), ask for `16:9` expansion with "blurred peripheral details".
3.  **Video Hosting & Delivery**:
    - AI should advise the user to host `.mp4` files on high-speed CDN/platforms to ensure zero-latency background playback.
    - Always request a `poster` image (static still) for the initial load.
4.  **Token Extraction & Texture Strategy**:
    - Sync CSS HSL tokens with the dominant "Light Source" in the video.
    - **Sovereign Gold Gradient**: Use `linear-gradient(135deg, #c08c50 0%, #91602b 30%, #5a3d1a 65%, #2a1d0c 100%)`.
    - **Industrial Tactile Rule**: Always use a linen or canvas texture (`bg-1.jpg`) on warm-toned pages to add physical depth. No plain flat #fff sections.

## 📦 Code Vault: V2.0 Motion Sourcing Prompts

### 🛠️ "Tech/Luxury" Background Prompt
```text
Looping animation of abstract flowing dark silk, deep blue HSL lighting, safe zone on the left for text, high-end automotive brand vibe, 4k, seamless loop.
```

### 🛠️ "Mechanical" Background Prompt
```text
Slow-motion looping shot of a high-end car engine part, shallow depth of field, blurred background, safe zone at the bottom, charcoal and orange lighting, 8k.
```

## 🛠️ Validation Checklist
- [ ] Is there a direct link to a looping video?
- [ ] Does the asset have a "Safe Zone" for kinetic typography?
- [ ] Is a `poster` image available for the loading state?
- [ ] Are the prompt blueprints specific about "Seamless Loops"?

---
*Premium Design Node 02 — V2.0 Asset & Motion Pipeline*

## Free Image Sourcing Fallback

If `generate_image`, Nano Banana, OpenAI Images, or another paid image API is unavailable, blocked, or not connected, switch to the free visual asset workflow:

`C:\Users\user\.codex\skills\normal\design\FREE_VISUAL_ASSET_SOURCING.md`

Website implementation rules:

1. Use Unsplash/Pexels/Pixabay for prototype real-world photography only after checking the license/source page.
2. Download reusable assets into the project (`uploads/generated/hero`, `uploads/generated/masonry`, `uploads/generated/gallery`, `uploads/generated/blueprint`) when a PHP website needs stable production paths.
3. For large catalogs, source 8-20 strong images and reuse them cyclically; do not require one image per item.
4. Use Material Symbols or inline SVG for amenities, transport, commerce, account, and action icons.
5. Add lazy loading, `decoding="async"`, `object-fit: cover`, stable aspect ratios, and CSS/SVG fallbacks.
6. Record source URL, license URL, search query, and date in `IMAGE_SOURCES.md` or `BLUEPRINT.md`.
