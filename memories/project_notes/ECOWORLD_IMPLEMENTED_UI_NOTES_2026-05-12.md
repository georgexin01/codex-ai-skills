# EcoWorld Implemented UI Notes (2026-05-12)

## Scope

Captured from the live `ecoworld` PHP prototype after iterative localhost QA.

## Finalized Decisions

1. Shared search/filter system:
   - Homepage and Available Units use the same control design.
   - Desktop alignment: Search + Region + Type in one structured row.
   - Mobile alignment: controls become stacked 100% width rows.
2. Chip system:
   - Horizontal chip scroll remains enabled.
   - Scrollbar UI hidden for cleaner appearance.
   - Active chip style unified to mint (single treatment, no rainbow active states).
3. Header menu:
   - Professional minimal look.
   - Text-only navigation emphasis with color hover; avoid heavy bordered button look.
4. Homepage hero:
   - Video hero was removed.
   - Final hero uses `images/Ebonylane-Hazelton.jpg`.
   - Background supports scroll-based scaling effect.
   - Overlay/shade reduced to avoid washing out content.
5. About page:
   - Removed "Design pillars" section.
   - Removed top hero action buttons (`Open discovery`, `Talk to the team`).
6. Contact page:
   - Removed top hero action buttons (`WhatsApp`, `Call`).
   - Keep the deeper form/info content sections.
7. Blueprint page:
   - Reverted from experimental redesign back to older reference style.
   - Removed bottom "Layout explanation" and "Related" sections.
   - Replaced bottom area with a focused "Powered by EcoWorld" blueprint image + concise description block.
8. Footer:
   - Added small inline contact icons (phone/email/address) in the contact column.

## Implementation Bias for Future Website Skills

- Prefer clean, compact, readable enterprise-property UI.
- Keep CTA density controlled (remove duplicate/early buttons in hero blocks unless explicitly requested).
- Keep visual hierarchy image-first, but with short copy.
- Preserve white + green base and avoid adding unrelated color systems.
