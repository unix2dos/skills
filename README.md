# Skills Repository

A collection of reusable AI agent skills designed to extend and enhance agent capabilities. Each skill is a self-contained module that provides specific functionality through standardized interfaces.

## Overview

This repository contains modular skills that can be invoked by AI agents (compatible with OpenCode/OhMyOpenCode). Skills are packaged with clear descriptions, instructions, and optional executable scripts to perform specialized tasks.

```bash
rm -rf ~/.claude/skills ; ln -s ~/workspace/skills/ ~/.claude/skills
rm -rf ~/.codex/skills ; ln -s ~/workspace/skills/ ~/.codex/skills
rm -rf ~/.config/opencode/skill ; ln -s ~/workspace/skills/ ~/.config/opencode/skill
rm -rf ~/.gemini/antigravity/skills ; ln -s ~/workspace/skills/ ~/.gemini/antigravity/skills
rm -rf ~/.config/alma/skills ; ln -s ~/workspace/skills/ ~/.config/alma/skills
```

## Available Skills

### 🛠️ 技术类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 🔍 code-review | Go 代码深度审查，聚焦性能、安全、并发、可读性 | 智能范围检测、性能审查、并发安全、安全扫描 | Go |
| 🔧 code-refactor | 代码重构专家，遵循 SOLID 原则和企业设计模式 | 行为等价、可维护性、可扩展性、可测试性 | Go |
| 🧹 code-simplifier | 代码简化优化，遵循 YAGNI/KISS/DRY 原则 | 复杂度控制、早返回、冗余消除、多语言支持 | 通用 |
| 🎯 confidence-check | 实施前置信度检查，避免无效编码 | 重复检测、架构合规、文档验证、根因分析 | 通用 |

### ✨ 创作类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| ✍️ technical-content-optimizer | 技术博客润色，去除 AI 味，提升专业性 | 逻辑审查、语调转换、结构重组、去 AI 化 | 中文 |
| 📊 mermaid-generator | 智能图表生成，自动选择最佳类型 | 智能类型选择、语法安全、鲜艳配色、15+ 图表类型 | 通用 |

### 🔧 工具类

| 名称 | 描述 | 主要特性 | 适用范围 |
|------|------|----------|----------|
| 📰 news-tracker | 新闻追踪与智能问答，获取最新动态 | 主题识别、时间智能、来源权威、中文输出 | 通用 |
| ⚖️ value-judge | 多维度价值评估，对书籍/项目/文章打分 | 类型识别、维度评分、结构化报告、推荐指数 | 通用 |
| 🛠️ skill-creator | Skill 创建指南，扩展 AI 能力 | 渐进披露、资源打包、模板生成、验证打包 | 通用 |

---

## Skill Details

### 🔍 code-review

**Usage**: 默认审查本地未提交代码；工作目录干净时自动审查最近提交。支持指定 commit/branch/tag，提供简洁和详细两种输出模式。

**Review Standards**: Effective Go、Uber Go Style Guide、Go Code Review Comments

**Output Modes**:
- **简洁模式**: 表格形式列出问题和建议
- **详细模式**: 完整分析，含风险说明和重构代码示例

---

### 🔧 code-refactor

**Usage**: 需要重构代码、优化函数、提升代码质量、降低复杂度、增强可维护性/可扩展性/可测试性时调用。

**Refactoring Priorities**:

| 优先级 | 聚焦 | 描述 |
|--------|------|------|
| P0 | 行为等价 | 保持 API 契约、边界条件、并发安全 |
| P1 | 可维护性 | 单一职责、自说明命名、嵌套 ≤ 3、圈复杂度 ≤ 10 |
| P2 | 可扩展性 | 接口隔离、依赖注入、函数选项模式 |
| P3 | 可测试性 | 基于接口的 DI、避免包级变量、偏向纯函数 |

**Output Format**: 重构策略 + 风险评估

---

### 🧹 code-simplifier

**Usage**: 代码过于复杂、需要重构、消除冗余或优化性能建议时调用。支持分析模式和执行模式。

**Operating Modes**:
1. **分析模式**: 识别问题、估算 LOC 减少、优先级排序
2. **执行模式**: 直接应用简化和重构

---

### 🎯 confidence-check

**Usage**: 每次实施前主动使用——开始功能开发、修复、重构或架构决策时。

**Checks & Weights**:

| 检查项 | 权重 |
|--------|------|
| 无重复实现 | 25% |
| 架构合规 | 25% |
| 官方文档验证 | 20% |
| 有效 OSS 参考 | 15% |
| 根因已识别 | 15% |

**Decision Thresholds**:
- **≥80%**: ✅ 继续实施
- **70-79%**: ⚠️ 提出替代方案，询问澄清问题
- **<70%**: ❌ 停止 - 向用户请求更多上下文

---

### ✍️ technical-content-optimizer

**Usage**: 用户提供需要编辑改进的博客草稿时调用。

**Output Format**:
1. 编辑摘要（逻辑问题 + 结构变更）
2. 完整润色后的博客草稿

---

### 📊 mermaid-generator

**Usage**: 需要可视化流程、关系、时序、架构等信息时调用。

**Supported Chart Types**:

| 类型 | 语法 | 适用场景 |
|-----|------|---------|
| 流程图 | `flowchart` | 步骤、决策、分支 |
| 时序图 | `sequenceDiagram` | API调用、消息交互 |
| 类图 | `classDiagram` | OOP、继承关系 |
| ER图 | `erDiagram` | 数据库设计 |
| 甘特图 | `gantt` | 项目进度 |
| 状态图 | `stateDiagram-v2` | 生命周期 |
| 饼图 | `pie` | 占比分布 |
| 思维导图 | `mindmap` | 知识结构 |
| Git图 | `gitGraph` | 版本控制 |
| 时间线 | `timeline` | 里程碑 |

---

### 📰 news-tracker

**Usage**: 查询某领域最新新闻、了解公司动态、追踪人物近况、获取地区新闻、了解产品情况、追踪事件进展，或询问需要最新信息才能回答的问题时调用。

**Output Format**:
- **新闻列表**: 标题、摘要、来源、时间、相关性星级、链接
- **智能问答**: 直接回答 + 信息来源

---

### ⚖️ value-judge

**Usage**: 评估某内容是否值得投入时间、对已阅读内容打分总结、比较多个资源价值、询问"值不值得看/学"时调用。

**Supported Types**: 📚 书籍、📝 文章、🐙 GitHub项目、🎬 视频/课程、🔧 工具/产品、📄 论文

**Output Format**: 总分(1-100) + 快速结论 + 维度评分 + 详细评价（优点/不足/建议）

---

### 🛠️ skill-creator

**Usage**: 需要创建新 Skill 或更新现有 Skill 时调用。

**Creation Process**:
1. 通过具体示例理解 Skill
2. 规划可复用内容（scripts/references/assets）
3. 初始化 Skill（运行 init_skill.py）
4. 编辑 Skill（实现资源并编写 SKILL.md）
5. 打包 Skill（运行 package_skill.py）
6. 基于实际使用迭代

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
