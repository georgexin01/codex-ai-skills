---
name: mobile-food-dashboard-dark
description: "MOBILE APP: Food Delivery Dashboard (Dark Mode)"
triggers: ["mobile food dashboard dark", "mobile-food-dashboard-dark", "mobile food delivery"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: mobile-food-dashboard-dark
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# MOBILE APP: Food Delivery Dashboard (Dark Mode)

Extraction Date: 2026-04-07
Color Theme: Absolute Dark (`--bg-900`) with Vivid Orange (`--primary-500`) accents.
Architecture: High-density horizontal SCROLL loops.

## The Extracted VSS 4.0 Layout

### 1. Navigation Header (Sticky)
`{ Cg [pad:3 flex:row justify:between align:center] { CSearch [bg:dark round:pill flex:row] Iisearch & Tm<Search Dish...> } + Bp<FilterMenu> [round:circle bg:orange w:48px h:48px] }`

### 2. Exclusive Offers (Carousel)
`( { Cg [pad:3] { ThExclusive & BSeeAll [col:orange] } } )`
`+`
`{ = CPromoCard [bg:orange round:xl pos:relative depth:3 h:200px overflow:hidden] { TpWeekend + ThSpecial { T30 + Tmpercent } + !BpGetNow [bg:black round:lg] } + Ib_<GrayBox:PizzaHero> [pos:absolute top:0 right:0 w:50%] }`
`+`
`{ Cf [flex:row justify:center mt:3 gap:2] { Dot_Active [bg:orange] + Dot * 3 [bg:dark] } }`

### 3. Explore Categories (Pill Scroll)
`( { Cg [pad:3] { ThExplore & BSeeAll [col:dark] } } )`
`+`
`{ Cf [flex:row gap:2 overflow:x-scroll padx:3] { !BpBurger [round:pill bg:orange] IiBurger & TpBurger } + { BgPizza [round:pill bg:dark] IiPizza & TpPizza } + { BgNoodles [round:pill bg:dark] IiNdl & TpNdl } }`

### 4. Popular Dishes (Product Grid Scroll)
`( { Cg [pad:3] { ThPopular & BSeeAll [col:dark] } } )`
`+`
`{ Cf [flex:row gap:3 overflow:x-scroll padx:3] { cProduct [round:lg bg:dark pos:relative depth:3 w:220px] { TmBadge [pos:absolute top:2 left:2 bg:green fs:xs round:pill] + BFavorite [pos:absolute top:2 right:2 bg:black round:circle] } + Ib<GrayBox:PizzaImage> [w:100 h:120px roundt:lg] + { pad:3 { ThTitle + { IiStar[col:orange] & Tp4.9 } + TmDeliveryTime } } } * 4 }`

### 5. Bottom Universal Nav (Fixed)
`( { CBottomNav [pos:fixed bottom:0 w:100 bg:black flex:row justify:between pad:4 border:top] { Cg [flex:col align:center] IiHomeActive & TmHome [col:orange] } + { Cg [flex:col align:center] IiExplore & TmExplore } * 4 } )`

