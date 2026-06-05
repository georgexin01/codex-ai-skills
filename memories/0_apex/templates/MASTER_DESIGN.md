---
# 🎨 MASTER DESIGN SYSTEM (V1.0)
# This file follows the Google DESIGN.md specification for AI Agents.

design_tokens:
  theme: "Cyber Luxury / Deep Onyx"
  colors:
    primary: "#0A0A0B"        # Deep Space Onyx
    secondary: "#1A1A1C"      # Obsidian Layer
    accent: "#6366F1"         # Electric Indigo
    background: "#050506"     # Void Black
    surface: "rgba(255, 255, 255, 0.03)" # Glass Surface
    text:
      primary: "#F8FAFC"
      secondary: "#94A3B8"
  typography:
    font_family: "Inter, system-ui, sans-serif"
    scale: "Major Second"
  spacing:
    unit: "4px"
    container_padding: "24px"
  border_radius:
    standard: "12px"
    component: "8px"
  effects:
    glassmorphism:
      blur: "12px"
      border: "1px solid rgba(255, 255, 255, 0.08)"

principles:
  visual_identity: |
    The Antigravity aesthetic is rooted in 'Cyber Luxury'. It prioritizes deep, dark 
    surfaces with subtle depth created through glassmorphism and thin, high-contrast 
    borders. It avoids 'AI Slop' by using custom HSL colors rather than browser defaults.
  
  anti_slop_standards:
    - No generic blue/white combinations.
    - No standard border-radii (use curated tokens).
    - Always use subtle micro-animations for interactions.
    - Shadows must be ultra-soft and deep (#000000 40% blur).

component_logic:
  buttons: "Ghost borders with solid accent hover states."
  cards: "Glass surface with 1px border and soft shadow."
  navigation: "Floating blur-heavy bars with minimal icons."

---

# 🚀 PROJECT DESIGN DNA

## 1. VISION
[Describe the specific visual vision for this project]

## 2. KEY ASSETS
- **Logo**: [Path to logo]
- **Icons**: [Icon library choice]

## 3. CHANGE LOG
### YYYY-MM-DD · [AI] · Genesis
- Created DESIGN.md from Master Template.
- Initialized Cyber Luxury tokens.

## 4. LEARNED PATTERNS (DYNAMIC EXPANSION)
# This section grows as the AI learns your preferences during implementation.
# [Pattern Name] · [Date] · [Rationale]
