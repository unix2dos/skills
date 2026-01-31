#!/bin/bash
# yt-dlp download helper script
# Usage: ./download.sh [options] URL
#
# Options:
#   -p, --path PATH      Download path (default: ~/Downloads/yt-dlp)
#   -a, --audio          Extract audio only (MP3)
#   -s, --subs           Download subtitles
#   -q, --quality NUM    Max video height (720, 1080, etc.)
#   -f, --format ID      Specific format ID
#   -l, --list           List available formats
#   -h, --help           Show this help

set -e

# Default values
DOWNLOAD_PATH="${HOME}/Downloads/yt-dlp"
AUDIO_ONLY=false
DOWNLOAD_SUBS=false
QUALITY=""
FORMAT_ID=""
LIST_FORMATS=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            DOWNLOAD_PATH="$2"
            shift 2
            ;;
        -a|--audio)
            AUDIO_ONLY=true
            shift
            ;;
        -s|--subs)
            DOWNLOAD_SUBS=true
            shift
            ;;
        -q|--quality)
            QUALITY="$2"
            shift 2
            ;;
        -f|--format)
            FORMAT_ID="$2"
            shift 2
            ;;
        -l|--list)
            LIST_FORMATS=true
            shift
            ;;
        -h|--help)
            head -15 "$0" | tail -13
            exit 0
            ;;
        *)
            URL="$1"
            shift
            ;;
    esac
done

# Check if URL is provided
if [[ -z "$URL" ]]; then
    echo "Error: No URL provided"
    echo "Usage: $0 [options] URL"
    exit 1
fi

# Check dependencies
if ! command -v yt-dlp &> /dev/null; then
    echo "Error: yt-dlp is not installed"
    echo "Install with: pip install yt-dlp"
    exit 1
fi

# List formats only
if [[ "$LIST_FORMATS" == true ]]; then
    yt-dlp -F "$URL"
    exit 0
fi

# Create download directory
mkdir -p "$DOWNLOAD_PATH"

# Build command
CMD="yt-dlp -P \"$DOWNLOAD_PATH\""

# Add format selection
if [[ -n "$FORMAT_ID" ]]; then
    CMD="$CMD -f \"$FORMAT_ID\""
elif [[ -n "$QUALITY" ]]; then
    CMD="$CMD -f \"bestvideo[height<=$QUALITY]+bestaudio/best[height<=$QUALITY]\""
fi

# Audio extraction
if [[ "$AUDIO_ONLY" == true ]]; then
    if ! command -v ffmpeg &> /dev/null; then
        echo "Warning: ffmpeg not found. Audio extraction may fail."
        echo "Install with: brew install ffmpeg"
    fi
    CMD="$CMD -x --audio-format mp3"
fi

# Subtitles
if [[ "$DOWNLOAD_SUBS" == true ]]; then
    CMD="$CMD --write-subs --sub-langs all"
fi

# Add URL
CMD="$CMD \"$URL\""

# Execute
echo "Executing: $CMD"
echo "Download path: $DOWNLOAD_PATH"
echo ""
eval $CMD

echo ""
echo "Download complete! Files saved to: $DOWNLOAD_PATH"
