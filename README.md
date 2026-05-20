# Skills

A curated collection of AI agent skills that extend agent capabilities for code quality, content creation, knowledge exploration, and daily productivity. Each skill is a self-contained module with standardized metadata and instructions, ready to be invoked via the `skill` tool.

## Available Skills

### 🛠️ 技术类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 🔍 [go-code-review](./go-code-review/SKILL.md) | Go 代码深度审查，聚焦性能、安全、并发、可读性 | 智能范围检测、性能审查、并发安全、安全扫描 | Go |
| 🔧 [code-refactor](./code-refactor/SKILL.md) | 代码重构专家，遵循 SOLID 原则和企业设计模式 | 行为等价、可维护性、可扩展性、可测试性 | Go |
| 🧹 [code-simplifier](./code-simplifier/SKILL.md) | 代码简化优化，遵循 YAGNI/KISS/DRY 原则 | 复杂度控制、早返回、冗余消除、多语言支持 | 通用 |
| 🎯 [confidence-check](./confidence-check/SKILL.md) | 实施前置信度检查，避免无效编码 | 重复检测、架构合规、文档验证、根因分析 | 通用 |
| 🔭 [ask-first](./ask-first/SKILL.md) | 意图对焦器，从模糊输入中挤出显式意图 | 三方向发散、自适应追问、意图回放、参考锚定 | 通用 |
| 👑 [strategic-product-advisor](./strategic-product-advisor/SKILL.md) | 顶级战略产品师，深度战略审视与商业化路径 | 五维战略诊断、商业化路线图、PMF评估、竞品分析 | 通用 |
| 🎨 [ui-ux-auditor](./ui-ux-auditor/SKILL.md) | 顶级 UI/UX 设计审计师，系统性设计审查与体验重构 | 六维设计诊断、视觉层次、留白与呼吸感、一致性审查 | 通用 |
| 🔬 [autoresearch](./autoresearch/SKILL.md) | 自动化 Skill 优化，基于 Karpathy autoresearch 方法论 | 二元评估、自主实验循环、变异保留/丢弃、实时仪表盘 | 通用 |

### ✨ 创作类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| ✍️ [technical-content-optimizer](./technical-content-optimizer/SKILL.md) | 技术博客润色，去除 AI 味，提升专业性 | 逻辑审查、语调转换、结构重组、去 AI 化 | 中文 |
| 🧠 [blog-knowledge-extraction](./blog-knowledge-extraction/SKILL.md) | 从笔记、排障记录、设计总结中提取中文技术博客选题 | 上位知识簇、两阶段写作、autoresearch 验证 | 中文 |
| 📊 [mermaid-generator](./mermaid-generator/SKILL.md) | 智能图表生成，自动选择最佳类型 | 智能类型选择、语法安全、鲜艳配色、15+ 图表类型 | 通用 |
| ⚖️ [value-judge](./value-judge/SKILL.md) | 多维度价值评估，对书籍/项目/文章打分 | 类型识别、维度评分、结构化报告、推荐指数 | 通用 |

### 📚 信息类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 📰 [news-tracker](./news-tracker/SKILL.md) | 新闻追踪与智能问答，获取最新动态 | 主题识别、时间智能、来源权威、中文输出 | 通用 |
| 📡 [daily-tech-digest](./daily-tech-digest/SKILL.md) | 每日技术热帖聚合，6 大社区一网打尽 | V2EX/linux.do/Nodeseek/Reddit/GitHub/ProductHunt | 通用 |
| 📖 [daily-knowledge](./daily-knowledge/SKILL.md) | 每日知识官，轻松好读的跨领域知识分享 | L2-L3语气、查重机制、领域轮换、金句密度 | 通用 |
| 🧘 [wisdom-decoder](./wisdom-decoder/SKILL.md) | 智慧解码器，佛学/哲学/心理学深度解读 | 核心解码、顶尖路线图、禁忌洞察、陌生视角 | 通用 |
| 💡 [insight-miner](./insight-miner/SKILL.md) | 每日洞见挖掘，跨学科思维模型生成 | 知识奇点、底层模型、行动原则、历史统计 | 通用 |
| 📚 [book-recommender](./book-recommender/SKILL.md) | 每日书籍推荐，非虚构类优先 | 豆瓣高分、金句摘录、阅读建议、防重复 | 通用 |
| 🏛️ [history-autopsy](./history-autopsy/SKILL.md) | 历史大事件框架速览，形成认知框架 | 热点优先、框架概览、金句速记、查重机制 | 通用 |
| 🌍 [geo-explorer](./geo-explorer/SKILL.md) | 地缘认知探索器，5分钟读懂一个地方的"地缘人设" | 热点优先、ASCII关系图、地图搜索、查重机制 | 通用 |
| 📖 [learn-map](./learn-map/SKILL.md) | 系统化学习任何主题，费曼技巧深度讲解 | MECE架构图、5W2H分析、避坑指南、微型实践 | 通用 |
| 🚀 [project-hunter](./project-hunter/SKILL.md) | AI 时代项目机会发现器，挖掘高潜力赚钱方向 | 多角度搜索、趋势洞察、四维评估、独立开发路线 | 通用 |

---

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
