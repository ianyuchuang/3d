#!/bin/sh
# 掃描 3d/ 底下的 .html，產生 models.json（UTF-8 無 BOM）
# 由 .git/hooks/pre-commit 自動呼叫，也可手動執行：sh tools/gen-models.sh
set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

DIR=3d
OUT=models.json
TMP=".models.json.tmp"

esc() {
  # JSON 字串跳脫：反斜線、雙引號、tab
  sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/ /g'
}

pick() {
  # pick <file> <tag>：取第一個 <tag ...>內容 的純文字
  grep -o "<$2[^>]*>[^<]*" "$1" 2>/dev/null | head -1 | sed "s/^<$2[^>]*>//" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

count=0
{
  printf '{\n'
  printf '  "generated": "%s",\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf '  "models": [\n'
  first=1
  for f in "$DIR"/*.html; do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    title=$(pick "$f" title)
    [ -n "$title" ] || title=$(echo "$base" | sed 's/\.html$//')
    desc=$(pick "$f" h1)
    [ "$desc" = "$title" ] && desc=""
    size=$(wc -c < "$f" | tr -d ' ')
    mtime=$(date -u -r "$f" +%Y-%m-%d 2>/dev/null || echo "")
    [ $first -eq 1 ] || printf ',\n'
    first=0
    printf '    {"file": "%s", "title": "%s", "desc": "%s", "size": %s, "mtime": "%s"}' \
      "$(printf '%s' "$base" | esc)" \
      "$(printf '%s' "$title" | esc)" \
      "$(printf '%s' "$desc" | esc)" \
      "$size" "$mtime"
    count=$((count + 1))
  done
  printf '\n  ]\n}\n'
} > "$TMP"

mv "$TMP" "$OUT"
echo "gen-models: $OUT updated ($(grep -c '"file":' "$OUT") models)"
