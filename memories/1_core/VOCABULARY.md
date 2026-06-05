# Claude-Gemini Linguistic Bridge: User-Authored Vocabulary

## ⚖️ Semantic Matching Rules (Fuzzy Triggering)

> [!TIP]
> **The Substring Rule**: For User Terms longer than 3 words (e.g., *"Dropdown modules relation tables"*), any unique substring of **3+ consecutive words** (e.g., *"Dropdown modules relation"*) is considered an authoritative trigger for the same protocol.

| User Term (The Trigger) | System Equivalent (The Protocol) | Referral Step | What am I really referring to? |
|---|---|---|---|
| **"Dropdown modules relation tables"** | Top-Placement Relationship Tray | `[FE:Step 11]` | Sliding drawers from the top containing tabbed relationship tables (Reviews/Leads). |
| **"Layericon dropdown modules"** | Tabbed Relationship Drawer | `[FE:Step 11]` | The "All" view triggered by the layers icon in a grid. |
| **"Layericon"** | `lucide:layers` action icon | `[FE:Step 11]` | The gateway for Navigation DOWN towards children entities. |
| **"Blue link value only"** | CellFkLink / Count Trigger | `[FE:Step 09]` | Clickable numeric values (e.g. 5/0) that reveal specific relationships. |
| **"Profile-Only mode"** | Isolated Entity Detail | `[FE:Step 09]` | Agent detail view with relationship tables HIDDEN (`hideTables: true`). |
| **"Original color border"** | VXE-Table Default Styling | `[FE:Step 09]` | Standard system-native grid lines. User dislikes light/custom gray borders. |
| **"Edit modules empty input"** | useEditDrawer `getDetailApi` bug | `[FE:Step 06]` | Failures in data binding when the wrong API or ID key is used in the drawer. |
| **"Tables detail"** | Ant Design `Descriptions` | `[FE:Step 10]` | The informational layout in the Detail Drawer. |
| **"Malaysian data"** | Sovereign Seed Standard | `[FE:Step 02]` | High-fidelity mock data: Sdn Bhd, +60 phone, Malaysian addresses. |
| **"clean module"** | Standardized Module Logic | `[FE:Step 01/09]` | Standardized table names, VXE formatting, and RAW density rules. |
| **"plan for me"** | AI Planning Mandate | `[APEX:Tier 1]` | Direct request for a formal Implementation Plan artifact. |
| **"follow my step"** | Industrial Sequencing | `[FE:Step 01-14]` | Adhere strictly to the 14-step industrial flow without skipping. |
| **"master data"** | Parent / Config Registry | `[FE:Step 01]` | Reference entities that act as parents in 1:N relations. |
| **"has relation"** | Automated Relation Sync | `[FE:Step 11]` | **Trigger**: Proactively inject LayerIcon (Parent) and CellFkLink (Child). |
| **"create tables + error"** | Create Drawer Audit | `[FE:Step 08]` | Check "left-side" popup for submission/integration bugs. |
| **"edit tables + error"** | Edit Drawer Audit | `[FE:Step 08]` | Check "right-side" popup for empty input/binding bugs. |
| **"CRUD"** | Lifecycle Integrity | `[FE:Step 01-14]` | Validate Create, Read, Update, Delete for 100% functionality. |
| **"vibe coding"** | High-Velocity Prototyping | `[S3:DNA]` | Rapid iteration focused on "Raising the floor" for features. |
| **"agentic engineering"** | Quality-Locked Implementation | `[S3:DNA]` | Professional execution that preserves the "Quality Bar". |
| **"software 3.0"** | Context-Driven Programming | `[S3:DNA]` | Shift from explicit code to prompt-leveraged context. |
| **"jagged intelligence"**| Awareness of Logic Gaps | `[S3:DNA]` | Recognizing model blind spots in common-sense tasks. |
| **"spurious code"** | LLM-Native Liquidated Logic | `[S3:DNA]` | Code that shouldn't exist because the LLM can do it raw. |


## ⚖️ Logical Mapping & Casing Rules (The Bridge)

To prevent "Undefined" crashes and binding failures, I must strictly follow these casing transformations:

| Domain | Mapping | Example | Logic Requirement |
| :--- | :--- | :--- | :--- |
| **Database** | `snake_case` | `agent_id`, `created_at` | Supabase / SQL Primary Schema. |
| **Frontend Store** | `camelCase` | `agentId`, `createdAt` | Pinia Bakery stores & props. |
| **Vben Form** | `camelCase` | `reviewerName` | Form schemas and Drawer data. |

### 🛠️ The Global ID Mapping Registry
| Concept | Database ID Key | Frontend State Key |
| :--- | :--- | :--- |
| **Agent Profile** | `agent_profile_id` | `agentProfileId` |
| **Agent User** | `user_id` | `userId` |
| **Lead / Inquiry** | `lead_id` | `leadId` |
| **Attachment** | `attachment_id` | `id` |

## 🛠️ Interaction Logic Referrals

- **"Industrialize this"**: Use raw tables, remove Card padding, use cinematic gradients for headers, and ensure 100% data density.
- **"Fix my comment"**: Analyze the prompt for missing patterns (like Layericon) and auto-implement according to the 14-step industrial plan.

---
**Status**: Authoritative (User-Driven) | **Last Update**: 2026-04-21 
