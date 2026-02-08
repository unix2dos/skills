---
name: daily-tech-digest
description: "每日技术论坛热帖聚合器。聚焦 V2EX、linux.do、Nodeseek、Reddit r/programming、GitHub Trending、Product Hunt 六大技术社区，获取每日热门帖子并生成深度解读报告。触发词：'技术热帖'、'今日技术动态'、'daily digest'。"
---

# Daily Tech Digest Skill

获取技术论坛每日热帖，生成带深度解读的 Markdown 报告。

## 数据源

| 源 | 类型 | 获取内容 | 状态 |
|----|------|----------|------|
| V2EX | 论坛 | 官方热帖 API | ✅ |
| linux.do | Discourse 论坛 | 最新帖子(按赞排序) | ⚠️ 可能被限制 |
| Nodeseek | VPS 论坛 | 日榜 (第三方 API) | ✅ |
| Reddit | r/programming | Hot posts | ✅ |
| GitHub | Trending | 今日热门仓库 | ✅ |
| Product Hunt | 产品发布 | 高票产品 | ✅ |

> **Note**: linux.do 有反爬保护，在某些网络环境下可能返回 403。

## 使用方法

### 快速开始

```bash
# 获取全部源 (JSON 格式)
python3 scripts/fetch_digest.py --source all --limit 5

# 获取全部源 (Markdown 格式)
python3 scripts/fetch_digest.py --source all --limit 5 --format markdown
```

### 单独源

```bash
# V2EX 热帖
python3 scripts/fetch_digest.py --source v2ex --limit 5

# GitHub Trending
python3 scripts/fetch_digest.py --source github --limit 10

# 多个源组合
python3 scripts/fetch_digest.py --source v2ex,github,nodeseek --limit 5
```

### 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--source` | 数据源，可用: `v2ex`, `linuxdo`, `nodeseek`, `reddit`, `github`, `producthunt`, `all` | `all` |
| `--limit` | 每个源获取的条数 | `5` |
| `--format` | 输出格式: `json` 或 `markdown` | `json` |

## Agent 执行流程

当用户说 **"给我今天的技术热帖"** 或类似触发词时：

1. **执行脚本**获取原始数据：
   ```bash
   python3 scripts/fetch_digest.py --source all --limit 5 --format json
   ```

2. **AI 深度解读**：对每条热帖生成 1-2 句解读，说明：
   - 这条为什么值得关注？
   - 对开发者有什么启发？

3. **生成报告**：保存到 `daily-tech-digest_outputs/digest_YYYYMMDD_HHMM.md`

4. **展示给用户**：在对话中呈现完整报告

## 输出格式规范

### Markdown 报告结构

```markdown
# 📰 Daily Tech Digest - 2026-02-08

## 🔥 今日亮点
> 3-5 条最值得关注的内容

## V2EX 热帖
1. [标题](链接)
   - 热度: XX 回复
   - 💡 解读: 为什么这条值得关注...

## GitHub Trending
1. [owner / repo](链接)
   - ⭐ 1.2k stars today
   - 💡 解读: 这个项目解决了什么问题...

...
```

## 配置

### Product Hunt Token

脚本内置了默认 Token，也可通过环境变量覆盖：

```bash
export PRODUCTHUNT_TOKEN="your_token_here"
```
