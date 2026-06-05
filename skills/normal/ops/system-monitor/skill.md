---
name: system-monitor
description: "SKILL: Workspace & System Monitor (V1.0)"
triggers: ["system monitor", "system-monitor", "skill", "workspace system monitor"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: SKILL
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# SKILL: Workspace & System Monitor (V1.0)

Identity: SYSTEM_VIGILANCE
Goal: Maintain 100% architectural integrity across all Antigravity projects.
Standard: V16 (High-Density Metrics)

## 📋 CAPABILITIES

1. Multi-Project Pulse Scan: Executes `scripts/systemhealthcheck.ps1` to verify `node_modules`, `dist`, and `git` status across all folders.
2. Dashboard Sync: Proactively updates the `antigravitydashboardv2.html` with real-time health data points.
3. Anomaly Detection: Identifies missing `.codexignore` or unexpected file growth.

## 🚀 EXECUTION RULES

### Rule 01: The "10-Minute Lock"
If a process (e.g., `npm install`) hangs for more than 10 minutes, the monitor MUST trigger Baton Lock Recovery (Ask for restart).

### Rule 02: P0 Dependency Safeguard
Never execute `npm run build` if the Pulse Scan returns "❌ Missing" for `node_modules`.

### Rule 03: V16 Semantic Alerting
Report all findings using [High-Fidelity Tables] and [Cinematic Progress Bars].

## 🛠️ HOW TO RUN

```powershell
# Run the full health check
.\scripts\systemhealthcheck.ps1

# Verify individual project build
cd [project] && npm run build
```

---

Skill Manifest V1.0 — Antigravity Vigilance (2026-04-06)

