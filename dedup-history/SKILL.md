---
name: dedup-history
description: Use when a content-generating skill needs deduplication against history records. Referenced as a sub-skill by skills that produce daily/random content.
---

# 通用去重流程

多个 Skill 共享的内容去重机制。

## 默认约定

| 参数 | 默认值 | 说明 |
|------|--------|------|
| 历史文件 | `{skill-name}_history.json` | 与调用方 SKILL.md 同目录 |
| 上限条数 | 100 | 达到上限时移除最旧一条（FIFO） |
| 领域轮换排除数 | 3 | 排除最近 N 条的领域 |

调用方只需在自己的 SKILL.md 中声明 `**REQUIRED SUB-SKILL:** Use dedup-history`。如需覆盖默认值，显式声明即可。

## 流程

1. 读取历史文件（与调用方 SKILL.md 同目录，若不存在则初始化为空数组 `[]`）
2. 检查候选内容是否已在历史记录中
3. 若重复：重新选择（最多 3 次），3 次后输出提示"库存丰富但需要补充新内容"
4. 生成内容
5. 追加新记录到历史文件
6. 如果记录数达到上限，移除最旧的一条（FIFO）

## 历史记录格式

```json
[
  {"title": "内容标题", "domain": "所属领域", "date": "YYYY-MM-DD"},
  ...
]
```

各 Skill 可扩展字段（如 `author`、`region`），但 `title` 和 `date` 为必须字段。

## 领域轮换

若 Skill 有领域池，从历史记录中获取最近 N 条的领域，排除后在剩余领域中随机选择，确保连续输出不重复领域。
