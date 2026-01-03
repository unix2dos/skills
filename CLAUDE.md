# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a collection of modular AI agent skills for OpenCode/OhMyOpenCode. Each skill is a self-contained module that can be invoked by AI agents through the `skill` tool.

## Skill Architecture

Each skill follows a standardized structure:

```
<skill-name>/
├── SKILL.md          # Skill metadata and execution instructions
└── [executables]    # Optional: scripts, tools, or resources (e.g., weather.sh)
```

### SKILL.md Format

Every skill must have a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: skill-name                    # Lowercase, hyphenated skill identifier
description: Brief, searchable description of what the skill does
compatibility: opencode             # Target platform (always "opencode")
---

# Skill Title

Instructions for the AI agent on how to invoke and use this skill.
```

### Execution Model

Skills are invoked through the `skill` tool by AI agents. Two types of skills exist:

1. **Script-based skills** (e.g., `query-weather`):
   - Include executable scripts (bash, python, etc.)
   - Scripts are invoked via bash with arguments extracted from user input
   - Scripts should use absolute paths or be installed to `~/.claude/skills/<skill-name>/`

2. **Prompt-based skills** (e.g., `blog-polisher`):
   - Pure documentation with instructions for the AI
   - Agent reads the instructions and performs the task using its own capabilities

## Working with Skills

### Viewing Skills

Skills are located in individual directories under the repository root. To understand a skill:
- Read its `SKILL.md` for the YAML frontmatter and instructions
- Check for executable scripts in the skill directory

### Testing Skills

Script-based skills can be tested directly:
```bash
./query-weather/weather.sh "London"
```

For prompt-based skills, verify the instructions are clear and actionable.

### Installing Skills

Skills are typically installed to `~/.claude/skills/<skill-name>/` for use by Claude Code agents.

## Skill Best Practices

- **Single Purpose**: Each skill should do one thing well
- **No Secrets**: Never include API keys or credentials in skills
- **Explicit Instructions**: Agents must know exactly how to invoke the skill
- **Error Handling**: Scripts should handle edge cases gracefully (e.g., default values for missing arguments)
- **Clear Description**: Frontmatter description must be concise and searchable

## No Build System

This repository has no build pipeline, package.json, or test suite. Skills are:
- Written in markdown (SKILL.md)
- Optionally include bash/other executable scripts
- Validated by manual testing and code review

## Current Skills

- **query-weather**: Fetches weather data from wttr.in API using a bash script
- **blog-polisher**: Pure prompt-based skill for polishing technical blog posts
