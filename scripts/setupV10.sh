#!/usr/bin/env bash
#
# FrequentlyUsedScripts 一键安装入口  v1.0
#
# 用法:
#   bash <(curl -fsSL https://raw.githubusercontent.com/Gabxb/FrequentlyUsedScripts/master/scripts/setupV10.sh)
#   bash scripts/setupV10.sh
#   bash scripts/setupV10.sh 5
#
# 本文件只负责找到并启动 v1.0 安装器 (install-full-env.sh)。
# 新机引导版: scripts/setupv11.sh
#
set -euo pipefail

RAW_BASE="${RAW_BASE:-https://raw.githubusercontent.com/Gabxb/FrequentlyUsedScripts/master}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="install-full-env.sh"

info() { printf '\033[36m==>\033[0m %s\n' "$1"; }
die()  { printf '\033[31m[错误]\033[0m %s\n' "$1" >&2; exit 1; }

printf '\nFrequentlyUsedScripts 一键安装  v1.0\n'
printf '新机引导请用 v1.1:  bash <(curl -fsSL %s/scripts/setupv11.sh)\n\n' "$RAW_BASE"

if [[ -f "$SCRIPT_DIR/$TARGET" ]]; then
    info "使用本地 $SCRIPT_DIR/$TARGET"
    exec bash "$SCRIPT_DIR/$TARGET" "$@"
fi

if [[ -f /workspace/scripts/$TARGET ]]; then
    info "使用 /workspace/scripts/$TARGET"
    exec bash "/workspace/scripts/$TARGET" "$@"
fi

command -v curl >/dev/null 2>&1 || die "缺少 curl,请先安装: apt-get install -y curl"
tmp="$(mktemp)"
info "本机没有 $TARGET,从 GitHub raw 下载"
curl -fsSL --retry 3 --max-time 120 -o "$tmp" "$RAW_BASE/scripts/$TARGET" \
    || die "下载失败: $RAW_BASE/scripts/$TARGET"
head -c 2 "$tmp" | grep -q '#!' || die "下载内容不是脚本,已中止"
bash "$tmp" "$@"
rc=$?
rm -f "$tmp"
exit "$rc"
