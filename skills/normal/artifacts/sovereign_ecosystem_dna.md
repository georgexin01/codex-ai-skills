# Sovereign Ecosystem DNA — V6.1 Blueprint

This artifact documents the high-fidelity architectural standards for the Sovereign Web Framework (SWF) ecosystem, incorporating breakthroughs in relational persistence, unified API layers, and namespaced PHP orchestration.

## 🚀 1. Unified API Architecture (Frontend)

The Sovereign Standard mandates a cross-platform service layer in `src/api/` that orchestrates requests for both web and native environments.

### 1.1 The API Cluster
- **`apiClient.ts`**: Axios instance with platform-aware interceptors. Handles `FormData` and native Bridge fallback for Capacitor.
- **`capacitorClient.ts`**: Unified native HTTP wrapper for mobile-first connectivity.
- **`src/config/env.ts`**: The single source of truth for all environment configuration (`VITE_SUPABASE_URL`, etc.).

### 1.2 Structural Cleaning Protocol
All dev utility scripts must be centralized in `src/config/`:
- `check-connection.ts`
- `migrate_agent.ts`
- `peek_tables.ts`

## 🛡️ 2. Industrial PHP Orchestration (Backend)

The "Perfect API" is built on **PSR-4 Autoloading** and the **Sovereign CRUD Engine**.

### 2.1 The Namespace Standard
- **Namespace**: `Sovereign\`
- **Core**: `Sovereign\Core\SupabaseClient` (Supports custom headers).
- **Query**: `Sovereign\Core\SovereignQuery` (Explicit `single()` data-extraction support).

### 2.2 Relational Data Integrity
Relational binding must prioritize UUIDs over legacy identifiers:
- **Agent Binding**: Bound via `agent_profile_id` (UUID).
- **Seeding Persistence**: Automated lesson assignments via SQL migrations (`041_agent_auto_assignment.sql`).

## 📊 3. Connectivity Blueprint

| Layer | Protocol | Authoritative Source |
|---|---|---|
| **Web App** | Axios/Capacitor | `src/api/apiClient.ts` |
| **Website** | PHP Sovereign REST | `api/core/SovereignQuery.php` |
| **Database** | Dockerized Supabase | `http://localhost:54321` |
| **Identity** | Project-ID Binding | `public.user` -> `quizLaa.users` |

## 🛠️ 4. Execution Guardrails
- **NEVER** return response envelopes (`['status', 'data']`) directly to Page models. Extract the record first.
- **ALWAYS** check for "No Profile Image" fallbacks in Hero and Review sections.
- **MANDATE** `composer dump-autoload` after adding new Controllers or Models.

---
**Sovereign DNA Status**: V6.1 Active | **Last Update**: 2026-04-17 

## 📦 5. Authoritative Boilerplate Vault (COPY & ADAPT)

### 5.1 Frontend: `src/api/apiClient.ts`
```typescript
import { Capacitor } from "@capacitor/core";
import axios from "axios";
import { env } from "@/config/env";

const apiClient = axios.create({
  baseURL: `${env.SUPABASE_URL}/rest/v1`,
  headers: {
    'apikey': env.SUPABASE_ANON_KEY,
    'Content-Type': 'application/json'
  }
});

apiClient.interceptors.request.use(async (config) => {
  if (Capacitor.isNativePlatform() && config.data instanceof FormData) {
    config.headers["Content-Type"] = "multipart/form-data; charset=utf-8;";
    const formData = new FormData();
    for (const [key, value] of config.data.entries()) { formData.append(key, value); }
    const resp = await fetch(config.baseURL + config.url!, {
      method: "post",
      headers: { 
        'apikey': env.SUPABASE_ANON_KEY,
        'Authorization': config.headers["Authorization"]?.toString() || `Bearer ${env.SUPABASE_ANON_KEY}`
      },
      body: formData,
    });
    const json = await resp.json();
    config.adapter = (request) => new Promise((resolve, reject) => {
      if (json.success || !json.error) resolve({ data: json, status: resp.status, statusText: resp.statusText, headers: config.headers, request, config });
      else reject({ response: { data: json }, status: resp.status, statusText: resp.statusText, headers: config.headers, request, config });
    });
  }
  return config;
});
export default apiClient;
```

### 5.2 Backend: `SovereignQuery::get()` Hardening
```php
public function get($headers = []) {
    // ... params building ...
    if ($this->single) { $headers[] = "Accept: application/vnd.pgrst.object+json"; }
    $queryString = implode('&', $params);
    $response = $this->client->request($this->table . ($queryString ? '?' . $queryString : ''), 'GET', null, 'return=representation', $headers);
    if ($this->single) {
        $status = $response['status'] ?? 500;
        return ($status >= 200 && $status < 300) ? $response['data'] : null;
    }
    return $response;
}
```
