# Skills

A curated collection of AI agent skills that extend agent capabilities for code quality, content creation, knowledge exploration, and daily productivity. Each skill is a self-contained module with standardized metadata and instructions, ready to be invoked via the `skill` tool.

## Available Skills

### 🛠️ 技术类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 🔍 [my-code-review](./my-code-review/SKILL.md) | 通用代码审查，覆盖质量、安全、性能、测试全维度 | 7步结构化审查、SOLID原则、反模式识别、安全审计 | 通用 |
| 🔍 [go-code-review](./go-code-review/SKILL.md) | Go 代码深度审查，聚焦性能、安全、并发、可读性 | 智能范围检测、性能审查、并发安全、安全扫描 | Go |
| 🔧 [code-refactor](./code-refactor/SKILL.md) | 代码重构专家，遵循 SOLID 原则和企业设计模式 | 行为等价、可维护性、可扩展性、可测试性 | Go |
| 🧹 [code-simplifier](./code-simplifier/SKILL.md) | 代码简化优化，遵循 YAGNI/KISS/DRY 原则 | 复杂度控制、早返回、冗余消除、多语言支持 | 通用 |
| 🎯 [confidence-check](./confidence-check/SKILL.md) | 实施前置信度检查，避免无效编码 | 重复检测、架构合规、文档验证、根因分析 | 通用 |
| 🏛️ [architecture-designer](./architecture-designer/SKILL.md) | 架构设计专家，用于系统设计和架构决策 | 架构模式推荐、ADR文档、系统设计、数据库选型 | 通用 |
| ❓ [asking-clarifying-questions](./asking-clarifying-questions/SKILL.md) | 需求澄清，消除矛盾、歧义和假设 | 矛盾解决、术语消歧、边界澄清、假设验证 | 通用 |
| 👑 [strategic-product-advisor](./strategic-product-advisor/SKILL.md) | 顶级战略产品师，深度战略审视与商业化路径 | 五维战略诊断、商业化路线图、PMF评估、竞品分析 | 通用 |
| 🎨 [ui-ux-auditor](./ui-ux-auditor/SKILL.md) | 顶级 UI/UX 设计审计师，系统性设计审查与体验重构 | 六维设计诊断、视觉层次、留白与呼吸感、一致性审查 | 通用 |

### ✨ 创作类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| ✍️ [technical-content-optimizer](./technical-content-optimizer/SKILL.md) | 技术博客润色，去除 AI 味，提升专业性 | 逻辑审查、语调转换、结构重组、去 AI 化 | 中文 |
| ✨ [humanizer-zh](./humanizer-zh/SKILL.md) | 去除 AI 写作痕迹，让文字更自然 | 24 种模式检测、质量评分、人性化改写 | 中文 |
| 📊 [mermaid-generator](./mermaid-generator/SKILL.md) | 智能图表生成，自动选择最佳类型 | 智能类型选择、语法安全、鲜艳配色、15+ 图表类型 | 通用 |
| ⚖️ [value-judge](./value-judge/SKILL.md) | 多维度价值评估，对书籍/项目/文章打分 | 类型识别、维度评分、结构化报告、推荐指数 | 通用 |

### 📚 信息类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 📰 [news-tracker](./news-tracker/SKILL.md) | 新闻追踪与智能问答，获取最新动态 | 主题识别、时间智能、来源权威、中文输出 | 通用 |
| 🔥 [hackernews](./hackernews/SKILL.md) | Hacker News API，获取热门新闻/评论/用户 | 免 API Key、热门/最新/Ask HN、用户资料 | 通用 |
| 📡 [daily-tech-digest](./daily-tech-digest/SKILL.md) | 每日技术热帖聚合，6 大社区一网打尽 | V2EX/linux.do/Nodeseek/Reddit/GitHub/ProductHunt | 通用 |
| 📖 [daily-knowledge](./daily-knowledge/SKILL.md) | 每日知识官，轻松好读的跨领域知识分享 | L2-L3语气、查重机制、领域轮换、金句密度 | 通用 |
| 🧘 [wisdom-decoder](./wisdom-decoder/SKILL.md) | 智慧解码器，佛学/哲学/心理学深度解读 | 核心解码、顶尖路线图、禁忌洞察、陌生视角 | 通用 |
| 💡 [insight-miner](./insight-miner/SKILL.md) | 每日洞见挖掘，跨学科思维模型生成 | 知识奇点、底层模型、行动原则、历史统计 | 通用 |
| 📚 [book-recommender](./book-recommender/SKILL.md) | 每日书籍推荐，非虚构类优先 | 豆瓣高分、金句摘录、阅读建议、防重复 | 通用 |
| 🏛️ [history-autopsy](./history-autopsy/SKILL.md) | 历史大事件框架速览，形成认知框架 | 热点优先、框架概览、金句速记、查重机制 | 通用 |
| 🌍 [geo-explorer](./geo-explorer/SKILL.md) | 地缘认知探索器，5分钟读懂一个地方的"地缘人设" | 热点优先、ASCII关系图、地图搜索、查重机制 | 通用 |
| 📖 [learn-tech](./learn-tech/SKILL.md) | 技术知识学习助手，费曼技巧深度讲解 | MECE架构图、5W2H分析、避坑指南、微型实践 | 通用 |
| 🚀 [project-hunter](./project-hunter/SKILL.md) | AI 时代项目机会发现器，挖掘高潜力赚钱方向 | 多角度搜索、趋势洞察、四维评估、独立开发路线 | 通用 |

### 🔧 工具类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 🛠️ [skill-creator](./skill-creator/SKILL.md) | Skill 创建指南，扩展 AI 能力 | 渐进披露、资源打包、模板生成、验证打包 | 通用 |
| 🔍 [find-skills](./find-skills/SKILL.md) | 发现并安装开源 Agent Skills | CLI 搜索、智能推荐、一键安装 | 通用 |
| 📹 [yt-dlp-downloader](./yt-dlp-downloader/SKILL.md) | 多平台视频下载，支持 YouTube/B站/抖音等 | 音频提取、字幕下载、画质选择、千站支持 | 通用 |

---

## Sources

部分 Skills 来源于开源社区，感谢原作者的贡献：

| Skill | 来源 |
|-------|------|
| my-code-review | [supercent-io/skills-template](https://github.com/supercent-io/skills-template/tree/main/.agent-skills/code-review) |
| skill-creator | [anthropics/skills](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md) |
| yt-dlp-downloader | [MapleShaw/yt-dlp-downloader-skill](https://github.com/MapleShaw/yt-dlp-downloader-skill/blob/master/SKILL.md) |
| humanizer-zh | [op7418/Humanizer-zh](https://github.com/op7418/Humanizer-zh/blob/main/SKILL.md) |
| find-skills | [vercel-labs/skills](https://github.com/vercel-labs/skills/blob/main/skills/find-skills/SKILL.md) |
| hackernews | [vm0-ai/vm0-skills](https://github.com/vm0-ai/vm0-skills/tree/main/hackernews) |
| architecture-designer | [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills/tree/main/skills/architecture-designer) |
| asking-clarifying-questions | [ed3dai/ed3d-plugins](https://github.com/ed3dai/ed3d-plugins/tree/main/plugins/ed3d-plan-and-execute/skills/asking-clarifying-questions) |

## Skill Structure

```
<skill-name>/
├── SKILL.md          # Skill metadata and instructions
└── [executables]     # Optional scripts, tools, or resources
```

## Contributing

Contributions welcome! Please ensure new skills follow these guidelines:

- **Single Purpose** — each skill should do one thing well
- **Standardized Format** — include `SKILL.md` with proper YAML frontmatter
- **No Secrets** — do not include API keys or credentials

## License

MIT License
