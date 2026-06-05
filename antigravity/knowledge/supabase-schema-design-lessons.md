# Supabase Schema Design — Lessons from CY Roro Bin Rental

> Real-world schema design decisions, migration patterns, and RLS strategies  
> from a production bin rental management system with 26+ migrations.

---

## Schema Isolation Strategy

Separate schemas by concern:

```
public schema   → Auth bridge tables (user, project, role)
                  snake_case columns
                  Connects Supabase Auth to your business layer

trash schema    → Business tables (customers, orders, bins, drivers, tasks)
                  camelCase columns (matches TypeScript naming)
                  Can be dumped/restored independently
                  
storage schema  → Supabase managed (files, buckets)
auth schema     → Supabase managed (users, sessions)
```

**Why separate schemas?**
- Dump/restore only the business schema without breaking auth
- Different naming conventions per schema without conflicts
- Clear boundary: public = infrastructure, trash/your_schema = domain

---

## Complete Bin Rental Schema (Reference Implementation)

### Table Dependency Order (must create in this order)

```
1. trash.customers         (independent)
2. trash.users             (references auth.users via authId)
3. trash.drivers           (references trash.users via userId)
4. trash.bin_sizes         (independent — Small/Large/etc with price)
5. trash.bins              (references bin_sizes)
6. trash.orders            (references customers, drivers, bin_sizes, bins)
7. trash.driver_tasks      (references orders, drivers)
8. trash.attachments       (references any entity via polymorphic entityId)
9. trash.customer_transactions  (references customers, orders)
10. trash.driver_withdrawals    (references drivers)
11. trash.driver_bankaccounts   (references drivers)
```

### Key Design Decisions

#### Orders Table — The Central Entity
```sql
CREATE TABLE trash.orders (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  orderNo         TEXT NOT NULL UNIQUE,      -- human-readable ORD-2026-001
  customerId      UUID REFERENCES trash.customers(id),
  driverId        UUID REFERENCES trash.drivers(id),
  binSizeId       UUID REFERENCES trash.bin_sizes(id),
  binId           UUID REFERENCES trash.bins(id),
  deliveryAddress TEXT NOT NULL,
  deliveryDate    DATE NOT NULL,
  pickupDate      DATE,                      -- set when customer requests pickup
  rentalDays      INT DEFAULT 3,
  amount          NUMERIC(10,2),
  extraCharge     NUMERIC(10,2) DEFAULT 0,
  totalAmount     NUMERIC(10,2),
  status          TEXT DEFAULT 'pending',    -- see status flow below
  notes           TEXT,
  deliveredAt     TIMESTAMPTZ,
  pickedUpAt      TIMESTAMPTZ,
  latitude        FLOAT8,                   -- added migration 023
  longitude       FLOAT8,                   -- added migration 023
  isDelete        BOOLEAN DEFAULT false,
  createdAt       TIMESTAMPTZ DEFAULT now(),
  updatedAt       TIMESTAMPTZ DEFAULT now()
);
```

#### Order Status Flow
```
pending → assigned → delivering → delivered → pickingUp → completed
                                                         ↘ cancelled
                                                         ↘ failed
```

- `pending`: created, no driver yet
- `assigned`: driver assigned, not started
- `delivering`: driver en route to deliver bin
- `delivered`: bin dropped at customer site (rental clock starts)
- `pickingUp`: driver en route to collect bin
- `completed`: bin returned, order done
- `cancelled`/`failed`: terminal states

#### Driver Tasks Table — Operational Unit
```sql
CREATE TABLE trash.driver_tasks (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  taskNo          TEXT NOT NULL UNIQUE,   -- T-2026-001-DLV / T-2026-001-PUP
  orderId         UUID REFERENCES trash.orders(id),
  driverId        UUID REFERENCES trash.drivers(id),
  type            TEXT NOT NULL,          -- 'delivery' | 'pickup'
  scheduledDate   DATE,
  status          TEXT DEFAULT 'pending', -- 'pending' | 'inProgress' | 'completed' | 'cancelled'
  startPhotos     JSONB DEFAULT '[]',     -- array of storage URLs
  startCapturedAt TIMESTAMPTZ,
  startLatitude   FLOAT8,
  startLongitude  FLOAT8,
  startNote       TEXT,
  completePhotos  JSONB DEFAULT '[]',
  completeCapturedAt TIMESTAMPTZ,
  completeLatitude   FLOAT8,
  completeLongitude  FLOAT8,
  completeNote    TEXT,
  assignedAt      TIMESTAMPTZ,
  startedAt       TIMESTAMPTZ,
  completedAt     TIMESTAMPTZ,
  note            TEXT,
  isDelete        BOOLEAN DEFAULT false,
  createdAt       TIMESTAMPTZ DEFAULT now(),
  updatedAt       TIMESTAMPTZ DEFAULT now()
);
```

**Key insight:** Photos stored as JSONB string arrays (not separate table).  
Simple, queryable, no join needed for photo list.

#### Bin Sizes Table — Pricing Catalog
```sql
CREATE TABLE trash.bin_sizes (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name         TEXT NOT NULL,          -- '3 Yard', '6 Yard', '10 Yard', '12 Yard'
  description  TEXT,
  defaultPrice NUMERIC(10,2),          -- base price for this bin size
  status       TEXT DEFAULT 'active'   -- 'active' | 'inactive'
);
```

Real data: 3Y (RM280), 6Y (RM380), 10Y (RM580), 12Y (RM780)

#### Bins Table — Physical Fleet
```sql
CREATE TABLE trash.bins (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  binCode        TEXT NOT NULL UNIQUE,  -- 'BIN-001', 'BIN-002'
  binSizeId      UUID REFERENCES trash.bin_sizes(id),
  status         TEXT DEFAULT 'available',  -- 'available' | 'reserved' | 'inUse' | 'maintenance'
  currentOrderId UUID REFERENCES trash.orders(id),  -- which order is using it now
  notes          TEXT,
  isDelete       BOOLEAN DEFAULT false,
  createdAt      TIMESTAMPTZ DEFAULT now(),
  updatedAt      TIMESTAMPTZ DEFAULT now()
);
```

**Bin lifecycle:** available → reserved (order created) → inUse (delivered) → available (picked up)

---

## Atomic RPC Pattern (create_order_with_tasks)

Never create orders + tasks in separate client calls. Use a Postgres function:

```sql
CREATE OR REPLACE FUNCTION trash.create_order_with_tasks(
  order_no TEXT,
  customer_id UUID,
  driver_id UUID,
  bin_size_id UUID,
  delivery_date DATE,
  delivery_address TEXT,
  bin_id UUID DEFAULT NULL,
  pickup_date DATE DEFAULT NULL,
  rental_days INT DEFAULT 3,
  amount NUMERIC DEFAULT NULL,
  extra_charge NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'pending',
  notes TEXT DEFAULT NULL,
  latitude FLOAT8 DEFAULT NULL,
  longitude FLOAT8 DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
  v_order_id UUID;
  v_task_no_dlv TEXT;
  v_task_no_pup TEXT;
BEGIN
  -- 1. Insert order
  INSERT INTO trash.orders (...) VALUES (...) RETURNING id INTO v_order_id;

  -- 2. Generate task numbers
  v_task_no_dlv := REPLACE(order_no, 'ORD', 'T') || '-DLV';
  v_task_no_pup := REPLACE(order_no, 'ORD', 'T') || '-PUP';

  -- 3. Insert delivery task
  INSERT INTO trash.driver_tasks (taskNo, orderId, driverId, type, scheduledDate, ...)
  VALUES (v_task_no_dlv, v_order_id, driver_id, 'delivery', delivery_date, ...);

  -- 4. Insert pickup task
  INSERT INTO trash.driver_tasks (taskNo, orderId, driverId, type, scheduledDate, ...)
  VALUES (v_task_no_pup, v_order_id, driver_id, 'pickup', pickup_date, ...);

  RETURN v_order_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

Benefits:
- Atomic: all 3 rows created or none
- Single network round-trip from client
- Business logic lives in DB, not app code
- RLS bypass via SECURITY DEFINER (function runs as owner)

---

## RLS Policy Patterns

### Pattern 1: Role-based (JWT claim check)
```sql
-- Only super_admin can insert orders
CREATE POLICY orders_insert ON trash.orders
FOR INSERT TO authenticated
WITH CHECK (
  (current_setting('request.jwt.claims', true)::jsonb->>'user_role') = 'super_admin'
);
```

### Pattern 2: Row ownership (driver sees own tasks)
```sql
-- Driver sees only their own tasks
CREATE POLICY driver_tasks_select ON trash.driver_tasks
FOR SELECT TO authenticated
USING (
  "driverId" = (
    SELECT id FROM trash.drivers
    WHERE "userId" = (
      SELECT id FROM trash.users
      WHERE "authId" = auth.uid()
    )
  )
);
```

### Pattern 3: Admin sees all
```sql
-- Super admin sees everything
CREATE POLICY driver_tasks_admin_select ON trash.driver_tasks
FOR SELECT TO authenticated
USING (
  (current_setting('request.jwt.claims', true)::jsonb->>'user_role') = 'super_admin'
);
```

---

## Migration Naming Convention

```
{number}_{schema}_{feature}_{action}.sql

001_public_schema.sql
008_trash_customers_schema.sql
021_trash_order_workflow_rpc.sql
023_trash_orders_add_coordinates.sql
027_add_assigned_at_to_driver_tasks.sql
```

When two features are added in parallel (same migration number):
```
023_trash_drivers_photos.sql
023_trash_orders_add_coordinates.sql
```

Both run, order doesn't matter (no cross-dependency).

---

## isDelete Pattern (Soft Delete)

All business tables use `isDelete BOOLEAN DEFAULT false` instead of hard DELETE.

```sql
-- Always filter in queries:
.eq('isDelete', false)

-- To delete:
.update({ isDelete: true }).eq('id', id)

-- Unique constraints exclude soft-deleted rows:
CREATE UNIQUE INDEX customers_email_active
ON trash.customers(email)
WHERE "isDelete" = false;
```

**Why soft delete?**
- Audit trail preserved
- No cascade delete problems
- Can restore accidentally deleted records
- FK integrity maintained (hard delete breaks FKs)

---

## Coordinate Storage on Orders

Orders have `latitude` and `longitude` for map pin placement.  
Added in migration 023 as `FLOAT8 NULLABLE`.

The admin creates an order with a map pin → coordinates saved → MapView shows bin location.

In TypeScript interface:
```ts
interface DBOrder {
  latitude: number | null;   // FLOAT8 from Postgres → number in JS
  longitude: number | null;
}
```

Map uses `task.order.latitude` (not `task.latitude`) because coordinates belong to the order (where the bin is), not the task.

---

## Wallet / Withdrawal Pattern (driver_withdrawals)

Drivers have a wallet balance in `trash.drivers.walletBalance`.  
Withdrawals are tracked in `trash.driver_withdrawals`:

```sql
CREATE TABLE trash.driver_withdrawals (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  driverId    UUID REFERENCES trash.drivers(id),
  amount      NUMERIC(10,2),
  status      TEXT DEFAULT 'pending',  -- 'pending' | 'approved' | 'rejected' | 'paid'
  requestedAt TIMESTAMPTZ DEFAULT now(),
  processedAt TIMESTAMPTZ,
  notes       TEXT,
  isDelete    BOOLEAN DEFAULT false
);
```

Bank accounts stored in `trash.driver_bankaccounts` (separate table):
```sql
CREATE TABLE trash.driver_bankaccounts (
  id          UUID PRIMARY KEY,
  driverId    UUID REFERENCES trash.drivers(id),
  bankName    TEXT,
  accountNo   TEXT,
  accountName TEXT,
  isPrimary   BOOLEAN DEFAULT false,
  isDelete    BOOLEAN DEFAULT false
);
```

---

## Customer Transactions (Balance Tracking)

Customer balance tracked via `trash.customer_transactions`:

```sql
CREATE TABLE trash.customer_transactions (
  id          UUID PRIMARY KEY,
  customerId  UUID REFERENCES trash.customers(id),
  orderId     UUID REFERENCES trash.orders(id),
  type        TEXT,    -- 'payment' | 'refund' | 'credit'
  amount      NUMERIC(10,2),
  balance     NUMERIC(10,2),  -- running balance after transaction
  notes       TEXT,
  createdAt   TIMESTAMPTZ DEFAULT now()
);
```

Customer balance denormalized in `trash.customers.balance` for fast read.  
Transactions are the ledger; balance is the cache.
