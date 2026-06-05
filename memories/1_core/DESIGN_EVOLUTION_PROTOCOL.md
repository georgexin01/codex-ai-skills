# 🧠 Design Evolution Protocol (V1.0)

> This protocol dictates how the AI analyzes user feedback to evolve its "Design Senses" (The Antigravity Design DNA).

## 1. The "Why" Deduction Framework
When a user requests a design change, the AI must categorize the intent using the following 5 dimensions:

| Dimension | Question to Ask Self | Signal in Feedback |
|---|---|---|
| **Weight** | Is the current text competing with the layout? | "Too bold", "Reduce weight", "Use 700" |
| **Materiality** | Is the interface feeling "flat" or "cheap"? | "Add gradient", "Purple theme", "Glassmorphism" |
| **Ergonomics** | Is the interaction area too small for high-speed ops? | "Make card clickable", "No need to click text" |
| **Precision** | Is the component look "toy-like" vs "industrial"? | "Make bar thinner", "6px height", "Sleek" |
| **Hierarchy** | Is the user overwhelmed by information? | "Show 1 only", "View more link", "Hide organisation" |

## 2. Evolving Design Senses (Learnings from wRider Session)

### 2.1 The "Trusta Industrial" Sweet Spot
- **Typography**: Abandon 900-weight for headers. **700 (Bold)** is the authoritative weight for card titles and subheadings. It provides emphasis without "shouting" in a dense layout.
- **Progress Linearity**: Progress bars MUST be **6px**. This height signifies "Industrial Precision". Thicker bars (10px+) look like consumer-grade progress bars and are rejected.
- **Material Map**: 
    - **Tier 1 (Base)**: `var(--color-paper)` (Solid #fbfbfb).
    - **Tier 2 (Content)**: `WRCard` with shadow.
    - **Tier 3 (Overlay/Action)**: `.glass` (White/85% + Blur 12px + Border 1px white/40%). Used for Login cards, Toasts, and Modals.
- **Interaction DNA**: Never force a user to click a small text button if a parent container exists. **Everything is a card, and the card is the button.**

## 3. Auto-Update Rules for the AI
1. **Chat Scanning**: After every 3 successful design implementations, scan the chat for repeated user keywords (e.g., "700", "center", "icon").
2. **Knowledge Injection**: Update `design-intelligence.md` immediately if a new "Sense" is confirmed.
3. **Proactive Application**: If a user asks for a new page, automatically apply the **Tier 3 Glass** for inputs and **Tier 2 Cards** for data, using **700 weight** for titles without being asked.

---
*Created by Design Intelligence V2.0 — Auto-Evolving Knowledge*
