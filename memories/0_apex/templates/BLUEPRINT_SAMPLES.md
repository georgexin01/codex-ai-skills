# 💎 BLUEPRINT SAMPLES & USE CASES

This document provides high-fidelity samples for different project types within the Sovereign ecosystem. Use these as benchmarks when generating new project blueprints.

---

## 🏎️ 1. CARS MARKETPLACE (SEO FOCUSED)
**Project**: `carnews`
**Goal**: SEO multi-site lead generation.

### Key Logic:
- **Shared Data**: Centralized car inventory.
- **Route Differentiation**: `/cars-for-sale-johor/`, `/used-cars-kl/`, `/buy-car-penang/`.
- **Advanced Filter Specs**:
  - `make`: Brand selection.
  - `model`: Dependent on make.
  - `price_range`: 0-50k, 50k-100k, etc.

---

## 🛡️ 2. CORPORATE MARKETING (LAA STYLE)
**Project**: `website-LAA-official`
**Goal**: Professional brand authority and recruitment.

### Key Logic:
- **Bilingual i18n**: Chinese/English priority.
- **Trust Elements**: Stats counters, award galleries, team profiles.
- **Lead Capture**: Modular contact forms with email routing.

---

## 🧩 3. SEO MIRROR SITE (TEMPLATE CLONING)
**Project**: `seo-mirror-01`
**Goal**: High-volume Google indexing with unique paths.

### Key Logic:
- **Logic Extraction**: Inherits `lib/` and `template/` from a master repository.
- **Path Transformation**: Rewrites core paths to unique strings using `router.php`.
- **Unique Metadata**: Dynamic Page Titles and Meta Descriptions per mirror site.

---

## 🛠️ BLUEPRINT GENERATION FLOW
1. **ENVIRONMENT SCAN**: Run `ls -R` to map structure.
2. **REFERENCE STUDY**: Locate sibling projects with similar patterns.
3. **DOMAIN BENCHMARK**: Research industry leaders (e.g. Carlist, PropertyGuru).
4. **DNA SYNTHESIS**: Populate `MASTER_BLUEPRINT.md` fields with surgical precision.
5. **COMMIT & HANDSHAKE**: Save to root and wait for user approval.

---
*Blueprint Samples V1.0 — Antigravity // 2026-05-03*
