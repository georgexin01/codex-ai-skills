---
name: master-blueprint
description: "Global Tier-0 Industrial Master Blueprint V3.0 — Project Brain Template. Cloned for every sub-project. Router BLUEPRINTs at multi-project roots use a separate lighter format."
version: 3.0.0
status: master
last_updated: "2026-04-29"
blueprint_type: "project"   # values: "project" | "router"
---

# 💎 PROJECT BLUEPRINT (V3.0)

> **Purpose** — This is the **single source of truth brain** for ONE project folder. All AI models (Claude, Gemini, etc.) MUST read this file at the start of every session before making any code changes. AI MUST append to the Change Log every time code, schema, or config is modified.

---

## 🏢 COMPANY
<!-- Fill in during project bootstrap scan -->
- **Company Name**: [e.g. Life Achiever Advisory]
- **Tagline**: [e.g. 全人學堂 · 理財計劃顧問]
- **Address**: [Physical address]
- **Phone / WhatsApp**: [+60 XX-XXX XXXX]
- **Email**: [contact@email.com]
- **Facebook**: [URL]
- **Other Socials**: [URLs]

---

## 🎯 TARGET AUDIENCE
<!-- Who uses this project and why -->
- **Primary Users**: [e.g. Insurance Agents, Students, Admins]
- **Secondary Users**: [e.g. Public visitors, HR managers]
- **Language**: [e.g. English + Chinese (Bilingual)]
- **Device**: [e.g. Mobile-first PWA / Desktop admin / Public web]

---

## 📌 PROJECT OVERVIEW
- **Folder**: `[project-folder-name]/`
- **Type**: [Website | WebApp | Admin Panel | API | Mobile App]
- **Purpose**: [One paragraph describing what this project does]
- **Live URL**: [Production URL if deployed]
- **Dev URL / Port**: [http://localhost:XXXX]

---

## 🛠️ TOOLS USED
<!-- All frameworks, packages, APIs, external services -->
- **Framework**: [e.g. Vue 3 + Vite / PHP Sovereign V6]
- **UI Library**: [e.g. Ant Design Vue / Bootstrap / Tailwind]
- **State Management**: [e.g. Pinia / None]
- **Database**: [e.g. Supabase (Docker-hosted) / None]
- **Storage**: [e.g. Supabase Storage bucket: `quizLaa`]
- **Auth**: [e.g. Supabase Auth / JWT / Session]
- **Other APIs**: [WhatsApp, SendGrid, etc.]
- **Build Tool**: [e.g. Vite / pnpm workspaces / Composer]
- **Deploy Target**: [e.g. Apache / Vercel / Docker]

---

## 🏗️ STRUCTURE MAP
<!-- Key folders only — not exhaustive, just what matters for AI orientation -->
```
[project-root]/
├── [key-folder-1]/     # What it does
├── [key-folder-2]/     # What it does
└── [key-file.ext]      # What it does
```

---

## 🎨 DESIGN SYSTEM
<!-- Colors, fonts, themes, CSS variable names, component look -->
- **Primary Color**: [e.g. #E92124 Red / #2E7D32 Forest Green]
- **Background**: [e.g. #FFFFFF White / #F8F9FA Light Gray]
- **Font**: [e.g. Inter / Plus Jakarta Sans / System default]
- **Theme Mode**: [Light / Dark / Auto]
- **Mobile Shell**: [e.g. max-w-[480px] mx-auto / Full width]
- **Card Style**: [e.g. ios-shadow / border / glassmorphism]
- **Button Style**: [e.g. h-14 rounded-xl active:scale-[0.98]]
- **Animation**: [e.g. Smooth transitions 200ms ease / GSAP ScrollTrigger]
- **CSS Framework**: [e.g. Tailwind v4 / Bootstrap 5 / Vanilla CSS]
- **Notable CSS Patterns**: [Any custom CSS variables, utility classes, or design quirks]

---

## ⚙️ FUNCTION REGISTRY
<!-- Every major feature/function that exists — prevents AI from duplicating or rebuilding things that already exist -->

| Feature | File Location | Status | Notes |
|---|---|---|---|
| [e.g. User Login] | `src/views/login/` | ✅ Done | Supabase Auth + 2-client architecture |
| [e.g. Agent Profile Page] | `home.php` | ✅ Done | UUID-only routing |
| [e.g. Quiz Module] | `src/views/quiz/` | 🚧 In Progress | Missing timer feature |
| [e.g. i18n] | `lang/{en,cn,ms}.json` | ✅ Done | 3 languages |

---

## 💡 IDEAS BACKLOG
<!-- Ideas the user mentioned but are not yet built — prevents them from being lost across sessions -->

| Idea | Priority | Notes |
|---|---|---|
| [e.g. Dark mode toggle] | Low | User mentioned in passing |
| [e.g. Agent leaderboard] | Medium | Would rank agents by review count |
| [e.g. PDF export for quiz results] | High | User explicitly requested |

---

## 🔗 CROSS-PROJECT RELATIONSHIPS
<!-- How this project connects to other projects in the same ecosystem -->
- **Shares DB with**: [e.g. admin-panel-quizLaa — same Supabase instance / schema `quizLaa`]
- **Feeds data to**: [e.g. website-LAA-agent reads agent_profiles from the same DB]
- **Auth dependency**: [e.g. Users created in admin-panel; webApp reads same auth.users]
- **Shared Assets**: [e.g. Images uploaded to Supabase Storage bucket `quizLaa` shared across all projects]

---

## 📝 CHANGE LOG
<!-- AI MUST append here on every turn that modifies code, schema, or config. Format: -->
<!-- ### YYYY-MM-DD · [AI Name] · [Project] (brief task title) -->
<!-- - **Goal**: What was asked -->
<!-- - **Files changed**: List of files + what changed -->
<!-- - **Outcome**: Done / Partial / Blocked -->
<!-- - **Open for next AI**: What remains -->

*(No entries yet — this BLUEPRINT was just bootstrapped.)*

---

## ✅ OPEN TASKS
<!-- Items the last AI explicitly left for the next AI -->
*(None yet.)*

---

## 🧬 BLUEPRINT META
- **Blueprint Type**: Project (single-folder scope)
- **Template Version**: V3.0
- **Created**: [YYYY-MM-DD]
- **Last AI to update**: [AI name + date]
- **Deep Scan Done**: [Yes / No / Pending user approval]

---
*Project BLUEPRINT V3.0 — Antigravity Tier-0 // Clone from MASTER_BLUEPRINT.md for each new project*
