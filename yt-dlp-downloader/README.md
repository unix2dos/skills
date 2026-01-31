# yt-dlp Downloader Skill

A [Cursor](https://cursor.sh) Agent Skill for downloading videos from YouTube, Bilibili, Twitter, and thousands of other sites using [yt-dlp](https://github.com/yt-dlp/yt-dlp).

[中文文档](./README_CN.md)

## Features

- Download videos from 1000+ websites
- Extract audio (MP3)
- Download subtitles
- Select video quality (720p/1080p/best)
- Auto-handle YouTube 403 errors with browser cookies
- Resume interrupted downloads

## Prerequisites

Before using this skill, make sure you have the following installed:

```bash
# Install yt-dlp
pip install yt-dlp

# Install ffmpeg (required for audio extraction)
brew install ffmpeg  # macOS
# or: sudo apt install ffmpeg  # Linux
```

## Installation

### Option 1: Clone to Cursor skills directory

```bash
git clone https://github.com/MapleShaw/yt-dlp-downloader-skill.git ~/.cursor/skills/yt-dlp-downloader
```

### Option 2: Manual installation

1. Create the skill directory:
   ```bash
   mkdir -p ~/.cursor/skills/yt-dlp-downloader/scripts
   ```

2. Download `SKILL.md` and `scripts/download.sh` from this repository

3. Place them in the created directory

## Usage

Simply tell Cursor what you want to download:

| Command | Example |
|---------|---------|
| Download video | "Download this video https://youtube.com/watch?v=xxx" |
| Extract audio | "Extract audio from https://youtube.com/watch?v=xxx" |
| Download with subtitles | "Download with subtitles https://youtube.com/watch?v=xxx" |
| Specific quality | "Download in 720p https://youtube.com/watch?v=xxx" |

### Example Conversations

**You:** Download this video https://www.youtube.com/watch?v=xxx

**Cursor:** 
```bash
yt-dlp -P "~/Downloads/yt-dlp" --cookies-from-browser chrome "https://www.youtube.com/watch?v=xxx"
```

## Supported Sites

yt-dlp supports thousands of sites including:

- YouTube / YouTube Music
- Bilibili (B站)
- Twitter / X
- TikTok / Douyin (抖音)
- Vimeo
- Twitch
- And [many more...](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)

## Troubleshooting

| Error | Solution |
|-------|----------|
| HTTP 403 Forbidden (YouTube) | Use `--cookies-from-browser chrome` |
| yt-dlp not found | Run `pip install yt-dlp` |
| ffmpeg not found | Run `brew install ffmpeg` |
| Download fails | Run `pip install -U yt-dlp` to update |

## File Structure

```
yt-dlp-downloader/
├── SKILL.md              # Main skill instructions
└── scripts/
    └── download.sh       # Helper script
```

## License

MIT

## Credits

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - The powerful video downloader
- [Cursor](https://cursor.sh) - AI-powered code editor
