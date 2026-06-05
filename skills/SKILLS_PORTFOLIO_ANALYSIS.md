# SKILLS CODEX COMPARISON & RATING ANALYSIS

## 1️⃣ PORTFOLIO SUMMARY TABLE

| Folder | Category | Skill Count | Status | Purpose | Latest Version |
|---|---|---|---|---|---|
| **claude/** | Core Engine | 15+ | ✅ Active | CRUD module gen + Supabase + Pinia store factory | 1.0 |
| **claude-app/** | Mobile/Web App | 13 | ✅ Active | Vue 3 builder orchestrator (views, stores, routes) | 2.1 |
| **claude-website/** | Backend | 13+ | ✅ Active | PHP Sovereign orchestrator (config, auth, REST APIs) | - |
| **claude-meta/** | Planning/Gating | 2 | ✅ Active | Plan→Execute→Validate loop for Tier-0/1 changes | 2.0 |
| **admin-panel/** | UI Components | 3 | ✅ Active | Vben Admin specific UI patterns | - |
| **design/** | Design Hub | 3 | ✅ Active | Routes to app/website/spec design skills | 1.0 |
| **ai-personality/** | System Role | 1 | ✅ Active | Professional AI role definition (always-on) | 2.1 |
| **clean-module/** | Maintenance | 1 | ✅ Active | Prep copied admin for new project modules | 1.0 |
| **faucet/** | Industrial | 6 | 🔴 ARCHIVED | Automated harvesting orchestrator (11-step protocol) | 16.2 |
| **imagegen/** | Image Tools | 1 | ⚠️ Unknown | Image generation agents/assets | - |
| **website/** | Integration | 1 | ✅ Active | Google Sheets email integration | - |

---

## 2️⃣ CAPABILITY MATRIX — What Each Can Do

### 🟢 PRODUCTION-GRADE (Tier-0 active, heavily used)

| Skill Hub | Read → Plan → Scaffold → Test | Coverage | Automation |
|---|---|---|---|
| **claude/** | ✅ Full pipeline | Schema analysis → SQL → Store → Views → Routes → i18n → Tests | 100% end-to-end |
| **claude-app/** | ✅ Full pipeline | Handshake → Auth → API setup → Store factory → View builder → Routing → PWA deploy | 100% end-to-end |
| **claude-website/** | ✅ Full pipeline | Config → Composer → Schema → Security → Seeding → Models → Controllers → REST → SEO | 100% end-to-end |
| **design/** | ✅ Full pipeline | App design → Website design → DESIGN.md spec contracts → Tailwind export | Partial (design-driven) |
| **claude-meta/** | ⚠️ Planning only | Plan (Phase 1) → User Gate (Phase 2) → Execute (Phase 3) → Validate (Phase 4) | 100% orchestration |

### 🟡 UTILITY (One-purpose, specialized)

| Skill | Purpose | Maturity | Value |
|---|---|---|---|
| **admin-panel/** | UI component patterns for Vben Admin | Mature | High (reference patterns) |
| **clean-module/** | Reset copied admin to blank slate | Mature | High (required pre-step) |
| **ai-personality/** | System context + role definition | Mature | Critical (always active) |
| **imagegen/** | Image generation from specs | Unknown | Medium (feature support) |
| **website/** | Google Sheets → email template bridge | Stable | Low (niche use) |

### 🔴 ARCHIVED (Not recommended for new work)

| Skill | Why Archived | Last Version | Risk |
|---|---|---|---|
| **faucet/** | Industrial harvesting (v16.2) | 16.2 | High if reactivated; may have dependencies on deleted infrastructure |

---

## 3️⃣ MATURITY & RATING SCORECARD

### 🌟 Maturity Tiers (1-5)

| Folder | Maturity | Reliability | Documentation | Last Updated | Recommendation |
|---|---|---|---|---|---|
| **claude/** | ⭐⭐⭐⭐⭐ | ✅ Excellent | ✅ Comprehensive | 2026-05-21 | USE FOR ALL NEW MODULES |
| **claude-app/** | ⭐⭐⭐⭐⭐ | ✅ Excellent | ✅ Comprehensive | 2026-05-21 | USE FOR ALL APP WORK |
| **claude-website/** | ⭐⭐⭐⭐⭐ | ✅ Excellent | ✅ Comprehensive | 2026-05 | USE FOR ALL BACKEND WORK |
| **claude-meta/** | ⭐⭐⭐⭐⭐ | ✅ Excellent | ✅ Clear phase gates | 2026-04-23 | REQUIRED FOR TIER-0/1 |
| **design/** | ⭐⭐⭐⭐ | ✅ Good | ✅ Clear routing | 2026-05-21 | USE FOR DESIGN CONTRACTS |
| **admin-panel/** | ⭐⭐⭐⭐ | ✅ Good | ✅ Reference | 2026-05 | REFERENCE PATTERNS |
| **ai-personality/** | ⭐⭐⭐⭐⭐ | ✅ Critical | ✅ Explicit | 2026-06-04 | ALWAYS ACTIVE |
| **clean-module/** | ⭐⭐⭐⭐ | ✅ Good | ✅ Step-by-step | 2026-06-04 | RUN FOR NEW PROJECTS |
| **faucet/** | ⭐⭐⭐⭐ | ⚠️ Unknown | ✅ Explicit | 2026-04-24 | DO NOT USE (archived) |
| **imagegen/** | ⭐⭐⭐ | ⚠️ Unknown | ⚠️ Minimal | Unknown | EXPLORATORY USE ONLY |
| **website/** | ⭐⭐⭐ | ✅ Stable | ⚠️ Minimal | Unknown | OPTIONAL INTEGRATION |

---

## 4️⃣ PROS & CONS BY FOLDER

### 🟢 claude/ — CRUD Module Factory

**PROS:**
- ✅ End-to-end pipeline (analysis → SQL → store → views → routes → i18n → tests)
- ✅ Tested 41-task linear executor (WORKING_PROGRESS.md)
- ✅ Schema-first methodology (Reality-First Table Forging rule)
- ✅ Bilingual i18n built-in
- ✅ Supabase RLS + RBAC templates included
- ✅ Composable skill dependencies (can run each phase separately)

**CONS:**
- ❌ Heavyweight for tiny one-off features
- ❌ Requires full analysis upfront
- ❌ Assumes PostgreSQL schema exists already
- ❌ Not suitable for UI-only changes

**BEST FOR:** Complete module builds (Currencies, Users, Orders, etc.)  
**AVOID FOR:** Quick hotfixes, one-off API endpoints, CSS tweaks

---

### 🟢 claude-app/ — Vue 3 App Orchestrator

**PROS:**
- ✅ 13-step mobile-first build process
- ✅ PWA + native (Capacitor) ready
- ✅ Handshake → config → auth → store → views → routing → deploy
- ✅ Visual design input from design/app skill
- ✅ i18n + image handling built-in
- ✅ Integrated with SHARED_DB_CONTRACT.md for schema sync

**CONS:**
- ❌ Tied to Vben Admin patterns (not generic Vue)
- ❌ Requires Pinia store architecture understanding
- ❌ VXE table formatting opinions built-in
- ❌ Not for basic SPA (overkill)

**BEST FOR:** Full admin panel or mobile app builds  
**AVOID FOR:** Lightweight landing pages, single-component apps

---

### 🟢 claude-website/ — PHP Sovereign Backend

**PROS:**
- ✅ 13+ step orchestration for PHP 8+ backend
- ✅ Config → auth → schema → models → controllers → REST → SEO
- ✅ Composer PSR-4 autoload setup
- ✅ Supabase PostgREST + custom JWT integration
- ✅ SEO structured data + SiteMap generation
- ✅ Error handling + versioned REST API routing

**CONS:**
- ❌ Tied to PHP Sovereign pattern (not generic Laravel/Symfony)
- ❌ Heavy upfront configuration
- ❌ Requires Supabase RLS policy understanding
- ❌ Not for simple static sites

**BEST FOR:** Full-stack PHP REST API + website backend  
**AVOID FOR:** Static HTML sites, quick APIs, microservices

---

### 🟢 claude-meta/ — Governance & Planning

**PROS:**
- ✅ Tier-0/1 safety gate (Plan → User gate → Execute → Validate)
- ✅ Blocks dangerous changes automatically
- ✅ Plan-first enforces thinking before coding
- ✅ Validate-knowledge catches migration + schema issues
- ✅ Clear escalation path for high-risk changes

**CONS:**
- ❌ Overhead for low-risk changes (Tier-2/3)
- ❌ Requires user approval in planning phase (not autonomous)
- ❌ May slow down rapid iteration

**BEST FOR:** High-risk migrations, schema changes, multi-file rewrites  
**AVOID FOR:** Single-file edits ≤20 lines, read-only research

---

### 🟡 design/ — Design Hub

**PROS:**
- ✅ Routes to app/website/spec contexts
- ✅ DESIGN.md contract layer for token standardization
- ✅ Tailwind export ready
- ✅ Three distinct sub-skills (no one-size-fits-all)

**CONS:**
- ⚠️ Design-only (doesn't generate code)
- ⚠️ Requires DESIGN.md to exist for full power
- ⚠️ Limited automation

**BEST FOR:** Design token standardization, visual system definition  
**AVOID FOR:** Rapid UI iteration without design contracts

---

### 🟡 admin-panel/ — UI Component Patterns

**PROS:**
- ✅ Reference implementations for Vben Admin patterns
- ✅ ForeignKey count display pattern
- ✅ List drawer embedding pattern
- ✅ Conditional blue link pattern (tailored styling)

**CONS:**
- ⚠️ Reference only, not a full system
- ⚠️ Specific to Vben Admin (not portable)
- ⚠️ Only 3 patterns (limited coverage)

**BEST FOR:** Vben-specific UI component ideas  
**AVOID FOR:** Non-Vben projects

---

### 🟡 ai-personality/ — System Role

**PROS:**
- ✅ Always-active professional context
- ✅ Explicit engineering laws (Rule #1-9)
- ✅ Malaysian market defaults
- ✅ Session start checklist
- ✅ Bilingual conventions clarified

**CONS:**
- ❌ Meta-level (doesn't generate code)
- ❌ Requires internalization by AI

**BEST FOR:** Session grounding, context alignment  
**MUST READ BEFORE:** Any serious project work

---

### 🟡 clean-module/ — Admin Reset Utility

**PROS:**
- ✅ Atomic cleanup process (9 steps)
- ✅ Preserves shared infrastructure (auth, users, attachments)
- ✅ Explicit guardrails (what to keep)
- ✅ Post-cleanup verification checklist

**CONS:**
- ⚠️ Destructive (deletes old modules)
- ⚠️ One-time use per project
- ⚠️ Manual PowerShell steps required

**BEST FOR:** Starting fresh admin panel from copied project  
**RUN EXACTLY ONCE:** Before creating any new modules

---

### 🔴 faucet/ — Industrial Automation

**PROS:**
- ✅ Explicit 11-step protocol (v16.2)
- ✅ Vision-sync + stealth DNA defined
- ✅ Comprehensive (recon → solving → harvesting → withdraw)

**CONS:**
- ❌ ARCHIVED status = unmaintained
- ❌ Infrastructure may be deleted (too high-risk)
- ❌ No clear update path
- ❌ Compliance/legal unclear

**BEST FOR:** N/A — DO NOT USE  
**REASON:** Archived 2026-04-24

---

### ⚠️ imagegen/ — Image Generation

**PROS:**
- ✅ Has agent structure
- ✅ Assets + references organized
- ✅ Scripts included

**CONS:**
- ❌ Status/maturity unknown
- ❌ Minimal documentation
- ❌ No clear trigger/usage pattern
- ❌ No version date

**BEST FOR:** Experimental image generation  
**RESEARCH FIRST:** Before relying on this

---

### ⚠️ website/ — Google Sheets Integration

**PROS:**
- ✅ Specific problem solved (Sheets → email)
- ✅ Niche but complete

**CONS:**
- ❌ Extremely specialized
- ❌ Minimal documentation
- ❌ Single-purpose (hard to reuse)

**BEST FOR:** Email template generation from Sheets  
**SKIP FOR:** 99% of projects

---

## 5️⃣ IGNORE RECOMMENDATIONS

### ✅ SAFE TO IGNORE (archival/reference only)
- **faucet/** — Archived industrial tool (status: archived)
- **imagegen/** — Experimental, undocumented
- **website/** (Sheets integration) — Niche integration

### ⚠️ CONDITIONALLY KEEP (optional reference)
- **admin-panel/** — Keep as reference (3 patterns useful, but non-critical)
- **starting-point/** — New project bootstrap template
- **project-handoff-doc-stack/** — Handoff reference docs
- **normal/**, **karpathy-guidelines/**, **markdown-database-mindmap/** — Templates/reference

### ✅ DO NOT IGNORE (core infrastructure)
- **claude/** — Core CRUD engine
- **claude-app/** — Mobile/web builder
- **claude-website/** — Backend builder
- **claude-meta/** — Governance layer
- **design/** — Design routing
- **ai-personality/** — System context
- **clean-module/** — Maintenance utility

---

## FINAL RECOMMENDATION

| Folder | Safe to Ignore? | Rationale |
|---|---|---|
| **faucet/** | ✅ YES | Archived, unmaintained, high risk |
| **imagegen/** | ✅ YES | Unknown maturity, minimal docs, no clear use case |
| **website/** (Sheets) | ✅ YES | Ultra-niche (1% of projects), low reusability |
| **starting-point/** | ⚠️ MAYBE | Keep if planning new project archetypes, else optional |
| **clean-module/** | ❌ NO | Essential pre-step when copying old admin to new project |
| **admin-panel/** | ❌ NO | Reference patterns still valuable for Vben-specific work |
| **claude/**, **claude-app/**, **claude-website/**, **claude-meta/**, **design/**, **ai-personality/** | ❌ NO | Core infrastructure — always keep |

---

**Analysis Date: 2026-06-05**
