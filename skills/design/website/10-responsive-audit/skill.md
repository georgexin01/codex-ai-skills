---
name: 10-responsive-audit
description: "Mobile-First Responsive Audit: Refining the layout for touch devices. Optimizing typography, padding, and glassmorphism performance on mobile."
step: 10
version: 1.0
---

# 📱 [10] Responsive Audit — The Touch-First Refine

## 🎯 Objective
To ensure the "WOW" factor translates perfectly to mobile screens. 70% of car buyers browse on their phones; the UI must be legible, fast, and easy to navigate with one hand.

## 📖 The Protocol
1.  **Breakpoint Hardening**:
    - Use `@media` queries in `custom.css` to adjust layouts for Desktop (>991px), Tablet (768px-991px), and Mobile (<768px).
2.  **Typography Scaling**:
    - Reduce massive hero fonts (e.g., `fs-60` to `fs-36` on mobile).
    - Ensure readability of body text (minimum 16px).
3.  **Touch Target Optimization**:
    - Ensure buttons have a minimum height of 48px.
    - Add padding to form inputs for fat-finger friendliness.
4.  **Glass Performance**:
    - Reduce `blur` radius if scrolling becomes choppy on low-end mobile devices.
    - Ensure `backdrop-filter` has `-webkit-` prefix for iOS Safari support.

## 📦 Code Vault: Responsive Refinement Snippets

### 🛠️ Mobile Overrides (`custom.css`)
```css
@media (max-width: 767px) {
    /* Stack grid columns */
    .row > [class*="col-"] {
        width: 100%;
        margin-bottom: 20px;
    }

    /* Reduce Hero Height */
    .hero-cinematic {
        min-height: 400px;
    }

    /* Adjust Glass Padding */
    .premium-glass {
        padding: 20px !important;
    }

    /* Mobile Text Scaling */
    .fs-80 { font-size: 32px !important; }
}
```

## 🛠️ Validation Checklist
- [ ] Is the horizontal scroll bar gone on mobile?
- [ ] Are buttons easy to tap (no overlap)?
- [ ] Does the menu open and close smoothly on touch?
- [ ] Is the hero image optimized for portrait aspect ratios?

---
*Premium Design Node 10 — Responsive Audit*
