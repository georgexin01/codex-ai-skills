# Claude Relation And Coverage Handoff

Use this alongside `WORKING_PROGRESS.md` whenever an admin panel already has a live schema.

## Mandatory checks before building the next module

1. Read `DATABASE.md`.
2. Write or refresh the relationship map:
   - FK-backed parent -> child relations
   - child -> parent reverse lookups
   - logical non-FK relations such as shared `car_type` text
3. Compare all live DB tables against current admin routes and views.
4. Record every uncovered table in:
   - `CROSSWALK.md`
   - `STATUS.md`
5. If the website already has real content, prefer website-derived seed/input over generic placeholders.

## Mandatory UI expectations

- FK-backed relations must show readable labels in list/detail views.
- 1:N child tables should be embedded under the parent detail page when useful.
- Logical relations without FKs must still be visible in the UI if they affect operator decisions.
- Route order, parent icons, and menu nesting are part of coverage quality, not polish.

## High-priority relation modules in this ecosystem

- `orders` -> `order_payments`
- `orders` -> `payment_links`
- `orders` -> `driver_assignments`
- `drivers` -> `driver_assignments`
- `services` -> `attractions`
- `vehicles` <-> `pricing_rules` <-> `orders` via `car_type`

## Exit rule

Do not treat the admin as "scaffold complete" if the schema contains live tables that still have no admin route/module representation.
