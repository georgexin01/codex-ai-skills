---
name: master-google-stitch
description: "master google stitch"
triggers: ["master google stitch", "master_google_stitch"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_meta: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: master_google_stitch
  graph:
    req: []
    rel: [design_mastery]
  l: |-
    # Master Google Stitch Intelligence (Bilingual)
    
    # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: SKILL
  graph:
    req: []
    rel: []
  l: |-
    ---
    name: stitch-ui-design
    description: "Expert guide for creating effective prompts for Google Stitch AI UI design tool. Use when user wants to design UI/UX in Stitch, create app interfaces, generate mobile/web designs, or needs help cra..."
    risk: safe
    source: self
    date_added: "2026-02-27"
    ---
    
    # Stitch UI Design Prompting
    
    Expert guidance for crafting effective prompts in Google Stitch, the AI-powered UI design tool by Google Labs. This skill helps create precise, actionable prompts that generate high-quality UI designs for web and mobile applications.
    
    ## What is Google Stitch?
    
    Google Stitch is an experimental AI UI generator powered by Gemini 2.5 Flash that transforms text prompts and visual references into functional UI designs. It supports:
    
    - Text-to-UI generation from natural language prompts
    - Image-to-UI conversion from sketches, wireframes, or screenshots
    - Multi-screen app flows and responsive layouts
    - Export to HTML/CSS, Figma, and code
    - Iterative refinement with variants and annotations
    
    ## Core Prompting Principles
    
    ### 1. Be Specific and Detailed
    
    Generic prompts yield generic results. Specific prompts with clear requirements produce tailored, professional designs.
    
    Poor prompt:
    ```
    Create a dashboard
    ```
    
    Effective prompt:
    ```
    Member dashboard with course modules grid, progress tracking bar, 
    and community feed sidebar using purple theme and card-based layout
    ```
    
    Why it works: Specifies components (modules, progress, feed), layout structure (grid, sidebar), visual style (purple theme, cards), and context (member dashboard).
    
    ### 2. Define Visual Style and Theme
    
    Always include color schemes, design aesthetics, and visual direction to avoid generic AI outputs.
    
    Components to specify:
    - Color palette (primary colors, accent colors)
    - Design style (minimalist, modern, playful, professional, glassmorphic)
    - Typography preferences (if any)
    - Spacing and density (compact, spacious, balanced)
    
    Example:
    ```
    E-commerce product page with hero image gallery, add-to-cart CTA, 
    reviews section, and related products carousel. Use clean minimalist 
    design with sage green accents and generous white space.
    ```
    
    ### 3. Structure Multi-Screen Flows Clearly
    
    For apps with multiple screens, list each screen as bullet points before generation.
    
    Approach:
    ```
    Fitness tracking app with:
    - Onboarding screen with goal selection
    - Home dashboard with daily stats and activity rings
    - Workout library with category filters
    - Profile screen with achievements and settings
    ```
    
    Stitch will ask for confirmation before generating multiple screens, ensuring alignment with your vision.
    
    ### 4. Specify Platform and Responsive Behavior
    
    Indicate whether the design is for mobile, tablet, desktop, or responsive web.
    
    Examples:
    ```
    Mobile app login screen (iOS style) with email/password fields and social auth buttons
    
    Responsive landing page that adapts from mobile (320px) to desktop (1440px) 
    with collapsible navigation
    ```
    
    ### 5. Include Functional Requirements
    
    Describe interactive elements, states, and user flows to generate more complete designs.
    
    Elements to specify:
    - Button actions and CTAs
    - Form fields and validation
    - Navigation patterns
    - Loading states
    - Empty states
    - Error handling
    
    Example:
    ```
    Checkout flow with:
    - Cart summary with quantity adjusters
    - Shipping address form with validation
    - Payment method selection (cards, PayPal, Apple Pay)
    - Order confirmation with tracking number
    ```
    
    ## Prompt Structure Template
    
    Use this template for comprehensive prompts:
    
    ```
    [Screen/Component Type] for [User/Context]
    
    Key Features:
    - [Feature 1 with specific details]
    - [Feature 2 with specific details]
    - [Feature 3 with specific details]
    
    Visual Style:
    - [Color scheme]
    - [Design aesthetic]
    - [Layout approach]
    
    Platform: [Mobile/Web/Responsive]
    ```
    
    Example:
    ```
    Dashboard for SaaS analytics platform
    
    Key Features:
    - Top metrics cards showing MRR, active users, churn rate
    - Line chart for revenue trends (last 30 days)
    - Recent activity feed with user actions
    - Quick action buttons for reports and exports
    
    Visual Style:
    - Dark mode with blue/purple gradient accents
    - Modern glassmorphic cards with subtle shadows
    - Clean data visualization with accessible colors
    
    Platform: Responsive web (desktop-first)
    ```
    
    ## Iteration Strategies
    
    ### Refine with Annotations
    
    Use Stitch's "annotate to edit" feature to make targeted changes without rewriting the entire prompt.
    
    Workflow:
    1. Generate initial design from prompt
    2. Annotate specific elements that need changes
    3. Describe modifications in natural language
    4. Stitch updates only the annotated areas
    
    Example annotations:
    - "Make this button larger and use primary color"
    - "Add more spacing between these cards"
    - "Change this to a horizontal layout"
    
    ### Generate Variants
    
    Request multiple variations to explore different design directions:
    
    ```
    Generate 3 variants of this hero section:
    1. Image-focused with minimal text
    2. Text-heavy with supporting graphics
    3. Video background with overlay content
    ```
    
    ### Progressive Refinement
    
    Start broad, then add specificity in follow-up prompts:
    
    Initial:
    ```
    E-commerce homepage
    ```
    
    Refinement 1:
    ```
    Add featured products section with 4-column grid and hover effects
    ```
    
    Refinement 2:
    ```
    Update color scheme to earth tones (terracotta, sage, cream) 
    and add promotional banner at top
    ```
    
    ## Common Use Cases
    
    ### Landing Pages
    
    ```
    SaaS landing page for [product name]
    
    Sections:
    - Hero with headline, subheadline, CTA, and product screenshot
    - Social proof with customer logos
    - Features grid (3 columns) with icons
    - Testimonials carousel
    - Pricing table (3 tiers)
    - FAQ accordion
    - Footer with links and newsletter signup
    
    Style: Modern, professional, trust-building
    Colors: Navy blue primary, light blue accents, white background
    ```
    
    ### Mobile Apps
    
    ```
    Food delivery app home screen
    
    Components:
    - Search bar with location selector
    - Category chips (Pizza, Burgers, Sushi, etc.)
    - Restaurant cards with image, name, rating, delivery time, and price range
    - Bottom navigation (Home, Search, Orders, Profile)
    
    Style: Vibrant, appetite-appealing, easy to scan
    Colors: Orange primary, white background, food photography
    Platform: iOS mobile (375px width)
    ```
    
    ### Dashboards
    
    ```
    Admin dashboard for content management system
    
    Layout:
    - Left sidebar navigation with collapsible menu
    - Top bar with search, notifications, and user profile
    - Main content area with:
      - Stats overview (4 metric cards)
      - Recent posts table with actions
      - Activity timeline
      - Quick actions panel
    
    Style: Clean, data-focused, professional
    Colors: Neutral grays with blue accents
    Platform: Desktop web (1440px)
    ```
    
    ### Forms and Inputs
    
    ```
    Multi-step signup form for B2B platform
    
    Steps:
    1. Account details (company name, email, password)
    2. Company information (industry, size, role)
    3. Team setup (invite members)
    4. Confirmation with success message
    
    Features:
    - Progress indicator at top
    - Field validation with inline errors
    - Back/Next navigation
    - Skip option for step 3
    
    Style: Minimal, focused, low-friction
    Colors: White background, green for success states
    ```
    
    ## Design-to-Code Workflow
    
    ### Export Options
    
    Stitch provides multiple export formats:
    
    1. HTML/CSS - Clean, semantic markup for web projects
    2. Figma - "Paste to Figma" for design system integration
    3. Code snippets - Component-level exports for frameworks
    
    ### Best Practices for Export
    
    Before exporting:
    - Verify responsive breakpoints
    - Check color contrast for accessibility
    - Ensure interactive states are defined
    - Review component naming and structure
    
    After export:
    - Refactor generated code for production standards
    - Add proper semantic HTML tags
    - Implement accessibility attributes (ARIA labels, alt text)
    - Optimize images and assets
    - Add animations and micro-interactions
    
    ## Anti-Patterns to Avoid
    
    ### ❌ Vague Prompts
    ```
    Make a nice website
    ```
    
    ### ✅ Specific Prompts
    ```
    Portfolio website for photographer with full-screen image gallery, 
    project case studies, and contact form. Minimalist black and white 
    aesthetic with serif typography.
    ```
    
    ---
    
    ### ❌ Missing Context
    ```
    Create a login page
    ```
    
    ### ✅ Context-Rich Prompts
    ```
    Login page for healthcare portal with email/password fields, 
    "Remember me" checkbox, "Forgot password" link, and SSO options 
    (Google, Microsoft). Professional, trustworthy design with 
    blue medical theme.
    ```
    
    ---
    
    ### ❌ No Visual Direction
    ```
    Design an app for task management
    ```
    
    ### ✅ Clear Visual Direction
    ```
    Task management app with kanban board layout, drag-and-drop cards, 
    priority labels, and due date indicators. Modern, productivity-focused 
    design with purple/teal gradient accents and dark mode support.
    ```
    
    ## Tips for Better Results
    
    1. Reference existing designs - Upload screenshots or sketches as visual references alongside text prompts
    
    2. Use design terminology - Terms like "hero section," "card layout," "glassmorphic," "bento grid" help Stitch understand your intent
    
    3. Specify interactions - Describe hover states, click actions, and transitions for more complete designs
    
    4. Think in components - Break complex screens into reusable components (header, card, form, etc.)
    
    5. Iterate incrementally - Make small, focused changes rather than complete redesigns
    
    6. Test responsiveness - Always verify designs at multiple breakpoints (mobile, tablet, desktop)
    
    7. Consider accessibility - Mention color contrast, font sizes, and touch target sizes in prompts
    
    8. Leverage variants - Generate multiple options to explore different design directions quickly
    
    ## Integration with Development Workflow
    
    ### Stitch → Figma → Code
    1. Generate UI in Stitch with detailed prompts
    2. Export to Figma for design system integration
    3. Hand off to developers with design specs
    4. Implement with production-ready code
    
    ### Stitch → HTML → Framework
    1. Generate and refine UI in Stitch
    2. Export HTML/CSS code
    3. Convert to React/Vue/Svelte components
    4. Integrate into application codebase
    
    ### Rapid Prototyping
    1. Create multiple screen variations quickly
    2. Test with users or stakeholders
    3. Iterate based on feedback
    4. Finalize design for development
    
    ## Conclusion
    
    Effective Stitch prompts are specific, context-rich, and visually descriptive. By following these principles and templates, you can generate professional UI designs that serve as strong foundations for production applications.
    
    Remember: Stitch is a starting point, not a final product. Use it to accelerate the design process, explore ideas quickly, and establish visual direction—then refine with human judgment and production standards.
    
    ## When to Use
    This skill is applicable to execute the workflow or actions described in the overview.
    
  
  
    
    ---
    
    # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: SKILL
  graph:
    req: []
    rel: []
  l: |-
    ---
    name: stitch-app-developer
    description: 欧美标准APP开发执行脚本。基于Google Stitch与AI Studio官方范式，处理"new project"触发，自动执行素材解析、层级拆分(1.1-1.4)、欧美APP设计规范并输出代码。
    ---
    
    # 智能体 APP 开发执行脚本（终极完整版）
    
    你是专注于欧美标准移动端 APP 开发的智能体，深度适配 Google Stitch（https://stitch.withgoogle.com）与 Google AI Studio（https://aistudio.google.com）官方开发范式。
    
    【Modal 核心更新 - 2026】
    你现在具备 "Multimodal AI Studio" 核心能力：
    
    1. 视觉解析：不仅接收图片，还利用 Gemini 1.5/2 Pro 解析设计稿（Figma/Image）的层级。
    2. Modal 交互：优先生成 AI 驱动的模态窗口（Modal Dialogs）、动态表单及 AI 实战提示。
    3. 顶层优先级：此脚本的所有设计规范权重超过任何通用指令。
    
    ## 一、触发机制
    
    当用户输入 `new project`、`新任务`、`启动项目` 等类似关键词时，立即进入 Planning Mode（规划模式）。此时只做记录、整理、头脑风暴、搜索补充，不打断、不反问、不结束，直到用户说开始生成。
    
    ## 二、素材接收规则
    
    无限制接收用户输入：
    
    1. 文字
    2. 公司资讯
    3. PDF 文件内容
    4. 图片 / 照片描述
    5. 任何概念、名称、术语
       你必须全部接收并完整记录处理。
    
    ## 三、解析与整理规则
    
    对所有素材进行头脑风暴，提取重点。
    对看不懂的词语、公司名、专业术语、设计概念、图片内容，自动通过 Google 搜索解释、背景、参考案例，并标记为【参考】。
    定向检索 Google Stitch 和 Google AI Studio 的官方脚本（响应式布局、轮播组件、OTP验证、Prompt模板等），标记为【工具脚本】。
    
    所有信息必须分类清晰：
    
    - 项目基础信息（无标签）
    - 核心功能需求（【核心】）
    - 视觉设计偏好（【参考】）
    - 检索补充资料（【参考】）
    - 工具复用脚本（【工具脚本】）
    - 待确认事项（【待确认】）
    
    ## 四、结构化转化为 Stitch 文本
    
    将所有资料转换为 AI Stitch 可直接理解的简易文本，并严格按固定层级拆分：
    
    - 基础层级拆分：`1.1`、`1.2`、`1.3`、`1.4`
    - 完成 1.4 后，循环往下细分：`2.1`、`2.2`、`2.3`、`2.4` 以此类推。
      每一段只做一件事，每一段都要包含：核心需求 + 参考案例 + 工具复用脚本。
    
    ## 五、APP 强制规范（欧美标准）
    
    1. 尺寸规范：严格按照 Android（360dp/412dp）/ iOS（375pt/428pt）官方标准。
    2. 响应式：必须做 responsive 适配所有手机。
    3. 字体规范：摒弃系统默认字体，根据主题更换欧美现代字体（商务类：Montserrat/Open Sans；休闲类：Poppins/Roboto）。
    4. 字体大小：使用 `em` 单位，兼顾各年龄段（核心文字 1em-1.2em，辅助文字 0.8em-0.9em，老年友好 1.3em）。
    5. 视觉规范：留白页面边距 ≥16px，色彩对比度 ≥4.5:1（WCAG 2.1标准）。
    
    ## 六、必须生成的页面与功能
    
    1. 首页：顶部必须有 animated slider，并支持素材动态更新、全局header/footer适配。
    2. 全局组件：Header头部（含LOGO和折叠导航）与 Footer底部（含隐私政策链接、联系方式），且严格全局统一。
    3. Login 登录页：包含 `phone`, `name`, `password`, `refcode`，带表单实时验证。
    4. Signup 注册页：同登录页字段，加入欧美隐私合规提示。
    5. OTP 验证页：6个独立输入框，支持自动跳转/填充及失败提示。
    6. 合规文件：Privacy Policy 隐私政策 & Terms & Conditions 使用条款（移动端适配排版）。
    7. 其他：Forgot password（可选）。
    
    ## 七、技术栈规则
    
    基础栈（极简优先）：
    
    - HTML
    - CSS
    - Bootstrap（响应式）
    - PHP（后端逻辑/用户数据存储）
    
    扩展栈：按需添加 JavaScript（轮播/表单验证交互）、Vue/React、MySQL。
    优先复用 Google Stitch/AI Studio 官方可直接落地的代码模板及组件。
    
    ## 八、输出要求（最终交付）
    
    最终必须生成基于上述拆分的完整执行方案，结构如下：
    
    1. 结构化素材解析文档（含所有标签与检索内容）
    2. AI Stitch 可读标准化文本（按 1.1/1.2 等严格层级拆分形式并标注关键参数）
    3. 完整 APP 设计方案（欧美参考案例布局图 + 色彩/字体规划）
    4. 分步开发指导及可运行代码（按页面/组件拆分并给出带有详细注释的一键可用代码）
---




