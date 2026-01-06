---
name: confidence-check
description: Pre-implementation gate to validate readiness before coding. Use when starting features, fixes, refactors, or making architecture decisions. Triggers on "before implementing", "verify readiness", "should I proceed", "am I ready".
compatibility: opencode
---

# Confidence Check

Pre-implementation gate. Spend 100-200 tokens here to save 5,000-50,000 tokens on wrong-direction work.

## Instructions

When the user is about to start implementing code, follow these steps:

### Step 1: Determine If Check Is Needed

**USE this skill when:**
- Starting any feature, fix, or refactor
- About to write production code
- Making architecture/stack decisions
- Integrating with unfamiliar code
- User seems confident (overconfidence = highest risk)

**SKIP this skill when:**
- Pure research/exploration tasks
- Reading/explaining existing code
- Documentation-only changes

### Step 2: Create Todo List (MANDATORY)

Create 5 todo items (1 per check):
1. Search for duplicate implementations (use Grep/Glob tools)
2. Verify architecture compliance (check CLAUDE.md, existing patterns)
3. Check official documentation (use web search or Context7)
4. Find working OSS reference (search GitHub, Stack Overflow)
5. Identify root cause (for bugs: review errors, logs, traces)

### Step 3: Execute Each Check & Score

| Check | Weight | Pass Criteria |
|-------|--------|---------------|
| **No Duplicates** | 25% | No similar implementation exists in codebase |
| **Architecture Compliant** | 25% | Uses existing tech stack and patterns |
| **Official Docs Verified** | 20% | Official docs reviewed and understood |
| **Working OSS Reference** | 15% | Proven implementation found for reference |
| **Root Cause Identified** | 15% | Root cause is clear (for bug fixes) |

**Task-specific weight adjustments:**
- **Bug Fix:** Root cause (40%) + Docs (30%) + OSS (30%)
- **New Feature:** Duplicates (40%) + Architecture (30%) + Docs (30%)
- **Refactor:** Architecture (50%) + Duplicates (30%) + OSS (20%)

### Step 4: Make Decision Based on Score

| Score | Action |
|-------|--------|
| ≥80% | ✅ **Proceed** to implementation |
| 70-79% | ⚠️ **Pause** - Present alternatives, ask clarifying questions |
| <70% | ❌ **STOP** - Request more context from user |

### Step 5: Output Results

Present findings in this format:

```
Confidence Checks:
   [✅/❌] No duplicate implementations found
   [✅/❌] Uses existing tech stack
   [✅/❌] Official documentation verified
   [✅/❌] Working OSS implementation found
   [✅/❌] Root cause identified

Confidence: X.XX (XX%)
Decision: [Proceed/Ask Questions/Stop]
```

---

## Response Templates

**If user says "Skip the check, this is straightforward":**
> Straightforward tasks fail 40% of the time from duplicate implementations or architecture mismatches. Confidence check takes 2 minutes. Which checks did you already complete?

---

## Red Flags to Watch

| Thought | Reality |
|---------|---------|
| "This is too simple to check" | 40% of "simple" tasks duplicate existing code |
| "I already know the architecture" | Assumptions cause 30% of rework |
| "Official docs take too long" | 5 min reading saves 3 hours debugging |
