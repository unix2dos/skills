# 我把 19 个 Skill 的 Description 全写错了

给 Claude Code 写了 19 个自定义 Skill，用了几个月，直到按官方规范做了一次全面审计，才发现每一个 Skill 的 description 都踩了同一个坑。

这个坑不是语法错误，不是功能缺陷，而是一个认知陷阱：**我一直在告诉 Claude "我是谁"，而不是"什么时候该找我"。**

## 1. 为什么 Skill 要按需加载

Skills 是上下文工程里一种有效的模式，核心思路是：系统提示只保留索引，完整知识按需加载。

```typescript
const systemPrompt = `
可用 Skills：
- deploy: 部署到生产环境的完整流程
- code-review: 代码审查检查清单
- git-workflow: 分支策略和 PR 规范
`;

async function executeLoadSkill(name: string): Promise<string> {
  return fs.readFile(`./skills/${name}.md`, "utf-8");
}
```

Claude Code 在每次对话启动时，会把所有 Skill 的 name 和 description 注入到系统提示词中。Claude 扫描这份清单，决定当前任务是否需要加载某个 Skill 的完整内容。调用规则也写在系统提示里：每次回复前先扫描 available_skills，有明确匹配时再读取对应 SKILL.md，多个匹配时优先选最具体的那个，没有匹配就不读取。

这意味着 description 是一个**路由判断依据**，不是功能说明书。每个启用的 Skill 描述符都常驻上下文，Skill 一多，长描述的累积 token 成本很可观：

```typescript
# 低效（约 45 tokens）
description: |
  This skill handles the complete deployment process to production.
  It covers environment checks, rollback procedures, and post-deploy
  verification. Use this before deploying any code to production.

# 高效（约 9 tokens）
description: Use when deploying to production or rolling back.
```

路由准确率差距不大，但 45 tokens × 20 个 Skill = 900 tokens 常驻开销，而 9 tokens × 20 = 180 tokens，差 5 倍。

描述太短也有问题。`help with backend` 等于任何后端工作都能触发，路由会乱。有效的描述符是路由条件：`Use when...` 说明什么时候该用，`Don't use when...` 划清边界，再补几条反例。测试数据显示：没有反例时路由准确率从基准 73% 掉到 53%，加上反例后升到 85%，响应时间还降了 18.1%。反例不是可选项，是描述符能不能起作用的关键。

但我之前写的 description 全在做自我介绍：

```yaml
# 我的原始写法
description: 顶级战略产品师。对当前项目进行深度战略审视，通过犀利提问暴露产品盲区，
  输出竞品调研、产品重构方案和商业化路径。融合 Marty Cagan 的产品发现思想、
  Peter Thiel 的垄断战略和 Y Combinator 的增长方法论。
```

这段 description 有 3 个问题：

- **角色宣言开头**："顶级战略产品师"——Claude 不需要知道你自封了什么头衔
- **流程摘要**："通过犀利提问暴露产品盲区，输出竞品调研..."——把 Skill 正文的工作流程压缩到了 description 里
- **没有触发条件**：Claude 读完这段话，知道这个 Skill 很厉害，但不知道什么情况下该用它

## 2. 流程摘要是最危险的陷阱

在所有错误中，"在 description 里概括工作流程"是杀伤力最大的。

官方规范的测试发现：当 description 里写了 "code review between tasks"，Claude 只做了一次 review。但 Skill 正文的流程图明确要求两次 review（先查规范合规，再查代码质量）。

原因是 Claude 把 description 当成了快捷指令，跳过了正文。

**Description 越详细，Skill 正文越容易被忽略。**

我的 `code-simplifier` 就是典型反面教材。原始 description 长达 300+ 字符，包含完整的功能说明、两种工作模式、甚至内嵌了两个 example 标签：

```yaml
# 反面教材：300+ 字符的 description
description: "代码简化与优化专家/代码简化。Use this agent when you need to simplify,
  optimize, refactor, or clean up code. This agent helps reduce complexity,
  improve readability, and ensure code follows best practices like YAGNI, KISS,
  and DRY principles. Supports two modes: analysis mode (provides simplification
  suggestions) and execution mode (directly modifies code). Works with any
  programming language. Examples: <example>..."
```

Claude 读到这段 description 就已经"知道该怎么做了"，SKILL.md 正文里精心设计的评估维度、简化策略、代码模式对比？大概率直接跳过。

## 3. 正确的写法：只写触发条件

规范要求 description 以 `Use when...` 开头，只描述什么情况下应该加载这个 Skill。

修正后：

```yaml
# 修正后
description: Use when code has excessive complexity, deep nesting, unused
  abstractions, or violates YAGNI/KISS/DRY principles and needs simplification
```

对比：

| 维度 | 修正前 | 修正后 |
|------|--------|--------|
| 开头 | "代码简化与优化专家" | "Use when" |
| 内容 | 功能说明 + 模式介绍 + 示例 | 触发场景 |
| 长度 | 300+ 字符 | ~120 字符 |
| Claude 行为 | 按 description 执行，跳过正文 | 匹配后加载正文，按正文执行 |

## 4. 我犯的 5 类 Description 错误

审计完 19 个 Skill，错误模式可以归为 5 类：

### 4.1 角色宣言式

```yaml
# ❌ 我是谁
description: 顶级 UI/UX 设计审计师。
description: 代码重构专家/代码重构。
description: 每日书籍推荐官。

# ✅ 什么时候找我
description: Use when auditing UI/UX design quality, reviewing visual aesthetics...
```

"顶级""专家""官"这些词对 Claude 的路由判断没有任何信息量。Claude 不会因为你自称"顶级"就优先加载你。

### 4.2 功能说明式

```yaml
# ❌ 我能做什么
description: 价值判断与打分工具。对书籍、文章、GitHub项目进行多维度评分。

# ✅ 什么场景需要我
description: Use when evaluating whether a book, article, GitHub project...
  is worth investing time in
```

### 4.3 穷举触发词式

```yaml
# ❌ 列举所有可能的触发场景
description: 当用户需要：(1) 查询某领域最新新闻 (2) 了解某公司动态
  (3) 追踪某人物近况 (4) 获取某地区新闻 (5) 了解某产品最新情况
  (6) 追踪某事件进展 (7) 询问需要最新信息才能回答的问题...
  触发关键词包括：新闻、动态、最新、最近、近况、进展、资讯等。

# ✅ 概括核心场景
description: Use when the user asks about latest news, recent developments,
  or current status of any topic, company, person, or event
```

穷举 7 个场景 + 7 个关键词，不仅浪费 token，还暗示了"不在列表里的场景不要触发"。

### 4.4 流程摘要式

前面已经详细说过，再看一个例子：

```yaml
# ❌ 把正文流程塞进 description
description: 实施前置信度检查。用于新功能开发、Bug修复、代码重构等复杂任务开始前。
  自动触发，无需手动调用。

# ✅ 只写触发条件
description: Use when starting complex tasks like feature development, bug fixes,
  or code refactoring
```

### 4.5 混合语言堆叠式

```yaml
# ❌ 中英文混杂 + 关键词堆叠
description: codereview / code review / 代码审查 - Go 代码审查技能，
  专注于性能、并发安全、安全性和可读性四大核心维度。

# ✅ 清晰的触发条件
description: Use when reviewing Go code for performance, concurrency safety,
  security vulnerabilities, or readability issues
```

`codereview / code review / 代码审查` 这种 SEO 式关键词堆叠，在 Claude 的语义理解面前完全多余。

## 5. Skill 的数量和质量控制

审计还暴露了另一个问题：我把 7 个"每日内容生成器"做成了 Skill。

这些 Skill 的共同特征是：每天最多用一次，不辅助编程任务，本质上是固定格式的 Prompt 模板。它们作为 Skill 存在的代价是：每次对话启动时，Claude 都要扫描它们的 description，判断是否需要加载——对于一个编程助手来说，99% 的对话都不需要"每日书籍推荐"。

但它们对我仍然有用。解决方案不是删除，而是**降级为手动触发**：

```yaml
# 自动匹配模式（Claude 每次都要扫描判断）
description: Use when the user asks for book recommendations...

# 手动触发模式（Claude 扫描时直接跳过）
description: Only invoke when explicitly requested via "书籍推荐"、"@book-rec".
  Do NOT auto-trigger.
```

`"Do NOT auto-trigger"` 让 Claude 在常规扫描时跳过这个 Skill，但用户主动提及触发词时仍然可以加载。成本从"每次对话都扫描"降为"仅在需要时加载"。

几个典型的 Skill 反模式也值得注意：

- 正文几百行工作手册全塞进 SKILL.md 而不是拆成 supporting files
- 一个 Skill 试图覆盖 review、deploy、debug、incident 五件事
- 有副作用的 Skill（比如触发外部 API 写操作）没有显式限制调用时机

这三个问题都会让 Skill 路由失准，而且很难排查。

另外，Skills 和 MCP 在上下文成本上的特征并不相同。MCP 会把完整结果直接返回给模型，更容易迅速吃掉上下文预算；CLI + 单句描述的 Skill 更接近模型熟悉的调用方式，在大多数可过滤、可拼接的数据读取任务里也更简洁。当然 MCP 也有明确适用场景，例如 Playwright 这类需要维护状态的任务。

## 6. 正文里的"你是..."角色扮演

修完 description 以为万事大吉，结果审查正文发现 19 个 Skill 里有 10 个以"你是..."开头：

```markdown
# ❌ 角色扮演开头
你是一位资深 Go 架构师，遵循 Effective Go 及 Uber Go Style Guide 规范。

你是一位融合乔纳森·艾维（Apple）的克制精密与原研哉（MUJI）的空灵留白的
首席设计官。你有 15+ 年的产品设计经验，曾主导过亿级用户产品的设计系统。
```

Skill 规范说得很清楚：**Skills are reusable techniques, patterns, tools, reference guides.** 不是角色卡。

"你是一位资深 Go 架构师"——Claude 已经知道自己会写 Go。"你有 15+ 年的产品设计经验"——这是虚构的履历，对输出质量没有帮助，反而浪费 token 并可能干扰模型本身的能力边界判断。

修正方式是直接以核心原则或概述开头：

```markdown
# ✅ 直接切入
## Overview
Go 代码审查，聚焦性能、并发安全、安全性和可读性四个维度。
遵循 Effective Go 及 Uber Go Style Guide。
```

这不是风格偏好，是 token 经济学。每个"你是..."前言占 30-80 个 token，10 个 Skill 累计 300-800 token，每次加载都在消耗上下文预算，换来的只是一段模型会忽略的人格设定。

## 7. 608 行的 Skill 应该拆分

我的 `mermaid-generator` 有 608 行、1,694 个词——规范建议上限是 500 词。

原因是我把 16 种图表的完整模板全部内联到了 SKILL.md 里。每次用户说"画个流程图"，Claude 都要加载全部 16 种图表的模板代码，包括用不到的桑基图、象限图、Git 图。

规范的建议很明确：**Heavy reference (100+ lines) → 拆到 supporting file。**

```
mermaid-generator/
  SKILL.md              # 核心规则 + 选型逻辑（130 行，530 词）
  chart-templates.md    # 16 种图表模板（448 行，按需引用）
```

拆分后 SKILL.md 从 1,694 词降到 530 词，模板文件只在 Claude 确认了图表类型后才被引用加载。单次对话节省约 1,100 token 的无效加载。

## 8. 一条检验标准

写完 description 后，用这个问题检验：

> 如果 Claude 只读 description、不读 SKILL.md 正文，它的行为会和读了正文一样吗？

如果答案是"差不多"，说明 description 泄露了太多信息。Claude 会走捷径。

好的 description 应该让 Claude 知道"我需要加载这个 Skill"，但不知道"加载后该怎么做"。触发条件归 description，执行逻辑归正文。各司其职。

---

## 参考资料

- [superpowers/writing-skills](https://github.com/obra/superpowers-marketplace/tree/main/superpowers/skills/writing-skills) — superpowers 插件中的 Skill 编写规范，本文所有规范引用的来源
- [anthropic-best-practices.md](https://github.com/obra/superpowers-marketplace/tree/main/superpowers/skills/writing-skills/anthropic-best-practices.md) — 同目录下的 Anthropic 官方最佳实践参考文档





