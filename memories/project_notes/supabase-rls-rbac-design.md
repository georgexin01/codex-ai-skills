<!--
⚠️ JWT CLAIM CASING NOTE (added 2026-04-17)
This file uses camelCase JWT claim names for historical reasons: `projectId`, `role`, `roleLevel`.
The CURRENT CANONICAL names per admin-panel-quizLaa CLAUDE.md are snake_case:
  - `project_id`  (not `projectId`)
  - `user_role`   (not `role` — "role" is reserved by PostgREST for PG-role switching)
  - `role_level`  (not `roleLevel`)
When generating NEW SQL hooks / RLS policies, use snake_case. When reading EXISTING
running hook code, follow whatever the deployed hook actually injects (check Supabase dashboard).
Do NOT silently rename claim keys in a running system — existing JWTs would break until users re-login.
-->

---
name: supabase-rls-rbac-design
description: Multi-project RBAC and row-level security design — schemas, roles, JWT hooks, policies, edge functions.
triggers: ["rls design", "rbac", "row level security", "jwt auth hook", "permission matrix"]
phase: reference
requires: []
unlocks: []
inputs: []
output_format: architecture_reference
model_hint: gpt-5.3-codex
version: 2.0
---

# Supabase RLS and RBAC Architecture Design

> Multi-project, role-based access control system with row-level security## 1. NAMING CONVENTIONS (MANDATORY)

| Object | Convention | Example |
| :--- | :--- | :--- |
| **Schema** | snake_case | `project_alpha` |
| **Table** | snake_case plural | `order_items` |
| **Column** | camelCase (quoted) | `"firstName"` |
| **JWT Claim** | snake_case | `project_id` |

## 2. ARCHITECTURE DIAGRAM

```
┌─────────────────┐       ┌──────────────────────────────┐
│     project     │       │            user               │
│  ─────────────  │       │  ────────────────────────     │
│  id (uuid) PK ◄─┼───────┤  auth_id (uuid) FK ──────────► auth.users
│  schema_name    │       │  project_id (uuid) FK          │
└─────────────────┘       └──────────────────────────────┘
```

## 3. CORE SQL HOOKS (JWT CUSTOM CLAIMS)

```sql
CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event jsonb)
RETURNS jsonb SECURITY DEFINER AS $$
BEGIN
  -- Inject project_id, user_role, role_level
  claims := jsonb_set(claims, '{project_id}', to_jsonb(v_project_id));
  claims := jsonb_set(claims, '{user_role}', to_jsonb(v_role));
  RETURN jsonb_set(event, '{claims}', claims);
END;
$$;
```

## 4. PER-PROJECT PERMISSIONS

```sql
CREATE TABLE {project_schema}.permissions (
  id UUID PRIMARY KEY,
  "roleId" UUID REFERENCES public.role(id),
  resource TEXT,
  action TEXT,
  scope TEXT DEFAULT 'none'
);
```

## 5. RLS POLICY PATTERN

```sql
CREATE POLICY "dynamic_access" ON {project_schema}.entities
FOR SELECT USING (
  CASE
    WHEN {project_schema}.authorize('entities', 'read') THEN
      "project_id" = (auth.jwt() ->> 'project_id')::uuid
    ELSE false
  END
);
```

---
**Supabase RLS/RBAC Protocol V2.1 (Mini-Pulse) — 2026-05-01**
 user         (level=100) → Basic access, lowest        │
│                                                             │
│  Business roles (per project)                               │
│  ├── teacher      (level=50)  → test_school project         │
│  ├── student      (level=60)  → test_school project         │
│  ├── salesman     (level=50)  → other projects              │
│  ├── merchant     (level=50)  → other projects              │
│  └── ...          → future expansion                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Level Usage

The `level` field controls role hierarchy, used for:

1. **Creating users** - Can only create users with higher level (lower permission)
2. **Modifying roles** - Can only modify users with higher level
3. **Data access** - Higher permission can see more data

```
root_admin (level=0) attempts to modify user role
           │
           ▼
┌─────────────────────────┐
│ Check target user level  │
├─────────────────────────┤
│                         │
│  Target is super_admin? │
│  level=10 > 0           │
│  Allowed (lower perm.)  │
│                         │
│  Target is root_admin?  │
│  level=0 = 0            │
│  Denied (same level)    │
│                         │
└─────────────────────────┘
```

### Scope Description

The `scope` field determines data access range:

| Scope | Meaning | Example |
|-------|------|------|
| `all` | Access all data | admin sees all students |
| `own` | Access only own related data | teacher sees only own students |
| `none` | No access | student cannot delete any data |

### Permission Table Example

```
┌────────────┬───────────┬────────┬────────┬────────────────────────┐
│ role       │ resource  │ action │ scope  │ Description            │
├────────────┼───────────┼────────┼────────┼────────────────────────┤
│ root_admin │ *         │ *      │ all    │ Full permissions       │
├────────────┼───────────┼────────┼────────┼────────────────────────┤
│ super_admin│ students  │ create │ all    │ Full project perms     │
│ super_admin│ students  │ read   │ all    │                        │
│ super_admin│ students  │ update │ all    │                        │
│ super_admin│ students  │ delete │ all    │                        │
│ super_admin│ teachers  │ *      │ all    │                        │
│ super_admin│ subjects  │ *      │ all    │                        │
├────────────┼───────────┼────────┼────────┼────────────────────────┤
│ admin      │ students  │ create │ all    │ Manage students        │
│ admin      │ students  │ read   │ all    │                        │
│ admin      │ students  │ update │ all    │                        │
│ admin      │ teachers  │ read   │ all    │ Read-only teachers     │
│ admin      │ teachers  │ update │ all    │                        │
│ admin      │ subjects  │ *      │ all    │                        │
├────────────┼───────────┼────────┼────────┼────────────────────────┤
│ teacher    │ students  │ read   │ own    │ See only own students  │
│ teacher    │ students  │ update │ own    │                        │
│ teacher    │ teachers  │ read   │ own    │ See only self          │
│ teacher    │ subjects  │ read   │ all    │ Can see all subjects   │
├────────────┼───────────┼────────┼────────┼────────────────────────┤
│ student    │ students  │ read   │ own    │ See only self          │
│ student    │ teachers  │ read   │ own    │ See only own teachers  │
│ student    │ subjects  │ read   │ own    │ See only own subjects  │
├────────────┼───────────┼────────┼────────┼────────────────────────┤
│ user       │ subjects  │ read   │ all    │ Can only see public    │
└────────────┴───────────┴────────┴────────┴────────────────────────┘
```

---

## Auth Hook Design

### Purpose

The Auth Hook injects `projectId` and `role` into the JWT token during login, so RLS policies can read directly from JWT without querying the database.

### Implementation

```sql
-- Create Auth Hook function
CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event jsonb)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_project_id uuid;
  v_role text;
  v_role_level int;
  claims jsonb;
BEGIN
  -- 1. Query user's project_id and role from public."user"
  SELECT
    u.project_id,
    r.name,
    r.level
  INTO
    v_project_id,
    v_role,
    v_role_level
  FROM public."user" u
  JOIN public.role r ON u.role_id = r.id
  WHERE u.auth_id = (event->>'user_id')::uuid  -- event->>'user_id' is Supabase system key, cannot change
    AND u.is_delete = false
    AND u.status = 'active';

  -- 2. Get existing claims
  claims := event->'claims';

  -- 3. Inject custom claims (camelCase keys in JWT)
  IF v_project_id IS NOT NULL THEN
    claims := jsonb_set(claims, '{projectId}', to_jsonb(v_project_id));
  END IF;

  IF v_role IS NOT NULL THEN
    claims := jsonb_set(claims, '{role}', to_jsonb(v_role));
    claims := jsonb_set(claims, '{roleLevel}', to_jsonb(v_role_level));
  END IF;

  -- 4. Return modified event
  RETURN jsonb_set(event, '{claims}', claims);
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION public.custom_access_token_hook TO supabase_auth_admin;
REVOKE EXECUTE ON FUNCTION public.custom_access_token_hook FROM authenticated, anon, public;
```

### Using in RLS

```sql
-- Get projectId from JWT (no database query needed!)
(auth.jwt() ->> 'projectId')::uuid

-- Get role from JWT
auth.jwt() ->> 'role'

-- Get role level from JWT
(auth.jwt() ->> 'roleLevel')::int
```

---

## RLS Policies

### Helper Functions

```sql
-- Get current user's projectId from JWT
CREATE OR REPLACE FUNCTION public.get_current_project_id()
RETURNS uuid
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT (auth.jwt() ->> 'projectId')::uuid;
$$;

-- Get current user's role from JWT
CREATE OR REPLACE FUNCTION public.get_current_role()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT auth.jwt() ->> 'role';
$$;

-- Get current user's role level from JWT
CREATE OR REPLACE FUNCTION public.get_current_role_level()
RETURNS int
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT COALESCE((auth.jwt() ->> 'roleLevel')::int, 100);
$$;

-- Check permission and return scope
CREATE OR REPLACE FUNCTION test_school.get_permission_scope(
  p_resource text,
  p_action text
)
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT COALESCE(
    (
      SELECT scope
      FROM test_school.permissions p
      JOIN public.role r ON p."roleId" = r.id
      WHERE r.name = public.get_current_role()
        AND p.resource = p_resource
        AND p.action = p_action
        AND p."isDelete" = false
    ),
    'none'
  );
$$;

-- RLS authorization function
CREATE OR REPLACE FUNCTION test_school.authorize(
  p_resource text,
  p_action text
)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT test_school.get_permission_scope(p_resource, p_action) != 'none';
$$;
```

### public.user RLS

```sql
ALTER TABLE public."user" ENABLE ROW LEVEL SECURITY;

-- Users can only see themselves
CREATE POLICY "user_select_self" ON public."user"
FOR SELECT TO authenticated
USING (auth.uid() = auth_id);

-- Users can update themselves (partial fields restricted via Edge Function)
CREATE POLICY "user_update_self" ON public."user"
FOR UPDATE TO authenticated
USING (auth.uid() = auth_id);

-- Create/delete only through Edge Function (service_role)
```

### public.project RLS

```sql
ALTER TABLE public.project ENABLE ROW LEVEL SECURITY;

-- Users can only see their own project
CREATE POLICY "project_select_own" ON public.project
FOR SELECT TO authenticated
USING (
  id = public.get_current_project_id()
);
```

### public.role RLS

```sql
ALTER TABLE public.role ENABLE ROW LEVEL SECURITY;

-- All authenticated users can read roles (public list)
CREATE POLICY "role_select_all" ON public.role
FOR SELECT TO authenticated
USING (is_delete = false);
```

### test_school.students RLS

```sql
ALTER TABLE test_school.students ENABLE ROW LEVEL SECURITY;

-- SELECT policy with scope check
CREATE POLICY "students_select" ON test_school.students
FOR SELECT TO authenticated
USING (
  CASE
    -- scope = 'all' → see all students in project
    WHEN test_school.get_permission_scope('students', 'read') = 'all' THEN
      "isDelete" = false

    -- scope = 'own' and role = 'teacher' → see only own students
    WHEN test_school.get_permission_scope('students', 'read') = 'own'
         AND public.get_current_role() = 'teacher' THEN
      "isDelete" = false AND (
        -- Homeroom teacher's students
        "homeroomTeacherId" IN (
          SELECT id FROM test_school.teachers
          WHERE "userId" = (SELECT id FROM public."user" WHERE auth_id = auth.uid())
        )
        OR
        -- Students via student_teachers association
        id IN (
          SELECT "studentId" FROM test_school.student_teachers
          WHERE "teacherId" IN (
            SELECT id FROM test_school.teachers
            WHERE "userId" = (SELECT id FROM public."user" WHERE auth_id = auth.uid())
          )
        )
      )

    -- scope = 'own' and role = 'student' → see only self
    WHEN test_school.get_permission_scope('students', 'read') = 'own'
         AND public.get_current_role() = 'student' THEN
      "isDelete" = false AND
      "userId" = (SELECT id FROM public."user" WHERE auth_id = auth.uid())

    ELSE false
  END
);

-- UPDATE policy
CREATE POLICY "students_update" ON test_school.students
FOR UPDATE TO authenticated
USING (
  CASE
    WHEN test_school.get_permission_scope('students', 'update') = 'all' THEN
      "isDelete" = false
    WHEN test_school.get_permission_scope('students', 'update') = 'own'
         AND public.get_current_role() = 'teacher' THEN
      "isDelete" = false AND (
        "homeroomTeacherId" IN (
          SELECT id FROM test_school.teachers
          WHERE "userId" = (SELECT id FROM public."user" WHERE auth_id = auth.uid())
        )
      )
    ELSE false
  END
);

-- INSERT policy
CREATE POLICY "students_insert" ON test_school.students
FOR INSERT TO authenticated
WITH CHECK (
  test_school.authorize('students', 'create')
);

-- DELETE policy
CREATE POLICY "students_delete" ON test_school.students
FOR DELETE TO authenticated
USING (
  test_school.authorize('students', 'delete')
);
```

---

## Edge Functions

### Why Edge Functions Are Needed

Security-sensitive operations **must** be done on the backend:

```
┌─────────────────────────────────────────────────────────────┐
│              Operations Requiring Backend Processing          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Creating users (check role level)                          │
│  Modifying user roles (check role level)                    │
│  Deleting users (check role level)                          │
│  Using coupons / deducting points                           │
│  Any operation involving money, permissions, or inventory   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Directory Structure

```
project-root/
└── supabase/
    ├── config.toml
    ├── migrations/
    │   ├── 001_public_schema.sql
    │   ├── 002_test_school_schema.sql
    │   └── 003_rls_policies.sql
    └── functions/
        ├── create-user/
        │   └── index.ts
        ├── update-user-role/
        │   └── index.ts
        ├── delete-user/
        │   └── index.ts
        └── use-coupon/
            └── index.ts
```

### Edge Function Security

```
┌─────────────────────────────────────────────────────────────┐
│                 Edge Function Architecture                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Client (Browser)                                           │
│       │                                                     │
│       │ Only sends: { email, password, roleId }              │
│       │ Cannot see: SERVICE_ROLE_KEY                        │
│       ▼                                                     │
│  ┌─────────────────────────────────────────┐                │
│  │       Supabase Edge Function            │                │
│  │       (runs on Supabase server)         │                │
│  │                                         │                │
│  │  Environment vars (server-side,         │                │
│  │  invisible to attackers):               │                │
│  │  ├── SUPABASE_URL                       │                │
│  │  └── SUPABASE_SERVICE_ROLE_KEY          │                │
│  │                                         │                │
│  └─────────────────────────────────────────┘                │
│       │                                                     │
│       │ Uses SERVICE_ROLE_KEY to operate database            │
│       ▼                                                     │
│  ┌─────────────────────────────────────────┐                │
│  │            Supabase Database            │                │
│  └─────────────────────────────────────────┘                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Permission Check Flow

```
┌─────────────────────────────────────────────────────────────┐
│                Create User Permission Check                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  root_admin (level=0)                                       │
│       │                                                     │
│       ├── Can create super_admin (level=10)                 │
│       ├── Can create admin (level=20)                       │
│       ├── Can create teacher (level=50)                     │
│       └── Can create user (level=100)                       │
│                                                             │
│  super_admin (level=10)                                     │
│       │                                                     │
│       ├── Cannot create root_admin (level=0)                │
│       ├── Cannot create super_admin (level=10) ← same level │
│       ├── Can create admin (level=20)                       │
│       ├── Can create teacher (level=50)                     │
│       └── Can create user (level=100)                       │
│                                                             │
│  admin (level=20)                                           │
│       │                                                     │
│       ├── Cannot create root_admin                          │
│       ├── Cannot create super_admin                         │
│       ├── Cannot create admin                               │
│       ├── Can create teacher (level=50)                     │
│       └── Can create user (level=100)                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Sensitive Field Handling (View Approach)

If you need to hide certain fields in the future (e.g., teacher salary visible only to upper management), use the View approach:

```sql
-- Create View that returns different fields based on role
CREATE VIEW test_school.teachers_view
WITH (security_invoker = true)
AS
SELECT
  id,
  "userId",
  name,
  email,
  phone,
  status,
  -- Only super_admin and above (level <= 10) can see salary
  CASE
    WHEN (SELECT public.get_current_role_level()) <= 10
    THEN salary
    ELSE NULL
  END AS salary
FROM test_school.teachers;

-- Frontend queries the View instead of the raw table
-- admin sees: { ..., salary: null }
-- super_admin sees: { ..., salary: 50000 }
```

---

## Security Considerations

### 1. Brute Force Protection (Built-in)

Supabase Auth includes:
- Login attempt rate limiting
- Temporary IP blocking
- Optional CAPTCHA (hCaptcha / Cloudflare Turnstile)
- MFA support (TOTP)

### 2. RLS is Mandatory

```
Warning: All tables exposed through the API must have RLS enabled!

- Tables without RLS can be accessed freely
- Always test RLS policies before deployment
- Use Supabase Security Advisor to check
```

### 3. Service Role Key Protection

```
┌─────────────────────────────────────────────────────────────┐
│                      Key Security                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  NEVER expose service_role key in the frontend              │
│  NEVER commit service_role key to git                       │
│  ONLY use in Edge Functions (Deno.env.get)                  │
│  ONLY use on backend servers                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4. JWT Claims Security

```
Use raw_app_metadata (not raw_user_metadata) for authorization data:

- raw_app_metadata: Users CANNOT modify it themselves
- raw_user_metadata: Users CAN modify it themselves
```

### 5. Defense in Depth

```
Layer 1: Authentication (Supabase Auth)
    │
    ▼
Layer 2: JWT Claims (Auth Hook injects projectId, role)
    │
    ▼
Layer 3: RLS Policies (row-level access control)
    │
    ▼
Layer 4: Edge Functions (business logic validation)
    │
    ▼
Layer 5: Database Constraints (foreign keys, unique, check)
```

---

## Quick Reference

### Supabase CLI Commands

```bash
# Initialize Supabase
supabase init

# Create new Edge Function
supabase functions new function-name

# Deploy Edge Functions
supabase functions deploy

# Run database migrations
supabase db push

# Generate types
supabase gen types typescript --local > types/supabase.ts
```

### RLS Policy Templates

```sql
-- Enable RLS (table names are snake_case plural)
ALTER TABLE schema.entities ENABLE ROW LEVEL SECURITY;

-- SELECT policy
CREATE POLICY "entities_select" ON schema.entities
FOR SELECT TO authenticated
USING (/* condition */);

-- INSERT policy
CREATE POLICY "entities_insert" ON schema.entities
FOR INSERT TO authenticated
WITH CHECK (/* condition */);

-- UPDATE policy
CREATE POLICY "entities_update" ON schema.entities
FOR UPDATE TO authenticated
USING (/* row selection condition */)
WITH CHECK (/* new value validation condition */);

-- DELETE policy
CREATE POLICY "entities_delete" ON schema.entities
FOR DELETE TO authenticated
USING (/* condition */);
```

### Accessing JWT in Policies

```sql
-- Get authenticated user's ID
auth.uid()

-- Get custom claim (camelCase keys)
auth.jwt() ->> 'projectId'

-- Get nested claim
auth.jwt() -> 'app_metadata' ->> 'projectId'
```

---

## WhatsApp OTP Login

### Overview

Uses Twilio WhatsApp API to send OTP verification codes, approximately 18x cheaper than SMS.

| Method | Malaysia Price |
|-----|-------------|
| SMS | ~RM 1.17/msg |
| WhatsApp | ~RM 0.063/msg |

### Login Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         WhatsApp OTP Login Flow                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  User enters phone number + projectId (from domain)                         │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────────────────────────────┐                                    │
│  │ 1. Call send-otp Edge Function       │                                    │
│  │    - Check if public."user" exists   │                                    │
│  │    - Generate 6-digit OTP           │                                    │
│  │    - Store in public.otp_verification  │                                  │
│  │    - Send via Twilio WhatsApp       │                                    │
│  └─────────────────┬───────────────────┘                                    │
│                    │                                                        │
│                    ▼                                                        │
│  User receives WhatsApp code, enters verification code                      │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────────────────────────────┐                                    │
│  │ 2. Call verify-otp Edge Function     │                                    │
│  │    - Verify OTP is correct & valid   │                                    │
│  │    - Query public.user for info      │                                    │
│  │    - Create or update auth.users    │                                    │
│  │    - Generate JWT Token             │                                    │
│  └─────────────────┬───────────────────┘                                    │
│                    │                                                        │
│                    ▼                                                        │
│  Return JWT Token, user login successful                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### OTP Verification Table

```sql
-- OTP verification record table
CREATE TABLE public.otp_verification (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT NOT NULL,
  project_id UUID NOT NULL REFERENCES public.project(id),
  otp_code TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  verified BOOLEAN NOT NULL DEFAULT false,
  attempts INT NOT NULL DEFAULT 0,  -- attempt count, prevents brute force
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Same phone+project can only have one valid OTP within 5 minutes
  UNIQUE(phone, project_id, otp_code)
);

CREATE INDEX idx_otp_verification_phone_project_id ON public.otp_verification(phone, project_id);
CREATE INDEX idx_otp_verification_expires_at ON public.otp_verification(expires_at);

-- Auto-cleanup expired OTPs (optional, via pg_cron)
-- SELECT cron.schedule('cleanup-expired-otp', '*/10 * * * *',
--   $$DELETE FROM public.otp_verification WHERE expires_at < now()$$);
```

### Environment Variable Configuration

Add to `.env` file:

```bash
# Twilio WhatsApp OTP
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886
```

Add environment variables to the `functions` service in `docker-compose.yml`:

```yaml
functions:
  environment:
    # ... other environment variables
    TWILIO_ACCOUNT_SID: ${TWILIO_ACCOUNT_SID}
    TWILIO_AUTH_TOKEN: ${TWILIO_AUTH_TOKEN}
    TWILIO_WHATSAPP_FROM: ${TWILIO_WHATSAPP_FROM}
```

### Twilio Setup Steps

1. Register Twilio account: https://www.twilio.com/try-twilio
2. Go to Console → Messaging → Try it out → Send a WhatsApp message
3. Send join code from your phone's WhatsApp to `+1 415 523 8886` to join the Sandbox
4. Get Account SID and Auth Token (Account Dashboard → Account Info)
5. Configure environment variables and restart the functions service

### Production Notes

1. **Apply for a WhatsApp Business number** - Replace the Sandbox test number
2. **Rate limit sends** - Prevent abuse (60-second limit already implemented in code)
3. **Limit attempts** - Prevent brute force (5-attempt limit already implemented in code)
4. **Regularly clean up expired OTPs** - Use pg_cron or scheduled tasks
5. **Regenerate Auth Token** - If it has been leaked

---

## Frontend Authentication Integration (Vue + Vben Admin)

### Architecture Design

The frontend authentication system supports two modes, automatically switched via the `VITE_NITRO_MOCK` environment variable:

```
┌─────────────────────────────────────────────────────────────┐
│                    Pinia Store (auth.ts)                     │
│                                                              │
│   Calls unified APIs: loginApi, logoutApi, getUserInfoApi    │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                   auth.ts (unified entry)                    │
│                                                              │
│   Auto-switches based on VITE_NITRO_MOCK env variable:      │
│   ┌─────────────────┐      ┌─────────────────┐              │
│   │ Mock mode       │      │ Supabase mode   │              │
│   │ VITE_NITRO_MOCK │      │ VITE_NITRO_MOCK │              │
│   │ = true          │      │ = false         │              │
│   │                 │      │                 │              │
│   │ requestClient   │      │ supabase-auth   │              │
│   │ /auth/login     │      │ Supabase Auth   │              │
│   └─────────────────┘      └─────────────────┘              │
└─────────────────────────────────────────────────────────────┘
```

### 4 Run Modes

The app has 4 possible run modes based on two axes: **environment** (dev/prod) and **data source** (mock/Supabase):

| Mode | Command | Env File | `VITE_NITRO_MOCK` | API Target | Status |
| --- | --- | --- | --- | --- | --- |
| Dev Mock | `pnpm dev:antd` | `.env.development` | `true` | localhost:5320 (Nitro mock) | Active |
| Dev Supabase | `pnpm dev:supabase` | `.env.development.supabase` | `false` | Supabase (SSH tunnel / direct) | Active |
| Prod Mock | `pnpm build:antd` | `.env.production` | `true` | Remote mock backend (e.g. Render.com) | Active |
| Prod Supabase | `pnpm build:antd --mode production.supabase` | `.env.production.supabase` | `false` | Production Supabase URL | Not yet set up |

### How Mode Switching Works

The **single switch** is `VITE_NITRO_MOCK`:

```
VITE_NITRO_MOCK=true  → All API calls go through requestClient (axios) → Mock backend
VITE_NITRO_MOCK=false → All API calls go through Supabase client → Supabase database
```

The app code auto-selects the correct path — no code changes needed to switch modes.

### Environment Configuration Files

All env files are in `apps/web-antd/`:

**`.env.development` (Dev Mock):**
```bash
VITE_PORT=5666
VITE_NITRO_MOCK=true
VITE_GLOB_API_URL=/api          # Proxied to localhost:5320/api
```

**`.env.development.supabase` (Dev Supabase):**
```bash
VITE_PORT=5666
VITE_NITRO_MOCK=false
VITE_GLOB_API_URL=http://localhost:8000         # Supabase Kong API via SSH tunnel
VITE_SUPABASE_URL=http://localhost:8000
VITE_SUPABASE_ANON_KEY=eyJhbGciOi...            # Supabase anon JWT
VITE_SUPABASE_SCHEMA=wms                        # Project business schema
```

**`.env.production` (Prod Mock):**
```bash
VITE_NITRO_MOCK=true
VITE_GLOB_API_URL=https://wms-backend-mock.onrender.com/api   # Remote mock backend
VITE_ARCHIVER=true                                             # Generates dist.zip
```

**`.env.production.supabase` (Prod Supabase) — to be created:**
```bash
VITE_NITRO_MOCK=false
VITE_GLOB_API_URL=https://{your-supabase-domain}
VITE_SUPABASE_URL=https://{your-supabase-domain}
VITE_SUPABASE_ANON_KEY={production-anon-key}
VITE_SUPABASE_SCHEMA={project-schema}
VITE_ARCHIVER=true
```

### Adding the Supabase Dev Command

The `dev:supabase` command uses Vite's `--mode` flag to load a different env file:

```jsonc
// apps/web-antd/package.json
{
  "scripts": {
    "dev": "pnpm vite",                                    // loads .env.development
    "dev:supabase": "pnpm vite --mode development.supabase" // loads .env.development.supabase
  }
}

// Root package.json
{
  "scripts": {
    "dev:supabase": "pnpm -F @vben/web-antd run dev:supabase"
  }
}
```

The same pattern applies for production: `--mode production.supabase` would load `.env.production.supabase`.

### Key Variables Reference

| Variable | Description | Mock | Supabase |
| --- | --- | --- | --- |
| `VITE_NITRO_MOCK` | Master switch | `true` | `false` |
| `VITE_GLOB_API_URL` | Base API URL | Mock backend URL | Supabase Kong URL |
| `VITE_SUPABASE_URL` | Supabase endpoint | Not needed | Required |
| `VITE_SUPABASE_ANON_KEY` | Supabase anon JWT | Not needed | Required |
| `VITE_SUPABASE_SCHEMA` | Business schema name | Not needed | Required (e.g. `wms`) |
| `VITE_ARCHIVER` | Generate dist.zip on build | Optional | Optional |

### Key Files

| File | Description |
|------|------|
| `apps/web-antd/src/api/core/auth.ts` | **Unified auth API entry** - Store only calls this file |
| `apps/web-antd/src/api/core/supabase-auth.ts` | Supabase Auth implementation (internal use) |
| `apps/web-antd/src/api/supabase.ts` | Supabase client (supports dual schema) |
| `apps/web-antd/src/stores/auth.ts` | Auth Store - only calls unified API |

### Supabase Client Design

Supports dual schema access:
- **public schema** - For `user`, `role`, `project` tables and authentication
- **Business schema** (e.g., `test_school`) - For business data tables

```typescript
// supabase.ts automatically selects schema based on table name
const authTables = ['user', 'role', 'project'];
// Auth-related tables (public schema) use snake_case singular — don't touch
// Business tables (project schema) use snake_case plural (e.g., 'customers', 'inventory_details')
// Business tables use the schema configured in VITE_SUPABASE_SCHEMA
```

### Verifying Database Connection

After running `pnpm dev:supabase`, confirm connection through:

#### 1. Browser Console Check

Open http://localhost:5666, press F12 to open developer tools, check the Console:
- If there's no "Supabase not configured, falling back to mock mode" warning, it's connected
- During login, check Network requests - they should go to `https://api.zeta-groups.com/auth/v1/token`

#### 2. Login Test

Log in with test users from the database:
- `admin@testschool.com` / `Admin123!`
- `teacher@testschool.com` / `Teacher123!`
- `student@testschool.com` / `Student123!`

If login succeeds and shows the correct username, the database is connected.

#### 3. Network Request Confirmation

In the browser Network panel:
- **Mock mode**: Requests go to `/api/auth/login`
- **Supabase mode**: Requests go to `https://api.zeta-groups.com/auth/v1/token?grant_type=password`

#### 4. JWT Token Check

After successful login, check the access token in browser Application → Local Storage. When decoded, it should contain:
- `projectId` - Project ID
- `role` - User role (admin/teacher/student)
- `roleLevel` - Role level

---

## Test Users (test_school project)

### Created Test Users

| User | Email | Password | Role | Permission Level |
|------|-------|------|------|---------|
| Zhang Admin | admin@testschool.com | Admin123! | admin | 20 |
| Li Teacher | teacher@testschool.com | Teacher123! | teacher | 50 |
| Wang Student | student@testschool.com | Student123! | student | 60 |

### Database Records

**public.user records:**
- All users linked to `test_school` project (`faaa3fb0-0780-4645-aab7-ce3034fd09a3`)
- Each user has a corresponding `role_id` link

**auth.users records:**
- Corresponding auth users have been created
- Passwords encrypted with bcrypt
- `email_confirmed_at` is set (no email verification needed)
- `phone_confirmed_at` is set

**Link status:**
- `public."user".auth_id` is linked to `auth.users.id`
- Auth Hook injects `projectId`, `role`, `roleLevel` into JWT on login

### User Creation SQL Reference

```sql
-- 1. Create public."user" record
INSERT INTO public."user" (project_id, role_id, name, email, phone, status) VALUES
  ('faaa3fb0-0780-4645-aab7-ce3034fd09a3',
   (SELECT id FROM public.role WHERE name = 'admin'),
   'Zhang Admin', 'admin@testschool.com', '+60123456789', 'active');

-- 2. Create auth.users record (Supabase system table - column names are fixed by Supabase)
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  phone, phone_confirmed_at, raw_app_meta_data, raw_user_meta_data,
  is_super_admin, created_at, updated_at, confirmation_token,
  email_change, email_change_token_new, recovery_token,
  email_change_confirm_status, is_sso_user, is_anonymous
) VALUES (
  '00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated',
  'admin@testschool.com', crypt('Admin123!', gen_salt('bf')), now(),
  '+60123456789', now(), '{"provider": "email", "providers": ["email"]}',
  '{"name": "Zhang Admin"}', false, now(), now(), '', '', '', '', 0, false, false
);

-- 3. Link authId
UPDATE public."user" u
SET auth_id = a.id
FROM auth.users a
WHERE u.email = a.email AND u.auth_id IS NULL;
```

### Auth Hook Configuration

Add to `/opt/supabase/supabase/docker/.env`:

```bash
GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_ENABLED=true
GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_URI=pg-functions://postgres/public/custom_access_token_hook
```

Takes effect after restarting Docker services.

---

## Reference Documentation

- [Supabase RLS Documentation](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Supabase Custom Claims & RBAC](https://supabase.com/docs/guides/database/postgres/custom-claims-and-role-based-access-control-rbac)
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Hardening Data API](https://supabase.com/docs/guides/database/hardening-data-api)
- [PostgreSQL Roles](https://supabase.com/docs/guides/database/postgres/roles)
- [Supabase Vault](https://supabase.com/docs/guides/database/vault)
- [Twilio WhatsApp API](https://www.twilio.com/docs/whatsapp/api)
- [Twilio SMS Pricing Malaysia](https://www.twilio.com/en-us/sms/pricing/my)

