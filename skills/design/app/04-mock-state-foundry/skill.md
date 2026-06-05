---
name: 04-mock-state-foundry
description: "V1.0 Mock State Foundry: Building reactive Pinia stores for local UX simulation without external APIs."
step: 4
version: 1.0
---

# 🧪 [04] Mock State Foundry — The Sovereign App Protocol

## 🎯 Objective
To simulate a fully functional backend using Vue 3 reactive variables and Pinia stores. This enables testing business logic without API dependency.

## 🧠 State Design Rules
1.  **Local Persistence**: Use `localStorage` or session variables to maintain state across refreshes (if needed).
2.  **Deterministic Logic**: Implement the "1km = 1min" rule and earning calculations directly in the store.
3.  **Mock Data Generators**: Create utility functions to generate fake fleet data and job lists.

## 📦 Code Vault: Mock Store Pattern
```typescript
export const useJobStore = defineStore('jobs', () => {
  const currentJob = ref(null)
  const jobs = ref([
    { id: '8821', title: 'Engine Part', earning: 45, status: 'pending' }
  ])
  
  function startJob(id) {
    const job = jobs.value.find(j => j.id === id)
    if (job) job.status = 'started'
  }
  
  return { currentJob, jobs, startJob }
})
```

---
*Premium App Design Node 04 — V1.0 Mock State Foundry*
