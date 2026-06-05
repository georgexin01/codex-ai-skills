# Free Visual Asset Sourcing Workflow

Use this workflow when a website/app needs strong visuals but the current agent has no working paid image-generation tool, no API billing, or the user asks for free image generation.

## Decision Order

1. First check project-owned assets: `images/`, `uploads/`, `public/`, `assets/`, Figma exports, client folders, and existing brand media.
2. If the user asked for "AI generated images" but no working image API exists, explain the limit briefly, then use free visual sourcing as the fallback instead of leaving placeholders.
3. Use free stock photography for realistic scenes, and use icon fonts/SVG/CSS art for UI visuals, empty states, category cards, avatars, blobs, diagrams, and app chrome.
4. Prefer downloading reusable images into the project (`uploads/generated/`, `images/`, `public/images/`) when the site must work offline or on production hosting. Hotlink only for quick prototypes.
5. Keep a source registry file such as `uploads/generated/IMAGE_SOURCES.md` or `src/assets/IMAGE_SOURCES.md` with source URL, license URL, search query, and date.

## Recommended Free Sources

- Unsplash: free commercial/non-commercial use, no permission required, attribution appreciated. Avoid images with visible brands, logos, recognizable people, or protected artwork unless appropriate permissions are clear.
- Pexels: free commercial use, attribution not required, editing allowed. Avoid implying endorsement by people or brands in the image.
- Pixabay: free use and modification under its Content License, attribution not required. Avoid standalone resale, recognizable trademarks/brands, misleading use, and sensitive use of identifiable people.
- Google Fonts / Material Symbols: open-source fonts; Material Symbols are Apache 2.0. Good for UI icons, app navigation, property amenities, transport, maps, commerce, actions, and empty states.
- CSS/SVG generated visuals: use for abstract brand backgrounds, category silhouettes, map-like cards, floorplan placeholders, gradient ribbons, status badges, skeletons, and no-image fallbacks.

## Practical Implementation Pattern

For a property/website catalog:

1. Define visual slots in data first:
   - `hero`
   - `masonry`
   - `gallery`
   - `blueprint`
   - `icons`
2. Build 8-20 reusable visuals, then cycle them across many records instead of fetching hundreds of images.
3. For each image object, store:
   - `src`
   - `alt`
   - `source`
   - `license`
   - `prompt_or_query`
4. Use `<img loading="lazy" decoding="async" style/object-fit: cover>` or the project image component.
5. Keep a CSS/SVG fallback so broken URLs never collapse cards.
6. Use `object-fit: cover`, stable `aspect-ratio`, and explicit dimensions so layouts do not shift.
7. For production, replace prototype stock photos with client-approved, owned, licensed, or generated assets.

## Search Query Recipes

Property website:
- `modern malaysia townhouse garden`
- `luxury residential community park`
- `shop office retail street`
- `apartment entrance green wall`
- `township aerial masterplan`
- `modern home interior garden`

App UI:
- `delivery rider portrait`
- `restaurant food flatlay`
- `car interior detail`
- `office dashboard workspace`
- `mobile banking lifestyle`

## Compliance Guardrails

- Do not claim the stock photo depicts the real client project unless the client supplied/approved it.
- Do not bake client logos into stock images. Use an HTML/CSS watermark overlay if a removable prototype mark is needed.
- Avoid visible third-party logos, vehicle plates, faces, sensitive contexts, and branded storefronts for commercial prototypes.
- Always record source/license metadata before handoff.
- If using remote CDN URLs, document that production should download/cache or replace them.

## Agent Behavior

When a user says "generate images" in design/website or design/app work:

1. Try the available native image-generation tool only if it can save files into the project and billing/access works.
2. If unavailable or blocked, automatically switch to this free visual asset workflow.
3. Use real free visual sources or CSS/SVG/icon systems to make the design look complete.
4. Tell the user clearly whether assets are generated, stock-sourced, CSS/SVG-created, or placeholders.
