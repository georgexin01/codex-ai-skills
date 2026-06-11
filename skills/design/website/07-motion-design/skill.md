---
name: 07-motion-design
description: "V2.0 Sovereign Motion Protocol: Advanced scroll-triggered popups, interactive image menus, and liquid transitions."
step: 7
version: 2.0
---

# 🌊 [07] Motion Design — V2.0 Interactive Life

## 🎯 Objective
To make the website "Scrollable Art". In V2.0, we use the scroll position to trigger interactive menus and image-text pairings that feel like a professional agency-built experience.

## 📖 The V2.0 Protocol
1.  **Scroll-Triggered Image Popups**:
    - As the user scrolls, images should "Pop" into view with associated text.
    - Keep the text to the right/left of the image to create a "Product Showcase" feel.
2.  **The Interactive "Pill" Menu**:
    - A floating menu that opens on scroll and contains high-density content.
    - Transitions must be "Liquid"—using `cubic-bezier(0.165, 0.84, 0.44, 1)` for that snappy yet smooth feel.
3.  **Kinetic Scrolling**:
    - Ensure elements move at slightly different speeds (Parallax Lite) to create depth.
4.  **GSAP ScrollTrigger**:
    - For high-end missions, use GSAP `ScrollTrigger` to pin sections or animate typography letter-by-letter as the user scrolls.

## 📦 Code Vault: V2.0 Scroll Interactions

### 🧠 Interactive Image-Text Popup (CSS/JS)
```html
<section class="scroll-showcase py-100 bg-black">
    <div class="container">
        <div class="reveal-item flex align-center gap-50 mb-100 animate-fade-up">
            <div class="image-box w-50 overflow-hidden rounded-20">
                <img src="CAR_IMAGE.jpg" class="w-full hover-scale">
            </div>
            <div class="text-box w-50">
                <h2 class="text-white fs-48 fw-8">The Performance.</h2>
                <p class="text-white opacity-60 fs-18">A 175-point inspection ensures absolute mechanical purity.</p>
            </div>
        </div>
    </div>
</section>

<style>
.hover-scale {
    transition: transform 0.8s cubic-bezier(0.165, 0.84, 0.44, 1);
}
.reveal-item:hover .hover-scale {
    transform: scale(1.1);
}
</style>
```

## 🛠️ Validation Checklist
- [ ] Do images reveal themselves on scroll?
- [ ] Is the transition "Liquid" (Smooth and Snappy)?
- [ ] Is there a clear connection between the image and the side-text?
- [ ] Does the menu respond to scroll position?

---
*Premium Design Node 07 — V2.0 Motion Design*
