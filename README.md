# Skills Repository

A collection of reusable AI agent skills designed to extend and enhance agent capabilities. Each skill is a self-contained module that provides specific functionality through standardized interfaces.

## Overview

This repository contains modular skills that can be invoked by AI agents (compatible with OpenCode/OhMyOpenCode). Skills are packaged with clear descriptions, instructions, and optional executable scripts to perform specialized tasks.

## Available Skills

### 🌤️ query-weather

**Description**: Retrieve current weather and forecast for a specific location.

**Usage**: Invoke when users request weather information for any city or location.

**Implementation**:
- Fetches real-time weather data from [wttr.in](https://wttr.in/)
- Returns formatted current weather and forecast
- Default location: Beijing (can be overridden)

**Example**:
```bash
~/.claude/skills/query-weather/weather.sh "London"
```

---

### ✍️ technical-content-optimizer

**Description**: 技术博客内容优化专家，润色技术文章使其更专业、逻辑清晰、结构规范，去除「AI味」。

**Usage**: Invoke when users provide blog post drafts that need editorial improvement.

**Features**:
- **Logical Audit**: Identifies logical fallacies, circular reasoning, and technical inaccuracies
- **Tone Shift**: Transforms robotic AI writing into professional senior engineer voice
- **Structural Reorganization**: Ensures proper hierarchy and narrative flow
- **De-AI**: Removes robotic transitions, overly enthusiastic language, and redundant summaries

**Output Format**:
1. Editor's Summary (logical issues + structural changes)
2. Full polished blog post draft

---

### 🔍 codereview

**Description**: Deep code review skill for Go code focusing on performance, security, and readability.

**Usage**: Default reviews local uncommitted code; automatically reviews the most recent commit if there are no uncommitted changes. Can also review specified commits, branches, or tags.

**Features**:
- **Smart Scope Detection**: Automatically detects uncommitted changes or recent commits
- **Performance Review**: Memory allocation, concurrency control, hot path optimization
- **Security Review**: Input validation, sensitive data, access control
- **Readability Review**: Naming conventions, code structure, error handling

**Review Standards**:
- Effective Go
- Uber Go Style Guide
- Go Code Review Comments

**Output Format**:
```
Potential Risks → Analysis → Refactored Code
```

---

### 🎯 confidence-check

**Description**: Pre-implementation gate that validates readiness before coding. Spend 100-200 tokens here to save 5,000-50,000 tokens on wrong-direction work.

**Usage**: Use proactively before EVERY implementation - starting features, fixes, refactors, or making architecture decisions.

**Features**:
- **Weighted Scoring**: 5 checks with configurable weights (requires ≥80% to proceed)
- **Duplicate Detection**: Prevents reinventing existing implementations
- **Architecture Compliance**: Ensures use of existing tech stack and patterns
- **Official Docs Verification**: Validates against authoritative sources
- **OSS Reference**: Finds proven implementations for guidance
- **Root Cause Analysis**: Identifies underlying issues before fixing symptoms

**Checks & Weights**:
| Check | Weight |
|-------|--------|
| No Duplicates | 25% |
| Architecture Compliant | 25% |
| Official Docs Verified | 20% |
| Working OSS Reference | 15% |
| Root Cause Identified | 15% |

**Decision Thresholds**:
- **≥80%**: ✅ Proceed to implementation
- **70-79%**: ⚠️ Present alternatives, ask clarifying questions
- **<70%**: ❌ STOP - Request more context from user

---

### 📊 mermaid-generator

**Description**: 根据用户描述智能选择最合适的图表类型并生成语法正确、配色鲜艳的 Mermaid 代码。

**Usage**: 当用户需要可视化流程、关系、时序、架构等信息时调用。

**Features**:
- **智能类型选择**: 根据场景关键词自动推荐最适合的图表类型
- **语法安全**: 所有文本标签用双引号包裹，避免特殊符号导致解析错误
- **鲜艳配色**: 使用现代化配色方案，视觉效果出众
- **全格式支持**: 流程图、时序图、类图、ER图、甘特图、状态图等 15+ 种类型

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
User: "What's the weather in Tokyo?"
Agent: [Invokes query-weather skill]

User: "Review my blog post"
Agent: [Invokes blog-polisher skill with the draft]
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
