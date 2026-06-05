---
name: phone-showcase-sticky
description: "Phone Showcase — Sticky Scroll with Project Slider"
triggers: ["phone showcase sticky", "phone-showcase-sticky"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: phone-showcase-sticky
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Phone Showcase — Sticky Scroll with Project Slider

Score: 95 (S-CORE) | Source: zeta-website-v4
Description: Realistic iPhone-style phone frame with screen images that change on scroll (GSAP ScrollTrigger). Sticky on desktop, centered on mobile. Physical button details, camera dot, reflection overlay.
Reuse: Portfolio/corporate sites, app showcase pages. Change: images, visit URLs.

## Customize These
- Phone screen images (`.phone-screen img`)
- `data-url` on images for "visit project" badge
- Phone dimensions (310x640 desktop, 275x572 mobile)
- Showcase item content (text next to phone)

## HTML

```html
<div class="sticky-phone-wrapper">
  <div class="sticky-phone">
    
    <button class="phone-nav-btn prev-btn" aria-label="Previous">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m15 18-6-6 6-6"/></svg>
    </button>
    <button class="phone-nav-btn next-btn" aria-label="Next">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
    </button>

    
    <div class="phone-physical-btn" style="left:-4px;top:120px;height:30px"></div>
    <div class="phone-physical-btn" style="left:-4px;top:170px;height:50px"></div>
    <div class="phone-physical-btn" style="left:-4px;top:230px;height:50px"></div>
    <div class="phone-physical-btn" style="right:-4px;top:190px;height:70px"></div>

    <div class="phone-screen">
      <div class="phone-camera"></div>
      <div class="reflection-overlay"></div>
      
      <img src="/images/screen-1.png" alt="Project 1" class="active" data-id="0" />
      <img src="/images/screen-2.png" alt="Project 2" data-id="1" data-url="https://example.com" />
      <img src="/images/screen-3.png" alt="Project 3" data-id="2" data-url="https://example2.com" />
      <a href="#" target="_blank" class="visit-badge" id="visit-badge" style="display:none">访问项目</a>
    </div>
  </div>
</div>
```

## CSS

```css
.sticky-phone-wrapper {
  position: sticky; top: 15vh; height: 70vh;
  display: flex; align-items: center; justify-content: center;
  padding-top: 80px;
}
.sticky-phone {
  width: 310px; height: 640px;
  background: #000; border: 4px solid #1a1a1a; border-radius: 48px;
  position: relative;
  box-shadow: 0 1px 10px rgba(0,0,0,0.2);
  transition: transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}
.phone-screen {
  position: absolute; top: 2px; left: 2px; right: 2px; bottom: 2px;
  border-radius: 46px; overflow: hidden; background: #000; z-index: 1;
}
.phone-screen img {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%;
  object-fit: cover; opacity: 0; transition: opacity 0.6s ease;
}
.phone-screen img.active { opacity: 1; }
.phone-camera {
  position: absolute; top: 12px; left: 50%; transform: translateX(-50%);
  width: 12px; height: 12px; background: #0a0a0a;
  border: 1px solid rgba(255,255,255,0.1); border-radius: 50%; z-index: 110;
}
.reflection-overlay {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%;
  background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, transparent 50%, rgba(255,255,255,0.02) 100%);
  pointer-events: none; z-index: 10;
}
.phone-physical-btn {
  position: absolute; width: 4px;
  background: linear-gradient(to bottom, #222, #111); border-radius: 2px;
}
.phone-nav-btn {
  position: absolute; top: 50%; z-index: 100;
  width: 44px; height: 44px; border-radius: 50%;
  background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2);
  backdrop-filter: blur(10px); color: #fff;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; transition: all 0.3s ease;
}
.phone-nav-btn:hover { background: rgba(255,255,255,0.2); }
.phone-nav-btn.prev-btn { left: -25px; transform: translateY(-50%); }
.phone-nav-btn.next-btn { right: -25px; transform: translateY(-50%); }
.visit-badge {
  position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%);
  background: var(--color-primary, #e61e1e); color: #fff;
  padding: 8px 20px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;
  z-index: 20; text-decoration: none;
}

/* Mobile */
@media (max-width: 991px) {
  .sticky-phone-wrapper { position: relative; height: auto; padding-top: 40px; }
  .sticky-phone { width: 275px !important; height: 572px !important; margin: 20px auto; }
}
```

## JavaScript (GSAP ScrollTrigger)

```javascript
const phoneImages = document.querySelectorAll('.phone-screen img')
let currentSlide = 0

function updatePhone(index) {
  phoneImages.forEach((img, i) => {
    img.classList.toggle('active', i === index)
  })
  currentSlide = index
}

// Auto-slide every 4s
let autoSlide = setInterval(() => {
  currentSlide = (currentSlide + 1) % phoneImages.length
  updatePhone(currentSlide)
}, 4000)

// Nav buttons
document.querySelector('.prev-btn')?.addEventListener('click', () => {
  clearInterval(autoSlide)
  updatePhone((currentSlide - 1 + phoneImages.length) % phoneImages.length)
})
document.querySelector('.next-btn')?.addEventListener('click', () => {
  clearInterval(autoSlide)
  updatePhone((currentSlide + 1) % phoneImages.length)
})
```

