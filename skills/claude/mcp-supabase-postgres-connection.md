---
name: mcp-supabase-postgres-connection
description: Configuration guide for self-hosted Supabase MCP PostgreSQL connection via SSH tunnel.
triggers: ["mcp postgres", "mcp supabase", "postgres connection", "ssh tunnel postgres"]
phase: reference
requires: []
unlocks: []
inputs: []
output_format: setup_guide
model_hint: gpt-5.3-codex
version: 2.0
---

# MCP PostgreSQL Connection to Supabase Configuration Guide

> Self-hosted Supabase MCP PostgreSQL connection configuration and troubleshooting

---

## Table of Contents

1. [Overview](#overview)
2. [Environment Information](#environment-information)
3. [Problems and Solutions](#problems-and-solutions)
4. [Configuration Steps](#configuration-steps)
5. [Common Error Troubleshooting](#common-error-troubleshooting)
6. [Verify Connection](#verify-connection)

---

## Overview

### Goal

Use MCP (Model Context Protocol) to let Claude Code connect directly to a self-hosted Supabase PostgreSQL database, enabling:
- Direct SQL query execution
- Creating/modifying database structures
- Managing RLS policies
- Operating the database without leaving Claude Code

### Tools Used

- **MCP Server**: `@modelcontextprotocol/server-postgres`
- **Database**: Self-hosted Supabase PostgreSQL
- **SSH Tunnel**: PuTTY (connecting from Windows to remote server)

---

## Environment Information

### Server Configuration

```
Remote server: [your server IP]
Docker Compose path: /opt/supabase/supabase/docker/docker-compose.yml
PostgreSQL container name: supabase-db
PostgreSQL internal port: 5432
PostgreSQL password: <YOUR_POSTGRES_PASSWORD>
```

### Local Configuration

```
SSH tunnel tool: PuTTY
Local forwarding port: 5433 -> localhost:5433
MCP config file: C:\Users\koo_c\.claude.json
```

---

## Problems and Solutions

### Problem 1: Tenant or user not found

**Error message**:
```
MCP error -32603: Tenant or user not found
```

**Root cause analysis**:

In the default Supabase architecture, port 5432 is handled by **supabase-pooler (Supavisor)**:

```
┌─────────────────────────────────────────────────────────────┐
│                  Supabase Docker Architecture                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Client connection → :5432 → supabase-pooler (Supavisor)  │
│                              │                              │
│                              │ Requires tenant ID           │
│                              │ Username format:             │
│                              │ postgres.{tenant_id}         │
│                              ▼                              │
│                        supabase-db                          │
│                        (actual PostgreSQL)                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Supavisor is a connection pooler designed for **multi-tenant SaaS**, expecting username format `postgres.{tenant_id}`.

**Solution**:

Bypass Supavisor by directly exposing the supabase-db port:

1. Modify `docker-compose.yml` to add port mapping for the `db` service:

```yaml
db:
  # ... other config ...
  ports:
    - "5433:5432"  # New: directly expose database port
```

2. Restart Docker services:

```bash
cd /opt/supabase/supabase/docker
sudo docker-compose down
sudo docker-compose up -d
```

3. Verify port mapping:

```bash
sudo docker port supabase-db
# Expected output: 5432/tcp -> 0.0.0.0:5433
```

### Problem 2: Special Characters in Password

**Problem**:

The PostgreSQL password `<YOUR_POSTGRES_PASSWORD>` contains:
- `+` (plus sign)
- `=` (equals sign)

These characters have special meaning in URLs and need URL encoding.

**Solution**:

URL-encode the password:
- `+` → `%2B`
- `=` → `%3D`

Encoded password: `<YOUR_URL_ENCODED_PASSWORD>`

---

## Configuration Steps

### Step 1: Modify Docker Compose (Server Side)

Edit `/opt/supabase/supabase/docker/docker-compose.yml`:

```yaml
db:
  container_name: supabase-db
  image: supabase/postgres:15.6.1.143
  # ... other config ...
  ports:
    - "5433:5432"  # Add this line
```

### Step 2: Restart Docker Services

```bash
cd /opt/supabase/supabase/docker
sudo docker-compose down
sudo docker-compose up -d
```

### Step 3: Configure PuTTY SSH Tunnel

1. Open PuTTY
2. Go to `Connection > SSH > Tunnels`
3. Add new port forwarding:
   - Source port: `5433`
   - Destination: `localhost:5433`
   - Click `Add`
4. Save session and connect

### Step 4: Configure MCP

Edit `C:\Users\koo_c\.claude.json`, add or modify MCP configuration:

```json
{
  "projects": {
    "C:/Users/koo_c/Documents/admin-panel-teacher-student-v1": {
      "mcpServers": {
        "supabase-db": {
          "type": "stdio",
          "command": "npx",
          "args": [
            "-y",
            "@modelcontextprotocol/server-postgres",
            "postgresql://postgres:<YOUR_URL_ENCODED_PASSWORD>@127.0.0.1:5433/postgres"
          ],
          "env": {}
        }
      }
    }
  }
}
```

**Connection string format**:
```
postgresql://username:password(URL-encoded)@host:port/database
```

### Step 5: Restart Claude Code

**Important**: MCP configuration changes require restarting Claude Code to take effect!

1. Close the Claude Code panel in VS Code
2. Reopen Claude Code

---

## Common Error Troubleshooting

### Error Checklist

```
┌─────────────────────────────────────────────────────────────┐
│                  Connection Troubleshooting                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Is the SSH tunnel working?                              │
│     □ Is PuTTY connected?                                   │
│     □ Has port 5433 forwarding been added?                  │
│     □ Did you reconnect PuTTY after adding forwarding?      │
│                                                             │
│  2. Is the local port listening?                            │
│     Run: netstat -an | findstr "5433"                       │
│     Expected: TCP 127.0.0.1:5433 LISTENING                  │
│                                                             │
│  3. Is the Docker port correctly mapped?                    │
│     Run (server): sudo docker port supabase-db              │
│     Expected: 5432/tcp -> 0.0.0.0:5433                      │
│                                                             │
│  4. Is the password correctly URL-encoded?                  │
│     + → %2B                                                 │
│     = → %3D                                                 │
│                                                             │
│  5. Has Claude Code been restarted?                         │
│     MCP config changes require a restart!                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Verification Commands

**Windows local**:
```cmd
# Check if port is listening
netstat -an | findstr "5433"
```

**Server side**:
```bash
# Check Docker port mapping
sudo docker port supabase-db

# Check container status
sudo docker ps | grep supabase-db

# Test database connection directly
sudo docker exec -it supabase-db psql -U postgres -c "SELECT 1;"
```

---

## Verify Connection

After MCP connection succeeds, verify with the following SQL:

```sql
-- Test connection
SELECT 1 as test;

-- View all schemas
SELECT schema_name FROM information_schema.schemata;

-- View tables in a specific schema
SELECT table_name FROM information_schema.tables WHERE table_schema = 'test_school';

-- View version
SELECT version();
```

---

## Architecture Diagram

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         Complete Connection Architecture                  │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   Windows Local                                                          │
│   ┌─────────────────────┐                                                │
│   │    Claude Code      │                                                │
│   │         │           │                                                │
│   │    MCP Server       │                                                │
│   │  (server-postgres)  │                                                │
│   │         │           │                                                │
│   │   127.0.0.1:5433    │                                                │
│   └─────────┬───────────┘                                                │
│             │                                                            │
│             │ SSH Tunnel (PuTTY)                                         │
│             │ L5433:localhost:5433                                       │
│             ▼                                                            │
│   ┌─────────────────────────────────────────────────────────┐            │
│   │                    Remote Server                         │            │
│   │  ┌─────────────────────────────────────────────────┐    │            │
│   │  │                 Docker                          │    │            │
│   │  │                                                 │    │            │
│   │  │   ┌───────────────────┐    ┌────────────────┐  │    │            │
│   │  │   │  supabase-pooler  │    │   supabase-db  │  │    │            │
│   │  │   │   (Supavisor)     │    │  (PostgreSQL)  │  │    │            │
│   │  │   │                   │    │                │  │    │            │
│   │  │   │  :6543 (external) │    │  :5432 (int.)  │◄─┼────┼── :5433   │
│   │  │   │  :5432 (internal) │───►│                │  │    │  (direct) │
│   │  │   │                   │    │                │  │    │            │
│   │  │   └───────────────────┘    └────────────────┘  │    │            │
│   │  │                                                 │    │            │
│   │  │   Note: We bypass pooler and connect to db      │    │            │
│   │  │   directly                                      │    │            │
│   │  └─────────────────────────────────────────────────┘    │            │
│   └─────────────────────────────────────────────────────────┘            │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Quick Reference

### MCP Connection String

```
postgresql://postgres:<YOUR_URL_ENCODED_PASSWORD>@127.0.0.1:5433/postgres
```

### URL Encoding Table

| Original Character | Encoded |
|---------|--------|
| `+`     | `%2B`  |
| `=`     | `%3D`  |
| `/`     | `%2F`  |
| `@`     | `%40`  |
| `:`     | `%3A`  |
| `?`     | `%3F`  |
| `#`     | `%23`  |
| `&`     | `%26`  |

### Key File Locations

| File | Location |
|------|------|
| MCP config | `C:\Users\koo_c\.claude.json` |
| Docker Compose | `/opt/supabase/supabase/docker/docker-compose.yml` |
| Supabase RLS design | `~/.claude/skills/supabase-rls-rbac-design.md` |

---

## Connection Success Confirmation

After successful connection, you can view all Supabase built-in schemas:

```
_realtime      - Realtime features
auth           - Authentication system
extensions     - PostgreSQL extensions
graphql        - GraphQL features
graphql_public - GraphQL public interface
net            - Network features
pgbouncer      - Connection pooling
public         - Public schema (user data)
realtime       - Real-time subscriptions
storage        - File storage
supabase_functions - Edge Functions
vault          - Secret management
```

---

## Related Documentation

- [MCP PostgreSQL Server](https://github.com/modelcontextprotocol/servers/tree/main/src/postgres)
- [Supabase Self-Hosting Guide](https://supabase.com/docs/guides/self-hosting)
- [Supabase Docker Architecture](https://supabase.com/docs/guides/self-hosting/docker)

