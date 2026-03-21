---
name: mermaid-generator
description: Use when the user needs to generate diagrams, flowcharts, sequence diagrams, ER diagrams, or any visual chart in Mermaid format - triggers on "画图"、"图表"、"流程图"、"mermaid"
---

# Mermaid 图表生成

根据用户描述选择最合适的 Mermaid 图表类型，生成语法正确、配色专业的代码。

> ⚠️ **Obsidian 兼容模式**: 默认使用 Obsidian 兼容语法，避免 `<br/>` 换行、`subgraph ID["标题"]` 等不兼容写法。

## 核心原则

### 🎯 语法安全规则（必须遵守）

> **所有文本标签必须用双引号包裹**，以避免括号、冒号、特殊符号导致的语法错误。

```mermaid
%% ✅ 正确写法
A["用户登录(必填)"] --> B["验证: 检查密码"]

%% ❌ 错误写法 - 会导致解析失败
A[用户登录(必填)] --> B[验证: 检查密码]
```

### 🎨 配色策略

使用 `%%{init}%%` 配置主题变量，这是**最通用的配色方式**，兼容所有图表类型：

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'primaryColor': '#3B82F6', 'primaryTextColor': '#1E3A5F', 'primaryBorderColor': '#2563EB', 'lineColor': '#60A5FA', 'secondaryColor': '#10B981', 'tertiaryColor': '#F59E0B'}}}%%
```

### ⚠️ 图表类型语法限制（必须遵守）

> **不同图表类型支持的样式语法不同，混用会导致渲染失败！**

| 语法 | 支持的图表类型 | 说明 |
|-----|---------------|------|
| `classDef` + `class` | **仅 flowchart** | 流程图专属 |
| `style` 关键字 | classDiagram, erDiagram | 类图/ER图 |
| `themeVariables` | **所有类型** ✅ | 推荐使用 |

```mermaid
%% ❌ 错误：在 sequenceDiagram 中使用 classDef（会报错）
sequenceDiagram
    classDef client fill:#4F46E5  %% 不支持！

%% ✅ 正确：sequenceDiagram 只能用 themeVariables
%%{init: {'themeVariables': {'actorBkg': '#4F46E5'}}}%%
sequenceDiagram
    participant C as "客户端"
```

**推荐配色板（明亮蓝专业风格）**:

| 用途 | 颜色 | Hex |
|------|------|-----|
| 主色（流程/重点） | 明亮蓝 | `#3B82F6` |
| 成功/完成 | 翠绿 | `#10B981` |
| 警告/注意 | 琥珀 | `#F59E0B` |
| 错误/危险 | 红色 | `#EF4444` |
| 信息/辅助 | 天蓝 | `#0EA5E9` |
| 连接线 | 浅蓝 | `#60A5FA` |

---

## Instructions

### Step 1: 分析用户需求，决定图表类型

根据用户描述的内容，选择**最适合**的图表类型：

| 场景关键词 | 推荐图表 | Mermaid 语法 |
|-----------|---------|-------------|
| 步骤、流程、决策、分支、判断 | **流程图** | `flowchart TD` / `flowchart LR` |
| 调用、请求、响应、交互、消息、API | **时序图** | `sequenceDiagram` |
| 类、接口、继承、属性、方法、OOP | **类图** | `classDiagram` |
| 状态、转换、触发、生命周期 | **状态图** | `stateDiagram-v2` |
| 表、字段、关系、数据库、主键外键 | **ER 图** | `erDiagram` |
| 任务、排期、里程碑、项目进度 | **甘特图** | `gantt` |
| 占比、比例、分布 | **饼图** | `pie` |
| 用户体验、流程体验、情感曲线 | **用户旅程图** | `journey` |
| 分支、合并、提交、版本 | **Git 图** | `gitGraph` |
| 层级、分类、脑图、知识结构 | **思维导图** | `mindmap` |
| 历史、事件、时间节点 | **时间线** | `timeline` |
| 需求、依赖、层级结构 | **需求图** | `requirementDiagram` |
| 块、模块、架构、系统组件 | **块图** | `block-beta` |
| 象限、评估、二维分类 | **象限图** | `quadrantChart` |
| XY 坐标、趋势、数据点 | **XY 图** | `xychart-beta` |
| 环绕桑基图、流量分布 | **桑基图** | `sankey-beta` |

### Step 2: 生成 Mermaid 代码

参考 chart-templates.md 中的完整模板生成代码。所有标签用双引号包裹，使用 `%%{init}%%` 配置主题。

**输出格式**:

```markdown
## [图表类型名称]

> 选择理由: [一句话解释]

​```mermaid
[完整的 Mermaid 代码]
​```

### 图表说明
[简要解释图表结构和关键节点]

### 自定义提示
[告诉用户如何修改以适应自己的需求]
```

---

## 错误排查指南

| 常见错误 | 原因 | 解决方案 |
|---------|------|---------|
| Parse error | 标签含特殊字符 | 用双引号包裹所有标签 |
| Unexpected token | 括号/冒号未转义 | `["文本(说明)"]` 或 `["类型: 描述"]` |
| 主题不生效 | init 语法错误 | 检查 JSON 格式，使用单引号 |
| 样式不显示 | classDef 名称不匹配 | 确保 `class` 引用正确的 classDef 名称 |
| classDef 语法错误 | 在不支持的图表中使用 | classDef 仅支持 flowchart，其他类型用 themeVariables |
| sequenceDiagram 渲染失败 | 混用了 class/classDef 语法 | 移除 classDef，改用 themeVariables 配色 |
| 边标签渲染失败 | 使用多个竖线分隔 | `-->|条件一|条件二|` 改为 `-->|"条件一/条件二"|` |
| mindmap 解析失败 | init 配置或 root 语法 | 移除 `%%{init}%%`，使用 `root[文本]`，2 空格缩进 |
| Unsupported markdown: list | Obsidian 不支持 `<br/>` 或 `subgraph ID["标题"]` | 去掉 `<br/>`，改用 `subgraph ID [标题]`（无引号） |
