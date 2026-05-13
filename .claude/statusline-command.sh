#!/usr/bin/env bash
# Claude Code status line v2 (no jq dependency, ANSI colors)
# 📁 folder | 🌿 branch [dirty] | 🤖 model | 💰 cost | 🟢 context bar

input=$(cat)

# --- ANSI Colors ---
RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
MAGENTA="\033[35m"
BLUE="\033[34m"
DIM="\033[2m"

# --- JSON field extractor (pure bash, no jq) ---
json_get() {
  echo "$input" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -1 | sed 's/.*:.*"\(.*\)"/\1/'
}
json_get_num() {
  echo "$input" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*[0-9.]*" | head -1 | sed 's/.*:[[:space:]]*//'
}

# --- Folder ---
cwd=$(json_get "current_dir")
[ -z "$cwd" ] && cwd=$(json_get "cwd")
folder=""
[ -n "$cwd" ] && folder=$(basename "$cwd")

# --- Git branch + dirty status ---
branch=""
git_info=""
git_dir=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_dir="$cwd"
elif git rev-parse --git-dir > /dev/null 2>&1; then
  git_dir="."
fi

if [ -n "$git_dir" ]; then
  branch=$(git -C "$git_dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$git_dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  # Count dirty files (modified + untracked)
  dirty=$(git -C "$git_dir" --no-optional-locks status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$dirty" -gt 0 ] 2>/dev/null; then
    git_info="${branch} ${YELLOW}*${dirty}${RESET}"
  else
    git_info="${branch} ${GREEN}✓${RESET}"
  fi
fi

# --- Model ---
model=$(json_get "display_name")

# --- Cost ---
cost=$(json_get_num "total_cost_usd")
cost_str=""
if [ -n "$cost" ] && [ "$cost" != "null" ] && [ "$cost" != "0" ]; then
  cost_str=$(printf "\$%.2f" "$cost" 2>/dev/null || echo "\$$cost")
fi

# --- Tokens used ---
tokens_used=$(json_get_num "tokens_used")
tokens_str=""
if [ -n "$tokens_used" ] && [ "$tokens_used" != "null" ] && [ "$tokens_used" != "0" ]; then
  tk=$(echo "$tokens_used" | awk '{printf "%.0fK", $1/1000}')
  tokens_str="$tk"
fi

# --- Context progress bar with traffic light ---
used_pct=$(json_get_num "used_percentage")
bar=""
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  filled=$(echo "$used_pct" | awk '{printf "%d", int($1 / 10 + 0.5)}')
  [ "$filled" -gt 10 ] 2>/dev/null && filled=10
  [ -z "$filled" ] && filled=0
  empty=$((10 - filled))
  pct_int=$(printf "%.0f" "$used_pct" 2>/dev/null || echo "0")

  # Traffic light color
  if [ "$pct_int" -lt 50 ]; then
    light="🟢"; bar_color="$GREEN"
  elif [ "$pct_int" -lt 70 ]; then
    light="🟡"; bar_color="$YELLOW"
  elif [ "$pct_int" -lt 85 ]; then
    light="🟠"; bar_color="$YELLOW"
  else
    light="🔴"; bar_color="$RED"
  fi

  bar_filled=""
  i=0; while [ "$i" -lt "$filled" ]; do bar_filled="${bar_filled}█"; i=$((i+1)); done
  bar_empty=""
  i=0; while [ "$i" -lt "$empty" ];  do bar_empty="${bar_empty}░"; i=$((i+1)); done
  bar="${light} ${bar_color}${bar_filled}${DIM}${bar_empty}${RESET} ${bar_color}${pct_int}%${RESET}"
fi

# --- Assemble ---
parts=()
[ -n "$folder"    ] && parts+=("${CYAN}📁 ${BOLD}${folder}${RESET}")
[ -n "$git_info"  ] && parts+=("${GREEN}🌿 ${git_info}${RESET}")
[ -n "$model"     ] && parts+=("${MAGENTA}🤖 ${model}${RESET}")
[ -n "$cost_str"  ] && parts+=("${BLUE}💰 ${cost_str}${RESET}")
[ -n "$tokens_str" ] && [ -n "$cost_str" ] && parts+=("${DIM}${tokens_str}${RESET}")
[ -n "$bar"       ] && parts+=("$bar")

result=""
for part in "${parts[@]}"; do
  [ -n "$result" ] && result="$result ${DIM}│${RESET} "
  result="$result$part"
done

printf "%b" "$result"
