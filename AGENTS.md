# AGENTS.md

Guide for AI agents working in this repository.

## Build & Test Commands

**No build system**: Skills are markdown files with optional bash scripts. No package.json, test framework, or build pipeline.

**Testing skills**:
```bash
# Script-based skill (e.g., query-weather)
./query-weather/weather.sh "London"

# Prompt-based skills (e.g., technical-content-optimizer)
# Verify instructions are clear and actionable by reading SKILL.md
```

**Validation**: Manual testing and code review. Test locally before committing.

---

## Skill Structure

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
description: What this skill does   # concise, searchable, start with verb
compatibility: opencode             # always "opencode"
---

# Skill Title

Instructions for the AI agent.

## Instructions

Step-by-step guidance.
```

**Rules**:
- Frontmatter at very top
- H1 `#` for skill title (not in frontmatter)
- Use `## Instructions` for step-by-step section

---

## Code Style Guidelines

### Bash Scripts

```bash
#!/bin/bash

# Comments explain complex logic
LOCATION="${1:-Beijing}"  # Default value for missing args

# Silent mode for clean API output
curl -s "https://api.example.com"
```

**Bash best practices**:
- Always include `#!/bin/bash` shebang
- Use `${VAR:-default}` for optional arguments
- `curl -s` (silent) for API calls
- Handle edge cases gracefully
- Make executable: `chmod +x script.sh`

### Markdown Instructions

- Direct and imperative: "Run this command", not "You should run"
- Numbered lists for sequential steps
- Code blocks for examples
- Specify expected input/output formats
- Include "Output Format" section when applicable

### Naming Conventions

- **Skill directories**: `lowercase-hyphenated`
- **Bash scripts**: `lowercase-hyphenated.sh`
- **Bash variables**: `UPPER_SNAKE_CASE`
- **Section headers**: H1 for skill title, H2/H3 for sections
- **File paths in text**: Backticks: `SKILL.md`, `weather.sh`

---

## Documentation Style

### SKILL.md Content Structure

1. Brief description (what the skill does)
2. Instructions section (`## Instructions`)
3. Step-by-step guidance (numbered lists)
4. Code examples (when applicable)
5. Output format (when applicable)

### Tone and Clarity

- Imperative verbs: "Run", "Invoke", "Check" - not passive voice
- Exhaustive instructions: don't assume agents infer behavior
- Code blocks for multi-line examples

---

## Error Handling

**Script-based skills**:
- Provide sensible defaults for missing arguments: `${VAR:-default}`
- Validate inputs when possible
- Don't crash silently

**Prompt-based skills**:
- Specify fallback behavior for invalid input
- Include error handling in instructions

---

## Skill Best Practices

1. **Single Purpose**: Each skill does one thing well
2. **No Secrets**: Never include API keys or credentials
3. **Explicit Instructions**: Agents know exactly how to invoke
4. **Clear Description**: Frontmatter must be searchable
5. **Test Locally**: Verify scripts work before committing

---

## Skill Types

### Script-Based Skills
- Include executable scripts (bash, python, etc.)
- Scripts invoked via bash with arguments
- Use absolute paths: `~/.claude/skills/<skill-name>/script.sh`

### Prompt-Based Skills
- Pure documentation with instructions
- Agent reads and performs task using its capabilities
- Example: `technical-content-optimizer`, `confidence-check`, `code-review`, `code-refactor`

---

## Integration with OpenCode

Skills are invoked via the `skill` tool. Frontmatter fields are used by the system:

- `name`: skill identifier for invocation
- `description`: searchable skill catalog
- `compatibility`: platform filter (always "opencode")

---

## Adding New Skills

1. Create directory: `mkdir new-skill`
2. Create SKILL.md with proper frontmatter
3. Add scripts if needed: `chmod +x script.sh`
4. Test manually
5. Verify invocation from `~/.claude/skills/`
