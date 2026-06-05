---
name: 12-performance-tuning
description: "High-Performance Optimization: Image lazy loading, CSS minification, and Google PageSpeed readiness. Ensuring the premium design is lightning fast."
step: 12
version: 1.0
---

# 🚀 [12] Performance Tuning — The Speed Hardening

## 🎯 Objective
To ensure the "WOW" design doesn't slow down the user experience. A premium site must load instantly. We optimize assets and delivery scripts for maximum speed.

## 📖 The Protocol
1.  **Image Optimization**:
    - Add `loading="lazy"` to all non-hero images.
    - Ensure images have `width` and `height` attributes to prevent Layout Shift (CLS).
    - Convert assets to WebP format where possible.
2.  **CSS/JS Hygiene**:
    - Move critical CSS to the `<head>`.
    - Defer non-critical scripts (e.g., chat widgets, tracking) to the `htmlFoot.php`.
    - Clean up unused CSS rules from the large `styles.css`.
3.  **Caching & Buffering**:
    - Implement PHP output buffering if data processing is complex.
    - Use browser caching headers.
4.  **Font Performance**:
    - Use `font-display: swap` for Google Fonts to prevent invisible text during load.

## 📦 Code Vault: Performance Snippets

### 🛠️ Optimization Checklist (`lib/htmlFoot.php`)
```html
<!-- Defer scripts for speed -->
<script src="/js/jquery.min.js"></script>
<script src="/js/bootstrap.min.js" defer></script>
<script src="/js/custom.js" defer></script>

<!-- Lazy loading utility -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        let lazyImages = [].slice.call(document.querySelectorAll("img.lazy"));
        // Implementation for older browsers fallback...
    });
</script>
```

## 🛠️ Validation Checklist
- [ ] Do images have `loading="lazy"`?
- [ ] Is Cumulative Layout Shift (CLS) minimized?
- [ ] Are scripts deferred or loaded at the end?
- [ ] Is the page weight below 2MB for the first load?

---
*Premium Design Node 12 — Performance Tuning*
