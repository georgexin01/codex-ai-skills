---
name: implementation-playbook
description: "Tailwind Design System Implementation Playbook - Surgical Atomic Node"
triggers: ["implementation playbook", "implementation-playbook", "tailwind design system"]
phase: reference
model_hint: gpt-5.3-codex
version: 43.0
---

# 🎨 Tailwind Implementation Playbook (V43.0 APEX)

Surgical index of Tailwind patterns for high-velocity UI scaffolding.

## 🏗️ 1. ARCHITECTURE BENTO
| Layer | Strategy | Reference |
| :--- | :--- | :--- |
| **Tokens** | HSL CSS Variables + Config Extend | [Quick Start](#quick-start) |
| **Variants** | Class Variance Authority (CVA) | [button-cva.ts](patterns/button-cva.ts) |
| **Composition**| React.forwardRef + cn() utility | [card-compound.ts](patterns/card-compound.ts) |
| **Accessibility**| Aria-attributes + Peering | [input-pattern.ts](patterns/input-pattern.ts) |
| **Animation** | tailwindcss-animate + GSAP | [animation-utils.ts](patterns/animation-utils.ts) |

## ⚡ 2. QUICK START (CONFIG)
```typescript
// tailwind.config.ts (Atomic Snippet)
theme: {
  extend: {
    colors: {
      primary: { DEFAULT: 'hsl(var(--primary))', foreground: 'hsl(var(--primary-foreground))' },
      background: 'hsl(var(--background))',
      foreground: 'hsl(var(--foreground))',
    },
    borderRadius: { lg: 'var(--radius)' }
  }
}
```

## 🛠️ 3. CORE PATTERN REPOSITORY
| # | Pattern Name | Purpose | Target File |
| :--- | :--- | :--- | :--- |
| **P1** | **CVA Button** | Type-safe variant management | [button-cva.ts](patterns/button-cva.ts) |
| **P2** | **Compound Card** | Flexible slot-based composition | [card-compound.ts](patterns/card-compound.ts) |
| **P3** | **Sovereign Input**| Accessible forms with ARIA/Errors| [input-pattern.ts](patterns/input-pattern.ts) |
| **P6** | **Theme Provider**| Runtime Light/Dark/System sync | [theme-provider.ts](patterns/theme-provider.ts) |

## 🛡️ 4. APEX GUARDRAILS
- **DO NOT** use arbitrary values (e.g. `bg-[#123456]`). Map to theme tokens.
- **DO NOT** nest `@apply` directives.
- **MANDATORY** focus-visible ring on all interactive elements.

---
**Tailwind Playbook V43.0 — Atomic & Compressed (2026-04-20)**

