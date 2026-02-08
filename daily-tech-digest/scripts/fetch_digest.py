#!/usr/bin/env python3
"""
Daily Tech Digest - 技术论坛热帖聚合器
支持: V2EX, linux.do, Nodeseek, Reddit r/programming, GitHub Trending, Product Hunt
"""

import argparse
import json
import os
import sys
import requests
from bs4 import BeautifulSoup
from datetime import datetime

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

# Product Hunt Token 配置
# 申请流程:
# 1. 登录 https://www.producthunt.com
# 2. 访问 https://api.producthunt.com/v2/oauth/applications
# 3. 点击 "Add an Application"，填写 Name 和 Redirect URI (可用 https://localhost:3000/)
# 4. 创建后，在应用详情页点击 "Create Token" 生成 Developer Token
# 5. 设置环境变量: export PRODUCTHUNT_TOKEN="your_token_here"
PH_TOKEN = os.environ.get("PRODUCTHUNT_TOKEN", "")


def fetch_v2ex(limit=5):
    """V2EX 热帖 - 官方 API"""
    try:
        resp = requests.get("https://www.v2ex.com/api/topics/hot.json", headers=HEADERS, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        items = []
        for t in data[:limit]:
            items.append({
                "source": "V2EX",
                "title": t.get("title", ""),
                "url": t.get("url", ""),
                "heat": f"{t.get('replies', 0)} 回复",
                "node": t.get("node", {}).get("title", "")
            })
        return items
    except Exception as e:
        sys.stderr.write(f"[V2EX] Error: {e}\n")
        return []


def fetch_linuxdo(limit=5):
    """linux.do 热帖 - RSS Feed (过滤置顶帖)"""
    try:
        resp = requests.get("https://linux.do/hot.rss", headers=HEADERS, timeout=15)
        resp.raise_for_status()

        # 解析 RSS XML
        soup = BeautifulSoup(resp.content, "xml")
        items = []
        for item in soup.find_all("item"):
            # 过滤置顶帖 (discourse:topicPinned = Yes)
            pinned_tag = item.find("discourse:topicPinned")
            if pinned_tag and pinned_tag.get_text(strip=True) == "Yes":
                continue

            title = item.find("title").get_text(strip=True) if item.find("title") else ""
            link = item.find("link").get_text(strip=True) if item.find("link") else ""

            items.append({
                "source": "linux.do",
                "title": title,
                "url": link,
                "heat": "🔥 Hot"
            })

            if len(items) >= limit:
                break
        return items
    except Exception as e:
        sys.stderr.write(f"[linux.do] Error: {e}\n")
        return []


def fetch_nodeseek(limit=5):
    """Nodeseek 日榜 - 第三方 API (api.bimg.eu.org)"""
    try:
        resp = requests.get("https://api.bimg.eu.org/daily.json", headers=HEADERS, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        posts = data.get("posts", [])
        items = []
        for item in posts[:limit]:
            post = item.get("post", {})
            items.append({
                "source": "Nodeseek",
                "title": post.get("title", ""),
                "url": f"https://www.nodeseek.com/post-{post.get('id', '')}-1",
                "heat": f"热度 {int(item.get('score', 0))}",
                "author": post.get("author", "")
            })
        return items
    except Exception as e:
        sys.stderr.write(f"[Nodeseek] Error: {e}\n")
        return []


def fetch_reddit(limit=5):
    """Reddit r/programming 热帖"""
    try:
        headers = {**HEADERS, "Accept": "application/json"}
        resp = requests.get("https://www.reddit.com/r/programming/hot.json?limit=20", headers=headers, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        children = data.get("data", {}).get("children", [])
        items = []
        for child in children:
            post = child.get("data", {})
            if post.get("stickied"):  # 跳过置顶
                continue
            items.append({
                "source": "Reddit",
                "title": post.get("title", ""),
                "url": f"https://reddit.com{post.get('permalink', '')}",
                "heat": f"↑{post.get('ups', 0)} / {post.get('num_comments', 0)} 评论",
                "subreddit": post.get("subreddit", "")
            })
            if len(items) >= limit:
                break
        return items
    except Exception as e:
        sys.stderr.write(f"[Reddit] Error: {e}\n")
        return []


def fetch_github(limit=5):
    """GitHub Trending - HTML 爬取"""
    try:
        resp = requests.get("https://github.com/trending", headers=HEADERS, timeout=10)
        resp.raise_for_status()
        soup = BeautifulSoup(resp.text, "html.parser")
        items = []
        for article in soup.select("article.Box-row")[:limit]:
            h2 = article.select_one("h2 a")
            if not h2:
                continue
            repo_path = h2.get("href", "").strip()
            title = repo_path.lstrip("/").replace("/", " / ")

            desc_tag = article.select_one("p")
            desc = desc_tag.get_text(strip=True) if desc_tag else ""

            stars_tag = article.select_one("a[href$='/stargazers']")
            stars = stars_tag.get_text(strip=True) if stars_tag else ""

            items.append({
                "source": "GitHub",
                "title": title,
                "url": f"https://github.com{repo_path}",
                "heat": f"⭐ {stars}",
                "description": desc
            })
        return items
    except Exception as e:
        sys.stderr.write(f"[GitHub] Error: {e}\n")
        return []


def fetch_producthunt(limit=5):
    """Product Hunt 热门产品 - GraphQL API"""
    if not PH_TOKEN:
        sys.stderr.write("[ProductHunt] No token configured\n")
        return []

    query = """
    query {
        posts(first: %d, order: VOTES) {
            edges {
                node {
                    name
                    tagline
                    url
                    votesCount
                    createdAt
                }
            }
        }
    }
    """ % (limit + 5)  # 多取几个以防过滤

    try:
        resp = requests.post(
            "https://api.producthunt.com/v2/api/graphql",
            headers={
                "Authorization": f"Bearer {PH_TOKEN}",
                "Content-Type": "application/json"
            },
            json={"query": query},
            timeout=10
        )
        resp.raise_for_status()
        data = resp.json()
        edges = data.get("data", {}).get("posts", {}).get("edges", [])
        items = []
        for edge in edges[:limit]:
            node = edge.get("node", {})
            items.append({
                "source": "ProductHunt",
                "title": node.get("name", ""),
                "url": node.get("url", ""),
                "heat": f"🔺 {node.get('votesCount', 0)} votes",
                "tagline": node.get("tagline", "")
            })
        return items
    except Exception as e:
        sys.stderr.write(f"[ProductHunt] Error: {e}\n")
        return []


# 数据源映射 (按输出顺序排列)
# 顺序: GitHub → ProductHunt → Reddit → V2EX → linux.do → Nodeseek
from collections import OrderedDict
SOURCES = OrderedDict([
    ("github", fetch_github),
    ("producthunt", fetch_producthunt),
    ("reddit", fetch_reddit),
    ("v2ex", fetch_v2ex),
    ("linuxdo", fetch_linuxdo),
    ("nodeseek", fetch_nodeseek),
])


def main():
    parser = argparse.ArgumentParser(description="Daily Tech Digest - 技术热帖聚合")
    parser.add_argument("--source", default="all",
                        help="数据源: v2ex, linuxdo, nodeseek, reddit, github, producthunt, all")
    parser.add_argument("--limit", type=int, default=5, help="每个源的条数 (默认 5)")
    parser.add_argument("--format", choices=["json", "markdown"], default="json",
                        help="输出格式: json 或 markdown")
    args = parser.parse_args()

    # 确定要抓取的源
    if args.source == "all":
        sources_to_fetch = list(SOURCES.keys())
    else:
        sources_to_fetch = [s.strip() for s in args.source.split(",") if s.strip() in SOURCES]

    if not sources_to_fetch:
        sys.stderr.write("No valid sources specified\n")
        sys.exit(1)

    # 抓取数据
    all_results = {}
    for source_name in sources_to_fetch:
        fetcher = SOURCES[source_name]
        all_results[source_name] = fetcher(args.limit)

    # 输出
    if args.format == "json":
        print(json.dumps(all_results, indent=2, ensure_ascii=False))
    else:
        # Markdown 格式
        now = datetime.now().strftime("%Y-%m-%d %H:%M")
        print(f"# 📰 Daily Tech Digest\n")
        print(f"> Generated: {now}\n")

        for source_name, items in all_results.items():
            print(f"\n## {source_name.upper()}\n")
            if not items:
                print("- ⚠️ 获取失败或无数据\n")
                continue
            for i, item in enumerate(items, 1):
                title = item.get("title", "Unknown")
                url = item.get("url", "#")
                heat = item.get("heat", "")
                print(f"{i}. [{title}]({url})")
                print(f"   - 热度: {heat}")
                # 额外信息
                if item.get("tagline"):
                    print(f"   - {item['tagline']}")
                if item.get("description"):
                    print(f"   - {item['description'][:80]}...")
                print()


if __name__ == "__main__":
    main()
