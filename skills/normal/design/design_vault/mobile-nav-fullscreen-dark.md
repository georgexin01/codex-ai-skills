---
name: mobile-nav-fullscreen-dark
description: "Mobile Navigation — Fullscreen Dark Modal"
triggers: ["mobile nav fullscreen dark", "mobile-nav-fullscreen-dark", "mobile navigation fullscreen"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: mobile-nav-fullscreen-dark
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Mobile Navigation — Fullscreen Dark Modal

Score: 95 (S-CORE) | Source: zeta-website-v4
Description: Premium fullscreen mobile nav with backdrop blur, hamburger→X animation, centered links, WhatsApp CTA footer.
Reuse: Any corporate/dark website. Change: links, brand color, CTA button.

## Customize These
- `.modal-link` items — your page links
- `--color-primary` — your brand accent color
- Footer CTA — your WhatsApp/contact link
- Logo image path

## HTML

```html

<button class="hamburger-btn" id="mobile-toggle">
  <span class="bar"></span>
  <span class="bar"></span>
  <span class="bar"></span>
</button>

<div class="nav-modal-overlay" id="menu-overlay"></div>
<div class="nav-modal" id="mobile-menu">
  <div class="nav-modal-header">
    <a href="/" class="logo"><img src="/logo.png" alt="Logo" style="height:40px" /></a>
    <button class="close-modal" id="menu-close">
      <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
    </button>
  </div>
  <nav class="nav-modal-links">
    <a href="/" class="modal-link">首页</a>
    <a href="/about" class="modal-link">关于我们</a>
    <a href="/services" class="modal-link">服务范围</a>
    <a href="/portfolio" class="modal-link">项目案例</a>
    <a href="/contact" class="modal-link">联系我们</a>
  </nav>
  <div class="nav-modal-footer">
    <p style="margin-bottom:20px;font-family:monospace;color:rgba(255,255,255,0.4);font-size:0.75rem;letter-spacing:0.2em;text-transform:uppercase">YOUR TAGLINE</p>
    <a href="https://wa.me/YOUR_NUMBER" class="nav-modal-cta">
      立即咨询 →
    </a>
  </div>
</div>
```

## CSS

```css
/* Hamburger Button */
.hamburger-btn {
  display: none;
  flex-direction: column;
  justify-content: space-between;
  width: 26px;
  height: 16px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  z-index: 2100;
}
@media (max-width: 768px) {
  .hamburger-btn { display: flex; }
}
.hamburger-btn .bar {
  width: 100%;
  height: 2px;
  background: #fff;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  border-radius: 2px;
}
.hamburger-btn.active .bar:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.hamburger-btn.active .bar:nth-child(2) { opacity: 0; }
.hamburger-btn.active .bar:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

/* Overlay */
.nav-modal-overlay {
  position: fixed; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0, 0, 0, 0.9);
  backdrop-filter: blur(15px);
  z-index: 2050;
  opacity: 0; visibility: hidden;
  transition: opacity 0.4s ease;
}
.nav-modal-overlay.active { opacity: 1; visibility: visible; }

/* Modal */
.nav-modal {
  position: fixed; top: 0; right: 0; width: 100%; height: 100%;
  z-index: 2060; padding: 40px;
  display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center;
  opacity: 0; visibility: hidden; transform: translateX(40px);
  transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
  background: radial-gradient(circle at top right, rgba(230, 30, 30, 0.1), transparent 70%);
}
.nav-modal.active { opacity: 1; visibility: visible; transform: translateX(0); }

.nav-modal-header {
  position: absolute; top: 40px; left: 40px; right: 40px;
  display: flex; justify-content: space-between; align-items: center;
}
.close-modal { background: none; border: none; color: #fff; cursor: pointer; }

.nav-modal-links { display: flex; flex-direction: column; gap: 30px; margin: 40px 0; }
.modal-link {
  font-size: 1.9rem; font-weight: 800; color: #fff;
  text-transform: uppercase; letter-spacing: 2px;
  transition: all 0.4s ease; opacity: 0.7; text-decoration: none;
}
.modal-link:hover { opacity: 1; color: var(--color-primary, #e61e1e); transform: scale(1.05); }

.nav-modal-footer { width: 100%; max-width: 400px; margin-top: 40px; }
.nav-modal-cta {
  display: flex; width: 100%; justify-content: center; padding: 20px;
  background: var(--color-primary, #e61e1e); color: #fff; border-radius: 12px;
  font-weight: 700; text-decoration: none; transition: all 0.3s ease;
}
.nav-modal-cta:hover { filter: brightness(1.1); }
```

## JavaScript

```javascript
const mobileToggle = document.getElementById('mobile-toggle')
const mobileMenu = document.getElementById('mobile-menu')
const menuOverlay = document.getElementById('menu-overlay')
const menuClose = document.getElementById('menu-close')

function toggleModal() {
  mobileToggle.classList.toggle('active')
  mobileMenu.classList.toggle('active')
  menuOverlay.classList.toggle('active')
  document.body.style.overflow = mobileMenu.classList.contains('active') ? 'hidden' : ''
}

mobileToggle?.addEventListener('click', toggleModal)
menuClose?.addEventListener('click', toggleModal)
menuOverlay?.addEventListener('click', toggleModal)

document.querySelectorAll('.modal-link').forEach(link => {
  link.addEventListener('click', (e) => {
    e.preventDefault()
    const href = link.getAttribute('href')
    mobileMenu?.classList.remove('active')
    menuOverlay?.classList.remove('active')
    mobileToggle?.classList.remove('active')
    document.body.style.overflow = ''
    setTimeout(() => { if (href) window.location.href = href }, 200)
  })
})
```

