---
name: normal-design-vault
description: "Design Vault — 3 Vaults + Logic-Driven Matching System (Atomic)"
triggers: ["readme", "design vault vaults"]
phase: reference
model_hint: gpt-5.3-codex
version: 43.0
---

# 🌌 DESIGN VAULT — APEX V43.0 (ATOMIC)

High-density design pattern repository optimized for surgical UI scaffolding.

## 🧠 1. VAULT MATCHING ENGINE
Rule: AI checks vault → runs match score → **≥55% = use vault**, <55% = create fresh design.

| Match Criteria | Weight | Check Logic |
| :--- | :--- | :--- |
| **Project Type** | 30% | F&B→F&B (100%), F&B→SaaS (20%) |
| **Visual Style** | 25% | Light/dark mode? Gradient/flat? Premium? |
| **Mood/Tone** | 20% | Professional/casual? Audience age? |
| **Layout/Structure**| 15% | Mobile/Web? Single-col/Multi-col? |
| **Interaction** | 10% | Scroll behavior? Animation style? |

## 📦 2. VAULT INDEX
| # | Component | Score | Match Profile | Data File |
| :--- | :--- | :--- | :--- | :--- |
| **D1**| Gradient Order Card| 95 | F&B, E-commerce | [order-card.yaml](components/order-card.yaml) |
| **D2**| Auth Login (Dark) | 95 | Core Mobile Auth | [auth-login.yaml](components/auth-login.yaml) |
| **D3**| Mobile Nav Dark | 95 | Agency/Portfolio | [mobile-nav.yaml](components/mobile-nav.yaml) |
| **D4**| Phone Showcase | 95 | Landing Pages | [showcase.yaml](components/showcase.yaml) |

## 🎨 3. THEME & INTERACTION
| Asset Group | Count | Source |
| :--- | :--- | :--- |
| **Primary Themes** | 5 Variants | [theme-system.md](theme-system.md) |
| **Button Vault** | 20 Variants | [button-vault.yaml](components/button-vault.yaml) |
| **Interactions** | 10 Patterns | [micro-interactions.md](micro-interactions.md) |

## 🛡️ 4. APEX GUARDRAILS
- **Match ≥ 85%**: USE DIRECTLY (copy + swap text/colors).
- **Match 55-84%**: USE AS BASE (copy + modify 30-50%).
- **OVERUSE PENALTY**: If used 3x in a row, FORCE fresh design.

---
**Design Vault V43.0 — Atomic Dashboard (2026-04-20)**

