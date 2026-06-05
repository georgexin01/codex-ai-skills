# Supabase Multi-App Authentication Architecture

> Learned from: CY Roro Bin Rental (trash-container-app)  
> Applies to: Any Supabase project with multiple user roles across multiple Vue/React apps

---

## The 4-Layer Auth Pattern

When building multi-role Supabase apps (admin + driver, admin + customer, etc.),  
use this 4-layer architecture. **ALL 4 layers must have a row for login to succeed.**

```
Layer 1: auth.users
  → Standard Supabase auth (email + bcrypt password)
  → Created via: supabase.auth.signUp() or SETUP_TRASH.sql INSERT

Layer 2: public."user"  (bridge table)
  → Links auth.users to a project + role
  → Triggers: custom_access_token_hook on each JWT issue
  → Hook injects: project_id, user_role, role_level into JWT claims

Layer 3: trash.users  (business profile)
  → App-readable: role, name, phone
  → Read AFTER login: authStore.fetchUser() queries this table
  → Uses camelCase columns (if trash schema is camelCase)

Layer 4: trash.drivers  (role-specific profile)
  → Only for driver role
  → Contains: vehicleNo, licenseNo, wallet balance
  → CRITICAL: trash.drivers.id ≠ trash.users.id — different UUIDs
```

### Why This Separation?
- `auth.users` = authentication only. Never store business data here.
- `public.user` = multi-tenancy bridge. One user can belong to multiple projects.
- `trash.users` = business profile. Schema-isolated, safe to dump/restore independently.
- `trash.drivers` = role extension. Not every user is a driver.

---

## JWT Custom Claims (via custom_access_token_hook)

```sql
-- Hook injects into JWT:
{
  "project_id": "uuid-of-project",
  "user_role": "super_admin",   -- your app role
  "role_level": 10,             -- privilege level (lower = more access)
  "role": "authenticated"       -- RESERVED by PostgREST — DO NOT override
}
```

**NEVER check `role` claim in your app** — PostgREST uses it for Postgres role switching.  
Always check `user_role` for application-level permissions.

RLS policies use: `(current_setting('request.jwt.claims', true)::jsonb->>'user_role')`

---

## DB Restore Problem (Critical)

When you restore a Supabase dump, only the `trash` schema survives.  
`auth`, `public`, and `storage` schemas are **cleared**.

| Layer | Survives restore? |
|-------|------------------|
| `auth.users` | ❌ CLEARED |
| `public.user` | ❌ CLEARED |
| `storage.buckets` | ❌ CLEARED |
| `trash.users` | ✅ SURVIVES |
| `trash.drivers` | ✅ SURVIVES |

**Fix:** Keep a `SETUP_TRASH.sql` file that re-creates all auth/public/storage rows.  
Run it via Docker exec (no psql needed on host):

```powershell
docker cp "sql/SETUP_TRASH.sql" supabase_db_local-supabase:/tmp/SETUP_TRASH.sql
docker exec supabase_db_local-supabase psql -U postgres -f /tmp/SETUP_TRASH.sql
```

---

## Diagnostic SQL (run after restore)

```sql
SELECT 'project'     AS check, COUNT(*)::text FROM public.project WHERE schema_name='trash'
UNION ALL SELECT 'auth_users', COUNT(*)::text FROM auth.users WHERE email IN ('superadmin@trash.com','suresh.kumar@trash.com')
UNION ALL SELECT 'public_user', COUNT(*)::text FROM public."user" pu JOIN public.project p ON pu.project_id=p.id WHERE p.schema_name='trash'
UNION ALL SELECT 'trash_users', COUNT(*)::text FROM trash.users WHERE "isDelete"=false
UNION ALL SELECT 'trash_drivers', COUNT(*)::text FROM trash.drivers WHERE "isDelete"=false
UNION ALL SELECT 'storage_bucket', COUNT(*)::text FROM storage.buckets WHERE id='trash'
UNION ALL SELECT 'jwt_hook_grant', COUNT(*)::text FROM information_schema.routine_privileges WHERE routine_name='custom_access_token_hook' AND grantee='supabase_auth_admin';
```

Expected all > 0. If any = 0 → re-run SETUP_TRASH.sql.

---

## Vue Store Pattern: fetchUser()

```ts
// Admin app (web-admin-app)
async fetchUser() {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null
  
  const { data } = await supabase
    .from('users')      // trash.users
    .select('*')
    .eq('authId', user.id)   // camelCase FK
    .single()
  
  this.user = data
}

// Driver app (web-driver-app) — reads drivers too
async fetchUser() {
  // ... same as above for trash.users ...
  
  const { data: driverData } = await supabase
    .from('drivers')
    .select('id, vehicleNo, ...')
    .eq('userId', data.id)   // FK from trash.drivers → trash.users
    .single()
  
  this.user = { ...data, driverId: driverData.id }
  // driverId is used for ALL task queries — NOT user.id
}
```

---

## camelCase vs snake_case in Supabase Schemas

This is a deliberate design decision. Pick one per schema and be consistent.

```
trash schema   → camelCase  (customerId, deliveryAddress, isDelete, createdAt)
public schema  → snake_case (auth_id, project_id, is_delete)
```

PostgREST returns column names exactly as defined in Postgres.  
Mixing up case causes **silent failures** (null results, no error message).

---

## FK Hints — When Supabase Can't Auto-Resolve

When a table has multiple FK relationships to the same target table,  
Supabase cannot determine which FK to use. You MUST provide an explicit hint:

```ts
// Without hint — Supabase picks wrong FK or fails:
order:orders(id, status, binSize:bin_sizes(id, name))   // ❌ may return null

// With explicit FK hint — always correct:
order:orders(
  id, status,
  binSize:bin_sizes!orders_binSizeId_fkey(id, name),    // ✅
  bin:bins!orders_binId_fkey(id, binCode),              // ✅
  customer:customers(id, name, phone)                    // ✅ single FK, no hint needed
)
```

**Rule:** Whenever a table has 2+ FK columns pointing to the same target, use `!fkey_name`.  
FK name format: `{table}_{column}_fkey` (Postgres default naming).

---

## Storage Pattern (Photo Upload)

```ts
// Bucket: 'trash' (public: true)
// Path structure:
driver_tasks/{taskId}/start-{timestamp}.jpg
driver_tasks/{taskId}/complete-{timestamp}.jpg
drivers/{driverId}/avatar-{timestamp}.jpg

// Upload:
const path = `driver_tasks/${taskId}/start-${Date.now()}.jpg`
const { error } = await supabase.storage.from('trash').upload(path, file)
const { data } = supabase.storage.from('trash').getPublicUrl(path)
const url = data.publicUrl
```

---

## Atomic Order Creation (RPC Pattern)

For operations that touch multiple tables, use a Postgres RPC function.  
This is better than client-side multi-step inserts (atomic, no partial failures).

```ts
// Creates order + 2 driver_tasks in one transaction
const { data, error } = await supabase.rpc('create_order_with_tasks', {
  order_no: 'ORD-2026-001',
  customer_id: 'uuid',
  driver_id: 'uuid',
  bin_size_id: 'uuid',
  delivery_date: '2026-05-28',
  delivery_address: '123 Jalan Example, Johor Bahru',
  bin_id: 'uuid',         // optional
  pickup_date: null,      // optional
  rental_days: 3,         // optional
  amount: 280,            // optional
  latitude: 1.5304,       // optional — from map pin
  longitude: 103.7618     // optional — from map pin
})
// Returns: { order_id: 'uuid' }
```

The RPC creates:
1. One row in `trash.orders`
2. One `delivery` task in `trash.driver_tasks`
3. One `pickup` task in `trash.driver_tasks`

---

## VITE_IS_MOCK Pattern (Development Seam)

```ts
// src/config/env.ts
export const env = {
  IS_MOCK: import.meta.env.VITE_IS_MOCK === 'true',
  SUPABASE_URL: import.meta.env.VITE_SUPABASE_URL,
  SUPABASE_ANON_KEY: import.meta.env.VITE_SUPABASE_ANON_KEY,
}

// In every store action:
async getAllTasks() {
  if (env.IS_MOCK) {
    this.items = [...MOCK_TASKS]   // hardcoded dev data
    return this.items
  }
  // ... real Supabase query
}
```

Keep `VITE_IS_MOCK=true` as default in `.env.development`.  
Switch to `false` only when testing real DB connectivity.  
**Vite does NOT hot-reload .env — restart dev server after changes.**
