---
name: 02-asset-orchestration
description: "V1.0 Asset Orchestration: Nano Banana 2 image generation and high-fidelity icon sourcing."
step: 2
version: 1.0
---

# ✨ [02] Asset Orchestration — The Sovereign App Protocol

## 🎯 Objective
To eliminate generic placeholders by generating cinematic product/profile imagery and sourcing premium icons.

## 🎨 Asset Guidelines
1.  **Product Imagery**: Use `generate_image` for specific hardware accessories (e.g., "Cinematic shot of a high-end car engine block on a white background").
2.  **Rider Avatars**: Generate professional, diverse rider portraits.
3.  **Iconography**: Use `lucide-vue-next` with consistent stroke weights (2px) and specific accent colors (Light Blue/Pink).

## 📦 Code Vault: Nano Banana 2 Prompts
```text
[Rider App Hero]
Cinematic high-angle shot of a courier in a clean blue vest standing next to a delivery bike, white modern background, bright morning lighting, 8k, professional.

[Hardware Accessory]
Close-up of a premium chrome car air intake part, studio lighting, white minimalist background, soft shadows, sharp focus, 8k.
```

---
*Premium App Design Node 02 — V1.0 Asset Orchestration*

## Free Image Sourcing Fallback

If Nano Banana, OpenAI Images, or another image generator is unavailable, switch to:

`C:\Users\user\.codex\skills\normal\design\FREE_VISUAL_ASSET_SOURCING.md`

App implementation rules:

1. Use free stock images for realistic hero/cards/profile/product scenes when appropriate.
2. Use Material Symbols, lucide icons, inline SVG, gradients, and CSS illustration for app chrome, navigation, empty states, and feature icons.
3. Store prototype images in `public/images/`, `src/assets/`, or `uploads/generated/` and keep stable dimensions/aspect ratios.
4. Keep source/license notes in `src/assets/IMAGE_SOURCES.md`, `public/images/IMAGE_SOURCES.md`, or the project blueprint.
5. Never leave broken image icons; always include an AppImage/fallback component or CSS/SVG placeholder.
