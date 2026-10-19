#!/usr/bin/env bash
set -uo pipefail

# Catppuccin Mocha palette
readonly BLUE='\e[38;2;137;180;250m'
readonly GREEN='\e[38;2;166;227;161m'
readonly YELLOW='\e[38;2;249;226;175m'
readonly RED='\e[38;2;243;139;168m'
readonly MAUVE='\e[38;2;203;166;247m'
readonly TEXT='\e[38;2;205;214;244m'
readonly SUB='\e[38;2;166;173;200m'
readonly RST='\e[0m'

SEP="${SUB} · ${RST}"

# Read JSON from stdin
json=$(cat)

# Extract all fields in one jq call (nested under cost.* and context_window.*)
IFS=$'\t' read -r model ctx_pct ctx_used ctx_total duration_ms lines_added lines_removed cost_usd rl5_pct rl5_reset rl7_pct rl7_reset cwd worktree_name agent_name < <(
  echo "$json" | jq -r '[
    (.model.display_name // "Unknown"),
    (.context_window.used_percentage // 0 | round),
    (.context_window.current_usage | if . then (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0) else 0 end),
    (.context_window.context_window_size // 200000),
    (.cost.total_duration_ms // 0),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0),
    (.cost.total_cost_usd // 0),
    (.rate_limits.five_hour.used_percentage | if . == null then "-" else round end),
    (.rate_limits.five_hour.resets_at // "-"),
    (.rate_limits.seven_day.used_percentage | if . == null then "-" else round end),
    (.rate_limits.seven_day.resets_at // "-"),
    (.cwd // "-"),
    (.worktree.name // "-"),
    (.agent.name // "-")
  ] | @tsv' 2>/dev/null
)

# Fallbacks
model=${model:-Unknown}
ctx_pct=${ctx_pct:-0}
ctx_used=${ctx_used:-0}
ctx_total=${ctx_total:-200000}
duration_ms=${duration_ms:-0}
lines_added=${lines_added:-0}
lines_removed=${lines_removed:-0}
cost_usd=${cost_usd:-0}
# "-" is a placeholder: read with a tab IFS would collapse empty fields
[[ "${rl5_pct:--}" == "-" ]] && rl5_pct=""
[[ "${rl5_reset:--}" == "-" ]] && rl5_reset=""
[[ "${rl7_pct:--}" == "-" ]] && rl7_pct=""
[[ "${rl7_reset:--}" == "-" ]] && rl7_reset=""
[[ "${cwd:--}" == "-" ]] && cwd=$PWD
[[ "${worktree_name:--}" == "-" ]] && worktree_name=""
[[ "${agent_name:--}" == "-" ]] && agent_name=""

# Directory name
dir=$(basename "$cwd")

# Duration: Xm Ys (only when >0)
total_secs=$((duration_ms / 1000))
mins=$((total_secs / 60))
secs=$((total_secs % 60))

# Tokens in thousands
ctx_used_k=$((ctx_used / 1000))
ctx_total_k=$((ctx_total / 1000))

# Color for a percentage: green <50, yellow <75, red otherwise
pct_color() {
  if (($1 < 50)); then
    printf '%s' "$GREEN"
  elif (($1 < 75)); then
    printf '%s' "$YELLOW"
  else
    printf '%s' "$RED"
  fi
}

# Seconds -> XhYm (or Ym when <1h)
fmt_hm() {
  local s=$1
  if ((s >= 3600)); then
    printf '%dh%dm' $((s / 3600)) $((s % 3600 / 60))
  else
    printf '%dm' $((s / 60))
  fi
}

# Context bar color
bar_color=$(pct_color "$ctx_pct")

# Progress bar (10 chars)
filled=$((ctx_pct / 10))
empty=$((10 - filled))
bar="${bar_color}"
for ((i = 0; i < filled; i++)); do bar+="▓"; done
for ((i = 0; i < empty; i++)); do bar+="░"; done
bar+="${RST}"

# Git info with 5s cache
git_info=""
if [[ -d "$cwd/.git" ]] || git -C "$cwd" rev-parse --git-dir &>/dev/null; then
  cache_key=$(echo "$cwd" | cksum | cut -d' ' -f1)
  cache_file="/tmp/claude-statusline-git-${cache_key}"
  now=$(date +%s)

  if [[ -f "$cache_file" ]] && ((now - $(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0) < 5)); then
    git_info=$(cat "$cache_file")
  else
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null || echo "")
    if [[ -n "$branch" ]]; then
      staged=$(git -C "$cwd" diff --cached --numstat 2>/dev/null | wc -l)
      modified=$(git -C "$cwd" diff --numstat 2>/dev/null | wc -l)
      staged=${staged// /}
      modified=${modified// /}

      git_info="${MAUVE} ${branch}${RST}"
      ((staged > 0)) && git_info+=" ${GREEN}+${staged}${RST}"
      ((modified > 0)) && git_info+=" ${YELLOW}~${modified}${RST}"
    fi
    echo "$git_info" >"$cache_file"
  fi
fi

# Build single line — only show elements with actual data
out="${BLUE} ${model}${RST}"
out+="${SEP}${TEXT} ${dir}${RST}"
[[ -n "$worktree_name" ]] && out+="${SEP}${MAUVE} ${worktree_name}${RST}"
[[ -n "$agent_name" ]] && out+="${SEP}${BLUE} ${agent_name}${RST}"
[[ -n "$git_info" ]] && out+="${SEP}${git_info}"

# Context: only show bar + percentage when >0%
if ((ctx_pct > 0)); then
  out+="${SEP}${bar} ${bar_color}${ctx_pct}%${RST} ${SUB}${ctx_used_k}k/${ctx_total_k}k${RST}"
fi

# Rate limits: only show windows that have data
rl_parts=""
now=$(date +%s)
if [[ -n "$rl5_pct" ]]; then
  rl_parts+="${SUB}5h ${RST}$(pct_color "$rl5_pct")${rl5_pct}%${RST}"
  if [[ "$rl5_reset" =~ ^[0-9]+$ ]] && ((rl5_reset - now > 0)); then
    rl_parts+=" ${SUB}($(fmt_hm $((rl5_reset - now))))${RST}"
  fi
fi
if [[ -n "$rl7_pct" ]]; then
  [[ -n "$rl_parts" ]] && rl_parts+="${SEP}"
  rl_parts+="${SUB}7d ${RST}$(pct_color "$rl7_pct")${rl7_pct}%${RST}"
  if [[ "$rl7_reset" =~ ^[0-9]+$ ]] && ((rl7_reset - now > 0)); then
    left=$((rl7_reset - now))
    if ((left >= 86400)); then
      rl_parts+=" ${SUB}($((left / 86400))d)${RST}"
    else
      rl_parts+=" ${SUB}($(fmt_hm "$left"))${RST}"
    fi
  fi
fi
[[ -n "$rl_parts" ]] && out+="${SEP}${rl_parts}"

# Lines changed: only when >0
if ((lines_added > 0 || lines_removed > 0)); then
  changes=""
  ((lines_added > 0)) && changes+="${GREEN}+${lines_added}${RST}"
  ((lines_added > 0 && lines_removed > 0)) && changes+="/"
  ((lines_removed > 0)) && changes+="${RED}-${lines_removed}${RST}"
  out+="${SEP}${changes}"
fi

# Duration: only when >0s
if ((total_secs > 0)); then
  out+="${SEP}${SUB}${mins}m ${secs}s${RST}"
fi

# Cost USD
if [[ "$cost_usd" != "0" ]]; then
  out+="${SEP}${YELLOW}\$${cost_usd}${RST}"
fi

printf '%b' "$out"
