---
name: 08-asset-orchestration
description: "V1.0 Asset Management: High-fidelity photography, icon standardization, and path resolution."
step: 8
version: 1.0
---

# 🖼️ [08] Asset Orchestration — The Sovereign App Protocol

## 🎯 Objective
To ensure zero-error asset resolution and high-fidelity visual storytelling using professional imagery.

## 📁 Directory Structure
All static assets MUST reside in `/public/` at the root of each app:
- `/public/rider-avatar.png`: High-density professional headshot.
- `/public/engine-part.png`: Industrial logistics fulfillment reference image.
- `/public/favicon.svg`: Brand initials + primary color.

## 🎨 Icon Protocol (Lucide)
- **Stroke Width**: 2.5px (Industrial) or 3px (Ultra-High Density).
- **Sizing**: `size-7` (28px) for Footer, `size-5` (20px) for inner cards.
- **Color**: `text-primary` for active, `text-ink-faint/30` for inactive.

## 📸 Image Guidelines
1.  **Fulfillment Proofs**: Use 16:10 aspect ratio with `object-cover`.
2.  **Avatar Frames**: Use `rounded-[20px]` (half of card radius) with 2px border.
3.  **Placeholders**: Always use `generate_image` to create realistic thematic assets, never generic placeholders.

---
*Premium App Design Node 07 — V1.0 Asset Orchestration*
