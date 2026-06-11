# EcoWorld App Design/App Improvements (2026-05-13)

## Contact Form
- Use a themed two-card layout: intro card + form card.
- Consent checkbox must align with the first text baseline and keep fixed 16px checkbox size.
- Prefer rounded 14-16px cards with soft gradient and subtle shadow in eco theme.

## Auth Pages (Login / Signup / OTP)
- Apply hero intro block with badge, title, and helper text before form.
- Use grouped phone row (`+60` fixed cell + input field).
- OTP should use 6 separate one-character boxes with numeric input mode.

## Filter Modal
- Keep modal max width mobile-first inside app frame: around 360-380px.
- Use one-line price range display only (`white-space: nowrap`).
- Arrange short controls in 2-column grid (Category/Type, Region/Status, Bedrooms).
- Keep action row fixed two buttons: Reset and Apply.

## Search & Listing UX
- Search should target listing title first for user expectation.
- Category chips must support horizontal drag/scroll on touch.

## Tailwind Usage Rule
- Preferred: Tailwind utility classes for input/select/range style.
- If Tailwind package install is blocked by environment/network, fallback to temporary utility-like classes and migrate to true Tailwind once installation succeeds.
