#!/bin/bash
#
# update-skills.sh - 批量更新三方 Skills 到最新版本
#
# 从上游 GitHub 仓库拉取最新代码，同步到本地对应 skill 目录。
# 用法:
#   bash update-skills.sh            # 执行更新
#   bash update-skills.sh --dry-run  # 仅预览，不实际修改

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false
TMPDIR_BASE=""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ─── 三方 Skill 映射表 ───────────────────────────────────────────
# 格式: "本地目录名|GitHub仓库|上游子目录(. 表示仓库根目录)|默认分支"
SKILLS=(
  "skill-creator|anthropics/skills|skills/skill-creator|main"
  "yt-dlp-downloader|MapleShaw/yt-dlp-downloader-skill|.|master"
  "humanizer-zh|op7418/Humanizer-zh|.|main"
  "find-skills|vercel-labs/skills|skills/find-skills|main"
  "hackernews|vm0-ai/vm0-skills|hackernews|main"
)

# 仓库根目录同步时需要排除的文件（不属于 skill 内容的仓库元文件）
REPO_ROOT_EXCLUDES=(
  "README.md"
  "README_CN.md"
  "LICENSE"
  ".git"
  ".gitignore"
  ".github"
)

# ─── 函数 ────────────────────────────────────────────────────────

cleanup() {
  if [[ -n "$TMPDIR_BASE" && -d "$TMPDIR_BASE" ]]; then
    rm -rf "$TMPDIR_BASE"
  fi
}

log_info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}   $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()   { echo -e "${RED}[FAIL]${NC} $*"; }
log_header()  { echo -e "\n${CYAN}━━━ $* ━━━${NC}"; }

update_skill() {
  local local_name="$1"
  local repo="$2"
  local upstream_path="$3"
  local branch="$4"

  local local_dir="$SCRIPT_DIR/$local_name"
  local clone_dir="$TMPDIR_BASE/$local_name"
  local repo_url="https://github.com/${repo}.git"

  log_header "$local_name"
  log_info "上游: ${repo} (branch: ${branch}, path: ${upstream_path})"

  # 1. 浅克隆上游仓库
  log_info "正在拉取上游仓库..."
  if ! git clone --depth 1 --branch "$branch" --quiet "$repo_url" "$clone_dir" 2>/dev/null; then
    log_error "克隆失败: $repo_url"
    return 1
  fi

  # 2. 确定源目录
  local src_dir
  if [[ "$upstream_path" == "." ]]; then
    src_dir="$clone_dir"
  else
    src_dir="$clone_dir/$upstream_path"
  fi

  if [[ ! -d "$src_dir" ]]; then
    log_error "上游路径不存在: $upstream_path"
    return 1
  fi

  # 3. 构建 rsync 排除参数
  local rsync_excludes=("--exclude=.git")
  if [[ "$upstream_path" == "." ]]; then
    for excl in "${REPO_ROOT_EXCLUDES[@]}"; do
      rsync_excludes+=("--exclude=$excl")
    done
  fi

  # 4. 同步文件
  if [[ "$DRY_RUN" == true ]]; then
    log_info "[DRY-RUN] 将要同步的文件:"
    rsync -avn --delete "${rsync_excludes[@]}" "$src_dir/" "$local_dir/" 2>/dev/null | head -30
  else
    mkdir -p "$local_dir"
    rsync -av --delete "${rsync_excludes[@]}" "$src_dir/" "$local_dir/" >/dev/null 2>&1
    log_success "$local_name 更新完成"
  fi

  return 0
}

# ─── 主流程 ───────────────────────────────────────────────────────

main() {
  # 解析参数
  for arg in "$@"; do
    case "$arg" in
      --dry-run) DRY_RUN=true ;;
      -h|--help)
        echo "用法: bash update-skills.sh [--dry-run]"
        echo ""
        echo "  --dry-run  仅预览变更，不实际修改文件"
        echo "  -h,--help  显示帮助信息"
        exit 0
        ;;
      *)
        echo "未知参数: $arg"
        exit 1
        ;;
    esac
  done

  # 创建临时目录
  TMPDIR_BASE="$(mktemp -d)"
  trap cleanup EXIT

  echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║    三方 Skill 批量更新工具                 ║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
  echo ""

  if [[ "$DRY_RUN" == true ]]; then
    log_warn "DRY-RUN 模式: 不会修改任何文件"
  fi

  log_info "Skills 目录: $SCRIPT_DIR"
  log_info "待更新 Skill 数量: ${#SKILLS[@]}"

  local success=0
  local failed=0
  local failed_names=()

  for entry in "${SKILLS[@]}"; do
    IFS='|' read -r local_name repo upstream_path branch <<< "$entry"

    if update_skill "$local_name" "$repo" "$upstream_path" "$branch"; then
      ((success++))
    else
      ((failed++))
      failed_names+=("$local_name")
    fi
  done

  # 输出报告
  echo ""
  log_header "更新报告"
  log_info "总计: ${#SKILLS[@]}  成功: ${GREEN}${success}${NC}  失败: ${RED}${failed}${NC}"

  if [[ ${#failed_names[@]} -gt 0 ]]; then
    log_error "失败的 Skill: ${failed_names[*]}"
  fi

  if [[ "$DRY_RUN" == false && $success -gt 0 ]]; then
    echo ""
    log_info "提示: 运行 ${YELLOW}cd $SCRIPT_DIR && git diff --stat${NC} 查看变更详情"
  fi

  [[ $failed -eq 0 ]]
}

main "$@"
