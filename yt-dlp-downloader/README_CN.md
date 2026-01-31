# yt-dlp 视频下载 Skill

一个用于 [Cursor](https://cursor.sh) 的 Agent Skill，使用 [yt-dlp](https://github.com/yt-dlp/yt-dlp) 从 YouTube、B站、Twitter 等上千个网站下载视频。

[English](./README.md)

## 功能特点

- 支持 1000+ 网站的视频下载
- 提取音频（MP3）
- 下载字幕
- 选择视频质量（720p/1080p/最佳）
- 自动处理 YouTube 403 错误（使用浏览器 cookies）
- 断点续传

## 前置要求

使用前请确保已安装以下工具：

```bash
# 安装 yt-dlp
pip install yt-dlp

# 安装 ffmpeg（音频提取需要）
brew install ffmpeg  # macOS
# 或者: sudo apt install ffmpeg  # Linux
```

## 安装方法

### 方法 1：克隆到 Cursor skills 目录

```bash
git clone https://github.com/MapleShaw/yt-dlp-downloader-skill.git ~/.cursor/skills/yt-dlp-downloader
```

### 方法 2：手动安装

1. 创建 skill 目录：
   ```bash
   mkdir -p ~/.cursor/skills/yt-dlp-downloader/scripts
   ```

2. 从本仓库下载 `SKILL.md` 和 `scripts/download.sh`

3. 放到创建的目录中

## 使用方法

直接告诉 Cursor 你想下载什么：

| 命令 | 示例 |
|------|------|
| 下载视频 | "下载这个视频 https://youtube.com/watch?v=xxx" |
| 提取音频 | "提取音频 https://youtube.com/watch?v=xxx" |
| 下载字幕 | "下载视频和字幕 https://youtube.com/watch?v=xxx" |
| 指定画质 | "下载 720p https://youtube.com/watch?v=xxx" |

### 对话示例

**你：** 下载这个视频 https://www.youtube.com/watch?v=xxx

**Cursor：**
```bash
yt-dlp -P "~/Downloads/yt-dlp" --cookies-from-browser chrome "https://www.youtube.com/watch?v=xxx"
```

## 支持的网站

yt-dlp 支持上千个网站，包括：

- YouTube / YouTube Music
- Bilibili（B站）
- Twitter / X
- TikTok / 抖音
- Vimeo
- Twitch
- [更多...](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)

## 常见问题

| 错误 | 解决方案 |
|------|----------|
| HTTP 403 Forbidden (YouTube) | 使用 `--cookies-from-browser chrome` |
| yt-dlp 未找到 | 运行 `pip install yt-dlp` |
| ffmpeg 未找到 | 运行 `brew install ffmpeg` |
| 下载失败 | 运行 `pip install -U yt-dlp` 更新 |

## 文件结构

```
yt-dlp-downloader/
├── SKILL.md              # 主 skill 指令文件
└── scripts/
    └── download.sh       # 辅助脚本
```

## 许可证

MIT

## 致谢

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - 强大的视频下载工具
- [Cursor](https://cursor.sh) - AI 驱动的代码编辑器
