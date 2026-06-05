---
name: micro-interactions
description: "Micro-Interaction Vault — Animations, Hovers, Transitions"
triggers: ["micro interactions", "micro-interactions", "micro interaction vault"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: micro-interactions
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Micro-Interaction Vault — Animations, Hovers, Transitions

Purpose: Small but premium-feeling interactions. Copy-paste into any project.
Rule: These make "good" design feel "premium". AI should apply 3-5 per page minimum.
Score: All items here are 85+ (A-STARRED or S-CORE)

---

## 1. BUTTON INTERACTIONS

```css
/* Press feedback — USE ON ALL BUTTONS */
.btn { @apply active:scale-[0.97] transition-all; }

/* Press feedback (stronger, for icon buttons) */
.btn-icon { @apply active:scale-90 transition-all; }

/* Hover lift */
.btn-hover-lift { @apply hover:-translate-y-0.5 hover:shadow-lg transition-all; }
```

## 2. CARD INTERACTIONS

```css
/* Card press (for clickable cards) */
.card-press { @apply active:scale-[0.98] transition-all cursor-pointer; }

/* Card hover glow */
.card-hover { @apply hover:shadow-lg hover:border-primary-200 transition-all; }

/* Card hover slide-up reveal (for hidden chevron/arrow) */
.card-reveal {
  @apply translate-x-10 opacity-0 group-hover:translate-x-0 group-hover:opacity-100 transition-all;
}
```

## 3. PAGE TRANSITIONS (Vue)

```css
/* Fade (for route transitions) */
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* Slide up (for modals, bottom sheets) */
.slide-up-enter-active, .slide-up-leave-active { transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
.slide-up-enter-from, .slide-up-leave-to { transform: translateY(20px); opacity: 0; }
```

## 4. LOADING STATES

```html

<div class="animate-spin w-5 h-5 border-2 border-primary-600 border-t-transparent rounded-full"></div>

<span class="animate-pulse">处理中...</span>

<div class="h-4 bg-gray-200 rounded-lg animate-pulse"></div>

<div class="bg-white rounded-2xl p-5 space-y-3 animate-pulse">
  <div class="h-4 bg-gray-100 rounded-lg w-3/4"></div>
  <div class="h-3 bg-gray-100 rounded-lg w-1/2"></div>
  <div class="h-8 bg-gray-100 rounded-lg w-full"></div>
</div>
```

## 5. SCROLL ANIMATIONS (GSAP — Website Only)

```javascript
// Fade up on scroll
gsap.from('.animate-section', {
  scrollTrigger: { trigger: '.animate-section', start: 'top 80%' },
  y: 40, opacity: 0, duration: 0.8, ease: 'power3.out'
})

// Stagger children
gsap.from('.stagger-item', {
  scrollTrigger: { trigger: '.stagger-container', start: 'top 80%' },
  y: 30, opacity: 0, duration: 0.6, stagger: 0.1, ease: 'power3.out'
})
```

## 6. ACCORDION / EXPAND-COLLAPSE (Vue)

```javascript
// Smooth height animation
async function toggleAccordion(el, isOpen) {
  if (isOpen) {
    el.style.height = el.scrollHeight + 'px'
    el.style.opacity = '1'
    setTimeout(() => { el.style.height = 'auto' }, 250)
  } else {
    el.style.height = el.scrollHeight + 'px'
    el.offsetHeight
    el.style.height = '0px'
    el.style.opacity = '0'
  }
}
```

```css
.accordion-body {
  overflow: hidden;
  transition: all 0.25s ease-out;
}
```

## 7. TOAST NOTIFICATION

```html

<Teleport to="body">
  <Transition name="slide-up">
    <div v-if="showToast" class="fixed top-6 left-1/2 -translate-x-1/2 z-[999] px-6 py-3 rounded-2xl text-sm font-bold shadow-2xl"
      :class="{
        'bg-green-500 text-white': type === 'success',
        'bg-red-500 text-white': type === 'error',
        'bg-gray-800 text-white': type === 'info'
      }">
      {{ message }}
    </div>
  </Transition>
</Teleport>
```

## 8. PULL-TO-REFRESH INDICATOR

```html
<div v-if="isPulling" class="flex justify-center py-4">
  <div class="animate-spin w-6 h-6 border-2 border-primary-600 border-t-transparent rounded-full"></div>
</div>
```

## 9. NUMBER COUNT-UP ANIMATION

```javascript
// Animate number from 0 to target
function countUp(el, target, duration = 800) {
  let start = 0
  const step = target / (duration / 16)
  const timer = setInterval(() => {
    start += step
    if (start >= target) { start = target; clearInterval(timer) }
    el.textContent = Math.floor(start).toLocaleString()
  }, 16)
}
```

## 10. CHEVRON ROTATE (FAQ / Accordion)

```html
<ChevronDown
  :size="18"
  class="text-gray-300 transition-transform duration-200"
  :class="{ 'rotate-180 text-primary-600': isOpen }"
/>
```

---

Micro-Interaction Vault V1.0 — 10 categories, copy-paste ready
AI: Add new interactions when discovered. These make "good" become "premium".

