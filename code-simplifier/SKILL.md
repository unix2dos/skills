---
name: code-simplifier
description: Use when code has excessive complexity, deep nesting, unused abstractions, or violates YAGNI/KISS/DRY principles and needs simplification or cleanup
---

# Code Simplifier

简化和优化代码，在保持功能不变的前提下降低复杂度、提升可维护性。适用于任何编程语言。

## When to Use
- 代码嵌套过深、圈复杂度过高
- 存在明显的 YAGNI 违规（为"可能"的需求写的代码）
- 重复代码、冗余检查、未使用的抽象
- 需要"减法"：删代码、砍抽象、inline 只用一次的函数

## When NOT to Use
- 需要改接口签名、拆模块、引入设计模式 → 用 **code-refactor**
- 需要审查安全/并发问题 → 用 **go-code-review**
- 代码结构没问题，只是需要扩展新功能 → 直接写代码

## Core Principles

### YAGNI (You Aren't Gonna Need It)
- Remove features not explicitly required now
- Eliminate extensibility points without clear use cases
- Question generic solutions for specific problems
- Remove "just in case" code

### KISS (Keep It Simple, Stupid)
- Prefer simple solutions over clever ones
- Replace complex logic with straightforward implementations
- Make the common case obvious
- Avoid premature optimization

### DRY (Don't Repeat Yourself)
- Identify and consolidate duplicate code patterns
- Extract common logic into reusable functions
- Eliminate redundant error checks and validations

### Cyclomatic Complexity Control
- Keep function cyclomatic complexity ≤ 10
- Break down complex functions into smaller, focused units
- Use early returns to reduce nesting depth
- Simplify conditional logic wherever possible

## Operating Modes

### Analysis Mode (分析模式)
When asked to review or analyze code, provide a structured assessment:
- Identify the core purpose of the code
- List complexity issues and potential simplifications
- Highlight YAGNI violations
- Estimate potential lines of code reduction
- Prioritize recommendations by impact

### Execution Mode (执行模式)
When asked to simplify or refactor code, directly make changes:
- Preserve all original functionality
- Apply simplifications based on analysis
- Ensure code remains readable and maintainable
- Document only significant changes

## Simplification Strategies

1. **Reduce Nesting**
   - Use early returns/guard clauses
   - Flatten deeply nested conditionals
   - Extract complex conditions into named functions

2. **Simplify Logic**
   - Replace nested ternaries with switch/if-else
   - Break down complex conditionals
   - Use table-driven logic when appropriate

3. **Remove Redundancy**
   - Eliminate duplicate error checks
   - Consolidate repeated patterns
   - Remove commented-out code
   - Delete unused imports/variables

4. **Challenge Abstractions**
   - Question every interface and abstraction layer
   - Inline code that's only used once
   - Remove over-engineered solutions
   - Suggest removing premature generalizations

5. **Optimize for Readability**
   - Use descriptive names over comments
   - Prefer explicit code over clever shortcuts
   - Simplify data structures to match actual usage
   - Make intent clear through naming

## Language-Specific Guidance

When working with **Go**:
- Follow Effective Go principles
- Adhere to Uber Go Style Guide recommendations
- Use idiomatic Go patterns (error handling, interfaces, etc.)
- Prefer simplicity and explicit code

For other languages:
- Adapt to the language's established idioms
- Follow community-accepted style guides
- Respect project-specific conventions when present

## 工作流程

1. **理解**：识别代码的实际职责
2. **分析**：找出复杂度、冗余和 YAGNI 违规
3. **排优先级**：按影响大小排序简化机会
4. **执行**：分析模式给建议，执行模式直接改
5. **验证**：确保功能不变、代码更简单

输出使用中文。
