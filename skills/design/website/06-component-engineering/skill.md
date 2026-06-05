---
name: 06-component-engineering
description: "High-Density Component Engineering: Designing modular car cards, glass panels, and interactive grids with focus on 3D depth and tactile feedback."
step: 6
version: 1.0
---

# 💎 [06] Component Engineering — The Tactile Engine

> [!NOTE]
> **TIER-0 COMPLIANCE**: Follow the 8pt Grid, 6px Precision, and `active:scale-95` feedback rules defined in the **[Sovereign Website Introduction](../SKILL.md)**.

## 🎯 Objective
To build UI components that feel "Solid" and "High-End".

## 📖 Execution Guide
1.  **The "Premium Glass" Standard**:
    - Background: `rgba(255, 255, 255, 0.05)`.
    - Blur: `20px`.
    - Border: `1px solid rgba(255, 255, 255, 0.1)`.
    - Shadow: `0 8px 32px 0 rgba(0, 0, 0, 0.37)`.
2.  **3D Depth & Elevation**:
    - Use `:hover` states to elevate components (`transform: translateY(-5px)`).
    - Increase shadow intensity on hover for a "lifting" effect.
3.  **Grid Systems**:
    - Use `display: grid` or `flex` with consistent gaps (e.g., `gap: 30px`).
    - Ensure cards in a grid have uniform height and spacing.

## 📦 Code Vault: The Premium Car Card

```html
<article class="premium-card premium-glass overflow-hidden">
    <div class="card-image relative">
        <img src="/images/car.jpg" class="w-full h-250 object-cover" loading="lazy">
        <div class="card-badge absolute top-20 right-20 bg-primary px-15 py-5 rounded-10 text-white fs-12 fw-7">
            Verified
        </div>
    </div>
    <div class="card-content p-25">
        <h4 class="text-white fs-22 fw-8">Honda Civic RS</h4>
        <p class="text-white opacity-60 fs-14 mt-5">2023 • 5,000 km • Automatic</p>
        
        <div class="flex justify-between align-center mt-20">
            <span class="fs-24 fw-8 text-primary">RM 92,800</span>
            <a href="/car/1" class="btn-premium py-10 px-20 fs-14">View Details</a>
        </div>
    </div>
</article>
```

### 📦 Code Vault: The Industrial Award Row

```html
<div class="award-item-row" style="display: flex; align-items: flex-start; border-bottom: 1px solid rgba(0,0,0,0.06); padding: 50px 0;">
    <div class="award-year-col" style="flex: 0 0 180px; font-size: 18px; font-weight: 500; color: #666;">2024</div>
    <div class="award-info-col" style="flex: 1; display: flex; flex-direction: column;">
        <p class="award-org-text" style="font-size: 16px; font-weight: 700; color: #111;">Toronto Design Community</p>
        <h4 class="award-name-text" style="font-size: 68px; font-weight: 800; background: linear-gradient(135deg, #c08c50 0%, #91602b 100%); -webkit-background-clip: text; color: transparent;">3D Building Material Workflow</h4>
    </div>
    <div class="award-image-col" style="flex: 0 0 260px;">
        <div class="award-thumb-frame" style="border-left: 6px solid #91602b; overflow: hidden;">
            <img src="/uploads/award.png" style="width: 100%; height: 160px; object-fit: cover;">
        </div>
    </div>
</div>
```

### 📦 Code Vault: The High-Fidelity Studio Card

```html
<a class="blog-card" href="/blogs/slug" style="display: flex; flex-direction: column; background: #fff; border-radius: 4px; overflow: hidden; text-decoration: none;">
    <div class="blog-card-image" style="position: relative; aspect-ratio: 16 / 10;">
        <img src="/hero.jpg" style="width: 100%; height: 100%; object-fit: cover;">
        <span class="blog-card-cat" style="position: absolute; top: 16px; left: 16px; background: #111; color: #fff; font-size: 0.7rem; font-weight: 700; padding: 6px 12px; text-transform: uppercase;">WORKFLOW</span>
    </div>
    <div class="blog-card-body" style="padding: 28px;">
        <div class="blog-card-meta" style="font-size: 0.78rem; color: #777;">
            <span>MAY 2026</span> <span class="dot">·</span> <span>5 MIN READ</span>
        </div>
        <h3 class="blog-card-title" style="font-size: 1.4rem; font-weight: 800; color: #111;">Building the Design-Build Bridge</h3>
        <p class="blog-card-excerpt" style="font-size: 0.95rem; line-height: 1.6; color: #555;">Detailed field notes on SketchUp, D5 Render, and material specification.</p>
        <span class="blog-card-link" style="color: #098178; font-weight: 700; text-transform: uppercase; font-size: 0.85rem;">Read article &rarr;</span>
    </div>
</a>
```

## 🛠️ Validation Checklist
- [ ] Do glass panels have `backdrop-filter`?
- [ ] Is there tactile feedback (`active:scale-95`) on buttons?
- [ ] Do cards have consistent shadows and border-radius (20px)?
- [ ] Is the spacing (`padding`/`margin`) consistent across components?

---
*Premium Design Node 06 — Component Engineering*
