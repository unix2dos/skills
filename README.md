# Skills Repository

A collection of reusable AI agent skills designed to extend and enhance agent capabilities. Each skill is a self-contained module that provides specific functionality through standardized interfaces.

## Overview

This repository contains modular skills that can be invoked by AI agents (compatible with OpenCode/OhMyOpenCode). Skills are packaged with clear descriptions, instructions, and optional executable scripts to perform specialized tasks.


## Available Skills

### 🛠️ 技术类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 🔍 code-review | Go 代码深度审查，聚焦性能、安全、并发、可读性 | 智能范围检测、性能审查、并发安全、安全扫描 | Go |
| 🔧 code-refactor | 代码重构专家，遵循 SOLID 原则和企业设计模式 | 行为等价、可维护性、可扩展性、可测试性 | Go |
| 🧹 code-simplifier | 代码简化优化，遵循 YAGNI/KISS/DRY 原则 | 复杂度控制、早返回、冗余消除、多语言支持 | 通用 |
| 🎯 confidence-check | 实施前置信度检查，避免无效编码 | 重复检测、架构合规、文档验证、根因分析 | 通用 |
| 📋 planning-with-files | Manus 风格文件规划，复杂任务管理 | 任务分解、进度追踪、会话恢复、错误日志 | 通用 |

### ✨ 创作类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| ✍️ technical-content-optimizer | 技术博客润色，去除 AI 味，提升专业性 | 逻辑审查、语调转换、结构重组、去 AI 化 | 中文 |
| ✨ humanizer-zh | 去除 AI 写作痕迹，让文字更自然 | 24 种模式检测、质量评分、人性化改写 | 中文 |
| 📊 mermaid-generator | 智能图表生成，自动选择最佳类型 | 智能类型选择、语法安全、鲜艳配色、15+ 图表类型 | 通用 |
| ⚖️ value-judge | 多维度价值评估，对书籍/项目/文章打分 | 类型识别、维度评分、结构化报告、推荐指数 | 通用 |

### 📚 信息类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 📰 news-tracker | 新闻追踪与智能问答，获取最新动态 | 主题识别、时间智能、来源权威、中文输出 | 通用 |
| 🔥 hackernews | Hacker News API，获取热门新闻/评论/用户 | 免 API Key、热门/最新/Ask HN、用户资料 | 通用 |
| 📡 news-aggregator-skill | 多源新闻聚合，支持 8 大平台实时抓取 | HN/微博/GitHub/36氪/V2EX/腾讯/华尔街、智能关键词扩展、深度抓取 | 通用 |
| 📖 daily-knowledge | 每日知识官，随机分享跨领域知识 | 查重机制、领域轮换、输出保存、历史记录 | 通用 |
| 💡 insight-miner | 每日洞见挖掘，跨学科思维模型生成 | 知识奇点、底层模型、行动原则、历史统计 | 通用 |
| 🏛️ history-autopsy | 历史解剖学家，深度四维解剖历史事件 | 四维解剖、输出保存、多维透镜、查重机制 | 通用 |
| 🌍 geo-explorer | 地理系统分析师，三透镜解构人地互动 | 多尺度分析、输出保存、概念模型、查重机制 | 通用 |

### 🔧 工具类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 🛠️ skill-creator | Skill 创建指南，扩展 AI 能力 | 渐进披露、资源打包、模板生成、验证打包 | 通用 |
| 🔍 find-skills | 发现并安装开源 Agent Skills | CLI 搜索、智能推荐、一键安装 | 通用 |
| 📹 yt-dlp-downloader | 多平台视频下载，支持 YouTube/B站/抖音等 | 音频提取、字幕下载、画质选择、千站支持 | 通用 |

---

## Sources

部分 Skills 来源于开源社区，感谢原作者的贡献：

| Skill | 来源 |
|-------|------|
| skill-creator | [anthropics/skills](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md) |
| yt-dlp-downloader | [MapleShaw/yt-dlp-downloader-skill](https://github.com/MapleShaw/yt-dlp-downloader-skill/blob/master/SKILL.md) |
| humanizer-zh | [op7418/Humanizer-zh](https://github.com/op7418/Humanizer-zh/blob/main/SKILL.md) |
| find-skills | [vercel-labs/skills](https://github.com/vercel-labs/skills/blob/main/skills/find-skills/SKILL.md) |
| hackernews | [vm0-ai/vm0-skills](https://github.com/vm0-ai/vm0-skills/tree/main/hackernews) |
| planning-with-files | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) |
| news-aggregator-skill | [cclank/news-aggregator-skill](https://github.com/cclank/news-aggregator-skill) |

---

## Skill Structure

Each skill follows this standardized structure:

```
<skill-name>/
├── SKILL.md          # Skill metadata and instructions
└── [executables]    # Optional scripts, tools, or resources
```

### SKILL.md Format

```yaml
---
name: skill-name
description: Brief description of what the skill does
compatibility: opencode  # Target platform
---

# Skill Title

Detailed instructions for the agent on how to use this skill.

## Instructions

Step-by-step guidance for execution.
```

## Integration

Skills are designed to be invoked through the `skill` tool by AI agents:

```
User: "Review my blog post"
Agent: [Invokes technical-content-optimizer skill with the draft]

User: "Generate a diagram for my API flow"
Agent: [Invokes mermaid-generator skill]
```

## Adding New Skills

To add a new skill to this repository:

1. Create a new directory for your skill
2. Create a `SKILL.md` file with proper YAML frontmatter
3. Add any necessary scripts or resources
4. Document usage instructions clearly
5. Set `compatibility: opencode` for OhMyOpenCode integration

### Skill Best Practices

- **Single Purpose**: Each skill should do one thing well
- **Clear Description**: Frontmatter description should be concise and searchable
- **Explicit Instructions**: Agents should know exactly how to invoke the skill
- **Error Handling**: Scripts should handle edge cases gracefully
- **No Secrets**: Skills should not contain API keys or credentials

## Technical Stack

- **Platform**: OhMyOpenCode / OpenCode
- **Format**: YAML frontmatter + Markdown documentation
- **Execution**: Bash scripts, other tools as needed
- **Integration**: Skill invocation system

## License

MIT License

## Contributing

Contributions welcome! Please ensure new skills:
- Follow the existing directory structure
- Include proper YAML frontmatter
- Are tested before submission
- Have clear, actionable instructions

---

**Note**: This is a living repository. Skills are designed to be lightweight, composable, and easily maintainable.
