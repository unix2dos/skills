# Skills Repository

A collection of reusable AI agent skills designed to extend and enhance agent capabilities. Each skill is a self-contained module that provides specific functionality through standardized interfaces.

## Overview

This repository contains modular skills that can be invoked by AI agents (compatible with OpenCode/OhMyOpenCode). Skills are packaged with clear descriptions, instructions, and optional executable scripts to perform specialized tasks.

```bash
rm -rf ~/.config/opencode/skill ; ln -s ~/workspace/skills/ ~/.config/opencode/skill
rm -rf ~/.claude/skills ; ln -s ~/workspace/skills/ ~/.claude/skills
rm -rf ~/.config/alma/skills ; ln -s ~/workspace/skills/ ~/.config/alma/skills
rm -rf ~/.gemini/antigravity/skills ; ln -s ~/workspace/skills/ ~/.gemini/antigravity/skills
```

## Available Skills

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

### 🔍 code-review

**Description**: Deep code review skill for Go code focusing on performance, security, concurrency safety, and readability.

**Usage**: Default reviews local uncommitted code; automatically reviews the most recent commit if working directory is clean. Supports reviewing specified commits, branches, or tags. Offers concise and detailed output modes.

**Features**:
- **Smart Scope Detection**: Automatically detects uncommitted changes or recent commits
- **Performance Review**: Memory allocation, slice/map pre-allocation, sync.Pool usage
- **Concurrency Safety**: Mutex pairing, channel blocking, goroutine lifecycle
- **Security Review**: SQL injection, command injection, path traversal, sensitive data
- **Readability Review**: Naming conventions, cyclomatic complexity, early returns
- **Domain-Specific**: Web API (Gin/Echo), microservices, database (GORM), message queues

**Review Standards**:
- Effective Go
- Uber Go Style Guide
- Go Code Review Comments

**Output Modes**:
- **Concise Mode**: Table format with issues and recommendations
- **Detailed Mode**: Full analysis with risk explanation and refactored code examples

---

### 🔧 code-refactor

**Description**: Golang code refactoring expert focused on large-scale data processing systems. Follows SOLID principles, idiomatic Go, and enterprise design patterns.

**Usage**: Invoke when users need to refactor code, optimize functions, improve code quality, reduce complexity, or enhance maintainability, extensibility, and testability.

**Refactoring Priorities**:
| Priority | Focus | Description |
|----------|-------|-------------|
| P0 | Behavioral Equivalence | Preserve API contracts, boundary conditions, concurrency safety |
| P1 | Maintainability | Single responsibility, self-documenting names, nesting ≤ 3, cyclomatic complexity ≤ 10 |
| P2 | Extensibility | Interface segregation, dependency injection, functional options |
| P3 | Testability | Interface-based DI, avoid package-level variables, prefer pure functions |

**Output Format**:
1. **Refactoring Strategy**: Core changes, design patterns used, trade-offs
2. **Risk Assessment**: Breaking changes, performance impact, dependency changes

---

### 🧹 code-simplifier

**Description**: 代码简化与优化专家。专注减少代码复杂度、提升可读性，遵循 YAGNI、KISS 和 DRY 原则。

**Usage**: 当代码过于复杂、需要重构、消除冗余或优化性能建议时调用。支持分析模式（提供建议）和执行模式（直接修改）。

**Features**:
- **Complexity Control**: Keep cyclomatic complexity low (≤ 10 recommended)
- **Early Returns**: Flatten nested logic with guard clauses
- **YAGNI/KISS/DRY**: Systematic removal of over-engineering and redundancy
- **Preserves Functionality**: Ensures core behavior remains unchanged while simplifying
- **Multi-language Support**: Idiomatic patterns for Go and other major languages

**Operating Modes**:
1. **Analysis Mode**: Identify issues, estimate LOC reduction, prioritize changes
2. **Execution Mode**: Direct application of simplifications and refactoring

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
