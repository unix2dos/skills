---
name: daily-tech-digest
description: "每日技术论坛热帖聚合器。聚焦 V2EX、linux.do、Nodeseek、Reddit r/programming、GitHub Trending、Product Hunt 六大技术社区，获取每日热门帖子并生成深度解读报告。触发词：'技术热帖'、'今日技术动态'、'daily digest'。"
---

# Daily Tech Digest Skill

获取技术论坛每日热帖，生成带深度解读的 Markdown 报告。

## 数据源

| 源 | 类型 | 获取内容 | 状态 |
|----|------|----------|------|
| GitHub | Trending | 今日热门仓库 | ✅ |
| Product Hunt | 产品发布 | 高票产品 | ✅ |
| Reddit | r/programming | Hot posts | ✅ |
| V2EX | 论坛 | 官方热帖 API | ✅ |
| linux.do | Discourse 论坛 | 热帖 (RSS) | ✅ |
| Nodeseek | VPS 论坛 | 日榜 (第三方 API) | ✅ |

## 使用方法

### 快速开始

```bash
# 获取全部源 (输出 JSON)
python3 scripts/fetch_digest.py --source all --limit 5
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
| `--source` | 数据源: `github`, `producthunt`, `reddit`, `v2ex`, `linuxdo`, `nodeseek`, `all` | `all` |
| `--limit` | 每个源获取的条数 | `5` |

## Agent 执行流程

当用户说 **"给我今天的技术热帖"** 或类似触发词时：

1. **执行脚本**获取原始 JSON 数据：
   ```bash
   python3 scripts/fetch_digest.py --source all --limit 5
   ```

2. **AI 后处理**：
   - 将 Reddit/GitHub/ProductHunt 英文标题和简介翻译成中文
   - 对每条热帖生成 1-2 句解读

3. **生成并保存 Markdown**：将翻译后的内容保存到 `daily-tech-digest_outputs/digest_YYYY-MM-DD.md`

4. **展示给用户**：在对话中呈现完整报告

## 输出格式规范

### Markdown 报告结构

```markdown
# 📰 Daily Tech Digest

> Generated: 2026-02-08 14:00

---

## 🔥 GitHub Trending

1. [owner/repo](链接) ⭐1.2k
   简介中文翻译...

---

## 🚀 Product Hunt

1. [产品名](链接) 🔺882
   简介中文翻译...

---

## 💬 Reddit r/programming

1. [标题中文翻译](链接) ↑710

---

## 🌐 V2EX

1. [标题](链接) 57回复

---

## 🐧 linux.do

1. [标题](链接) 🔥

---

## 📊 Nodeseek

1. [标题](链接) 热度5498
```

## 配置

### Product Hunt Token

脚本内置了默认 Token，也可通过环境变量覆盖：

```bash
export PRODUCTHUNT_TOKEN="your_token_here"
```
