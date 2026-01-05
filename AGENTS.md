# AGENTS.md

This guide is for AI agents working in this repository.

## Build & Test Commands

**No build system**: This repository uses no package.json, test framework, or build pipeline. Skills are simple markdown files with optional bash scripts.

**Testing skills manually**:
```bash
# Script-based skill (e.g., query-weather)
./query-weather/weather.sh "London"

# Prompt-based skills (e.g., blog-polisher)
# Test by reading SKILL.md and following instructions with sample input
```

**No automated testing**: Skills are validated by manual testing and code review. When adding skills, test them locally before committing.

**Installation test**: After creating a skill, verify it can be invoked from ~/.claude/skills/

---

## Skill Structure

Every skill must follow this exact structure:

```
<skill-name>/
├── SKILL.md          # Required: metadata + instructions
└── [executables]    # Optional: bash scripts, tools
```

### SKILL.md Format (MANDATORY)

YAML frontmatter followed by markdown:

```yaml
---
name: skill-name                    # lowercase, hyphenated
description: What this skill does   # concise, searchable
compatibility: opencode             # always "opencode"
---

# Skill Title

Instructions for the AI agent.
```

**Rules**:
- `name`: lowercase, hyphenated, no spaces
- `description`: 1-2 sentences, start with verb (e.g., "Retrieve weather data")
- Frontmatter must be at the very top
- Use H1 `#` for skill title (not in frontmatter)

---

## Code Style Guidelines

### Bash Scripts

When including bash scripts:

```bash
#!/bin/bash

# Comments explain complex logic
# Use ${VAR:-default} for defaults
LOCATION="${1:-Beijing}"

# curl: silent mode for clean output
curl -s "https://api.example.com"
```

**Bash best practices**:
- Always include `#!/bin/bash` shebang
- Use `${VAR:-default}` for optional arguments
- `curl -s` (silent) for API calls to avoid noise
- Handle edge cases gracefully (default values, error handling)
- Scripts should be executable: `chmod +x script.sh`

### Markdown Instructions

For prompt-based skills:

- Write clear, actionable instructions
- Use numbered lists for sequential steps
- Use code blocks for examples
- Be specific about expected input/output formats
- Include "Output Format" section if applicable

### Naming Conventions

- **Skill directories**: `lowercase-hyphenated`
- **Bash scripts**: `lowercase-hyphenated.sh`
- **Variables**: `UPPER_SNAKE_CASE` in bash
- **Section headers**: H1 for skill title, H2/H3 for sections

---

## Documentation Style

### SKILL.md Content Structure

1. **Brief description** (what the skill does)
2. **Instructions section** (H2: ## Instructions)
3. **Step-by-step guidance** (numbered lists)
4. **Code examples** (when applicable)
5. **Output format** (when applicable)

### Tone and Clarity

- Direct and imperative: "Run this command", not "You should run"
- Use backticks for file paths: `SKILL.md`, `weather.sh`
- Use code blocks for multi-line examples
- Be exhaustive: don't assume agents will infer behavior

---

## Error Handling

**Script-based skills**:
- Provide sensible defaults for missing arguments
- Don't crash silently - validate inputs when possible
- Example: `LOCATION="${1:-Beijing}"` (default if not provided)

**Prompt-based skills**:
- Specify what to do if input is invalid
- Include fallback behavior in instructions

---

## Skill Best Practices

1. **Single Purpose**: Each skill does one thing well
2. **No Secrets**: Never include API keys or credentials
3. **Explicit Instructions**: Agents must know exactly how to invoke
4. **Clear Description**: Frontmatter must be searchable
5. **Test Locally**: Verify scripts work before committing

---

## Adding New Skills

1. Create directory: `mkdir new-skill`
2. Create SKILL.md with proper frontmatter
3. Add scripts if needed (make executable: `chmod +x script.sh`)
4. Test manually
5. Update README.md if adding to documentation

---

## Integration with OpenCode

Skills are invoked via the `skill` tool. The frontmatter fields are used by the system:

- `name`: skill identifier for invocation
- `description`: searchable skill catalog
- `compatibility`: platform filter

Always ensure `compatibility: opencode` is set.
