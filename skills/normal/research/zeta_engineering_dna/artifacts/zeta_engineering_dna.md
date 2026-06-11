---
name: zeta-engineering-dna
description: "Zeta Engineering DNA: The \"Red & Black Cyber Luxury\" Protocol (V3.0)"
triggers: ["zeta engineering dna", "zeta_engineering_dna", "zeta engineering black"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: zeta_engineering_dna
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Zeta Engineering DNA: The "Red & Black Cyber Luxury" Protocol (V3.0)

This document codifies the high-fidelity design and engineering standards extracted from the Zeta Website V1-V3 evolution. Use these as P0 standards for all "Engineering Authority" projects.

## 🎨 1. Visual Brand Protocol

### 🔴 Core Colors
| Token | HEX | Role |
| :--- | :--- | :--- |
| `--tech-red` | `#ff3b3b` | The Core Signal / Accents / CTAs |
| `--cyber-black` | `#020305` | Master Background / Absolute Depth |
| `--cyber-dark` | `#0a0b10` | Section Base / Primary Layer |
| `--cyber-neutral` | `#0c0d12` | Subtle Layer depth (~10% lighter) |

### 🔡 Typography Stack
*   Headlers/UI Labels: `Orbitron`, sans-serif (Upper-case, 2px letter-spacing).
*   Technical Data: `Space Mono`, monospace.
*   Body Content: `Inter`, sans-serif.

---

## ⚡ 2. The Physics Engine (JS/CSS)

### 🚅 Velocity Shift (Scroll Parallax)
Map scroll speed/offset to a CSS variable to drive background movement.
```javascript
window.addEventListener('scroll', () => {
    const velocity = window.scrollY * 0.1;
    document.documentElement.style.setProperty('--velocity-shift', `${velocity}px`);
});
```

### 👻 Ghost Intent (Mouse tracking)
Track mouse velocity to drive the intensity of glow effects.
```javascript
document.addEventListener('mousemove', (e) => {
    const intensity = Math.min(1, Math.abs(e.movementX + e.movementY) / 100);
    document.documentElement.style.setProperty('--ghost-intensity', intensity);
});
```

---

## 🏗️ 3. Structural Hierarchy (The 11-Section Flow)

1.  Red Hero: Big typography, "Engineering Authority" tag, HUD-line ornaments.
2.  Portfolio Matrix: Asymmetrical bento-grid showcasing official case studies.
3.  Mobile Ecosystem: Interactive iPhone frame with Swiper.js for app simulation.
4.  Stats Matrix: 4-column grid with `Space Mono` numerals and "Telemetry" labels.
5.  Service Explorer: Vertical sticky labels (rotated 180deg) for core service cards.
6.  Process Workflow: 01-04 numbered steps with "Telemetry Line" dividers.
7.  Value Proposition: Matrix of glass-panels (`backdrop-filter: blur(25px)`).
8.  Testimonials: Swiper slider with `Orbitron` header and `Inter` quotes.
9.  Knowledge Base (FAQ): Cyber-accordion with red glow on active state.
10. Human Protocol (Careers): Engineering-focused recruitment section.
11. Mission-Critical CTA: High-contrast red banner with mission-critical language.

---

## 💎 4. Master Aesthetic DNA (HUD Polish)

*   Telemetry Lines: `1px` high-contrast lines with low opacity (0.1) as dividers.
*   Liquid Text: Animated linear-gradient on headers.
*   HUD Ornaments: Pseudo-elements with `ENGINEERING_AUTH` text at 0.03 opacity.
*   Glassmorphism: 
    ```css
    .glass-panel {
      background: rgba(255, 255, 255, 0.03);
      backdrop-filter: blur(25px);
      border: 1px solid rgba(255, 255, 255, 0.08);
    }
    ```

[!IMPORTANT]
Directive: When a user invokes `ai [task]`, this protocol is ACTIVE by default. No simple MVPs; only high-density, mission-critical UI/UX.

