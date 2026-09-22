# Skills

A curated collection of AI agent skills that extend agent capabilities for code quality, content creation, knowledge exploration, and daily productivity. Each skill is a self-contained module with standardized metadata and instructions, ready to be invoked via the `skill` tool.

## 安装

通过 [skills-manager](https://github.com/unix2dos/dotfiles/tree/main/skills-manager) 一键安装到 Claude Code、Codex、Cursor 等 AI 工具。本仓库是其首要 skill 来源。

```bash
git clone https://github.com/unix2dos/dotfiles.git ~/workspace/dotfiles
bash ~/workspace/dotfiles/skills-manager/install.sh
```

配置与详细说明见 [skills-manager README](https://github.com/unix2dos/dotfiles/tree/main/skills-manager)。

## Available Skills

### 🛠️ 技术类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 🎯 [confidence-check](./confidence-check/SKILL.md) | 实施前置信度检查，避免无效编码（手动触发） | 重复检测、架构合规、文档验证、根因分析 | 通用 |
| 🔭 [ask-first](./ask-first/SKILL.md) | 意图对焦器，从模糊输入中挤出显式意图 | 三方向发散、自适应追问、意图回放、参考锚定 | 通用 |

### ✨ 创作类

> 💡 以下 skill 均为**手动触发**，需通过 `@skill名` 或指定关键词显式调用，不会自动触发。

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| ✍️ [blog-refine](./blog-refine/SKILL.md) | 技术博客润色，去除 AI 味，提升专业性 | 逻辑审查、语调转换、结构重组、去 AI 化 | 中文 |
| ✂️ [blog-content-editor](./blog-content-editor/SKILL.md) | 完整博客草稿的受控内容编辑 | 两阶段诊断、确认后增删、保留作者语气 | 中文 |
| 🧠 [notes-to-blog](./notes-to-blog/SKILL.md) | 从笔记、排障记录、设计总结中提取中文技术博客选题 | 上位知识簇、两阶段写作、官方资料核实 | 中文 |
| ⚖️ [value-judge](./value-judge/SKILL.md) | 多维度价值评估，对书籍/项目/文章打分 | 类型识别、维度评分、结构化报告、推荐指数 | 通用 |
| 📖 [feynman-read](./feynman-read/SKILL.md) | 费曼追问消化，逼你用自己的话改写已有文章 | 核心概念识别、小白→面试官追问、自然反思段落、风格保留 | 通用 |
| ✍️ [feynman-write](./feynman-write/SKILL.md) | 费曼写作法，从零学一个主题并写成博客 | AI 研究简报、作者决策大纲、费曼逼问、AI 整合成文 | 中文 |

### 📚 学习类

> 💡 以下 skill 均为**手动触发**，需通过 `@skill名` 或指定关键词显式调用，不会自动触发。

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 📖 [teach-me](./teach-me/SKILL.md) | 系统化讲解一个新主题，写成可应用的教学文 | 5 步认知爬升、worked example、半练/独挑、自检 | 通用 |
| 🎓 [learnlm-inspired-tutor](./learnlm-inspired-tutor/SKILL.md) | 模型无关的 LearnLM 启发式导师，交互式辅导 | 学习地图、学习者主动产出、阶段笔记、迁移实操、资料优先 | 通用 |
| 📖 [book-dissect](./book-dissect/SKILL.md) | 拆书报告，逐段讲透剧情/论点再给价值鉴定 | 80%深度讲解+20%鉴定、叙事/论说双骨架、联网核实、字数下限防简略 | 中文 |

### 🗓️ 低频备用：每日型内容

> 💡 每日一篇的随机内容生成器。能力清楚、可保留，但不是主入口；全部**手动触发**，各自用同目录下的 `*_history.json` 去重。

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 📖 [daily-knowledge](./daily-knowledge/SKILL.md) | 每日知识官，轻松好读的跨领域知识分享 | L2-L3语气、查重机制、领域轮换、金句密度 | 通用 |
| 💡 [insight-miner](./insight-miner/SKILL.md) | 每日洞见挖掘，跨学科思维模型生成 | 知识奇点、底层模型、行动原则、历史统计 | 通用 |
| 🧘 [wisdom-decoder](./wisdom-decoder/SKILL.md) | 智慧解码器，佛学/哲学/心理学深度解读 | 核心解码、顶尖路线图、禁忌洞察、陌生视角 | 通用 |
| 📚 [book-recommender](./book-recommender/SKILL.md) | 每日书籍推荐，非虚构类优先 | 豆瓣高分、金句摘录、阅读建议、防重复 | 通用 |
| 🔭 [hotspot-lens](./hotspot-lens/SKILL.md) | 热点透镜：一条新闻，地理透镜 + 历史透镜合写一篇 | 热点配对、ASCII 关系图、两镜合一推演观察点、金句速记、查重机制 | 通用 |

---

## Skill Structure

```
<skill-name>/
├── SKILL.md          # Skill metadata and instructions
└── [executables]     # Optional scripts, tools, or resources
```

## 触发方式约定

每个 skill 二选一：

- **手动触发**（默认，创作类与信息类全部如此）：frontmatter 设 `disable-model-invocation: true`（Claude Code）和 `triggers: [user]`（Devin），并附 `agents/openai.yaml` 写 `policy.allow_implicit_invocation: false`（Codex）。`description` 写成一句人读的能力描述，不写触发词、不写 "Do NOT auto-trigger"。正文开头必须有标题和一段定位（做什么 / 适用 / 不适用），因为手动触发时模型看不到 description。
- **模型可触发**：只用于模型必须自己判断使用的 skill。目前仓库内没有此类 skill；代码减法约束由 [ponytail](https://github.com/DietrichGebert/ponytail) 插件在各宿主中常驻提供。`description` 是永驻上下文的指针，只写触发分支。

## Contributing

Contributions welcome! Please ensure new skills follow these guidelines:

- **Single Purpose** — each skill should do one thing well
- **Standardized Format** — include `SKILL.md` with proper YAML frontmatter, following the 触发方式约定 above
- **No Secrets** — do not include API keys or credentials

## License

MIT License
