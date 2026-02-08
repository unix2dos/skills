# Daily Tech Digest

每日技术论坛热帖聚合器，从 6 大技术社区获取热门内容。

## 数据源

| 源 | 类型 | 获取内容 |
|----|------|----------|
| GitHub Trending | 代码托管 | 今日热门仓库 |
| Product Hunt | 产品发布 | 高票产品 |
| Reddit | r/programming | 热门帖子 |
| V2EX | 技术论坛 | 官方热帖 |
| linux.do | Discourse | 热门帖子 (RSS) |
| Nodeseek | VPS 论坛 | 日榜热帖 |

## 快速使用

```bash
# 获取全部源 (Markdown 格式)
python3 scripts/fetch_digest.py --source all --limit 5 --format markdown

# 仅获取特定源
python3 scripts/fetch_digest.py --source github,reddit --limit 5

# JSON 格式输出
python3 scripts/fetch_digest.py --source all --format json
```

## 环境变量

| 变量 | 说明 | 必需 |
|------|------|------|
| `PRODUCTHUNT_TOKEN` | Product Hunt API Token | 可选 |

## 依赖

```bash
pip install requests beautifulsoup4 lxml
```

## 触发词

- "技术热帖"
- "今日技术动态"
- "daily digest"
- "tech news"

## 许可

MIT
