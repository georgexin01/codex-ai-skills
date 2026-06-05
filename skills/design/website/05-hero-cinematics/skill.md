---
name: 05-hero-cinematics
description: "V2.0 Video-First Hero Foundry: Implementing pure video backgrounds, No-Overlay readability, and Compositional Safe Zones for Kinetic Typography."
step: 5
version: 2.0
---

# 🎬 [05] Hero Cinematics — V2.0 Video-First Protocol

> [!NOTE]
> **TIER-0 COMPLIANCE**: Ensure you have read the **[Sovereign Website Introduction](../SKILL.md)** before proceeding.

## 🎯 Objective
To create a "High-End" entry experience that utilizes **Cinematic Video Loops** as the primary visual driver.

## 📖 Execution Guide
1.  **Readability through Composition (Safe Zones)**:
    - Identify the **"Safe Zone"** in the video (areas with low activity or blurred details).
    - Anchor your **Kinetic Typography** specifically in these zones using `flex` or `grid`.
2.  **Surgical Readability (Backdrop Blur)**:
    - If the video occasionally clashes with text, apply `backdrop-filter: blur(10px)` **only** to the container immediately behind the text.
    - Use a soft `text-shadow` to lift letters off the motion.
3.  **Kinetic Typography Execution**:
    - Headline: `fs-120` to `fs-150`, `letter-spacing: -0.04em`, `line-height: 0.9`.
    - Content: 1-2 words max. Use a premium Serif for a "Viral" agency look.

## 📦 Code Vault: V2.0 Pure Video Hero

```html
<!-- [05] V2.0 Pure Video Hero -->
<section class="hero-v2 relative vh-100 overflow-hidden bg-black">
    <!-- 100% Opacity Video Layer -->
    <div class="hero-media absolute inset-0">
        <video autoplay muted loop playsinline class="w-full h-full object-cover">
            <source src="URL_TO_DIRECT_VIDEO.mp4" type="video/mp4">
        </video>
        <!-- Poster for loading state -->
        <div class="poster absolute inset-0 bg-cover bg-center" style="background-image: url('POSTER_STILL.jpg');"></div>
    </div>

    <!-- Kinetic Content in "Safe Zone" -->
    <div class="container relative z-10 h-full flex align-end pb-100">
        <div class="safe-zone-content p-40 rounded-30">
            <!-- Surgical Blur only behind text if needed -->
            <style>.safe-zone-content { backdrop-filter: blur(8px); }</style>
            
            <h1 class="text-white fs-150 fw-9 lh-09 ls-n4 animate-fade-up">
                <span class="font-serif italic text-primary">Absolute</span><br>
                DRIVE.
            </h1>
        </div>
    </div>
</section>

<style>
.ls-n4 { letter-spacing: -0.04em; }
.lh-09 { line-height: 0.9; }
.font-serif { font-family: 'Instrumental Serif', serif; }
</style>
```

## 🛠️ Validation Checklist
- [ ] Is the video background at 100% opacity?
- [ ] Is text placed in a "Safe Zone" of the composition?
- [ ] Is the headline `150px` or larger?
- [ ] Did you use `backdrop-filter` or `text-shadow` instead of a full overlay?

---
*Premium Design Node 05 — V2.0 Hero Cinematics*
