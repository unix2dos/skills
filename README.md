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

### ✍️ blog-polisher

**Description**: Polish technical blog posts to be more professional, logical, and well-structured, removing "AI flavor".

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

**Description**: 深度 Code Review 技能，以资深 Go 架构师视角审查代码，聚焦性能、安全性及可读性。

**Usage**: 默认 review 本地未提交的代码，如果没有未提交代码则自动 review 最近一次 commit。也可指定 commit、分支或 tag。

**Features**:
- **智能范围检测**: 自动识别未提交变更或最近 commit
- **性能审查**: 内存分配、并发控制、热路径优化
- **安全性审查**: 输入验证、敏感数据、权限控制
- **可读性审查**: 命名规范、代码结构、错误处理

**审查规范**:
- Effective Go
- Uber Go Style Guide
- Go Code Review Comments

**Output Format**:
```
潜在风险 → 原理分析 → 重构代码
```

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
