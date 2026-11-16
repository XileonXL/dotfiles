#!/usr/bin/env bash
# PostToolUse hook (Edit|Write). Exit 2 sends stderr to the model; stdout on exit 0 never reaches it.
set -uo pipefail

f=$(jq -r '.tool_input.file_path // empty')
[[ -f "$f" ]] || exit 0

case "$f" in
  *.tf | *.tfvars)
    bin=terraform
    if grep -qs 'registry.opentofu.org' "$(dirname "$f")/.terraform.lock.hcl" || ! command -v terraform >/dev/null; then
      bin=tofu
    fi
    if ! out=$("$bin" fmt -no-color "$f" 2>&1); then
      printf '[%s fmt] %s\n' "$bin" "$out" >&2
      exit 2
    fi
    ;;
  *.sh | *.bash)
    if ! out=$(shellcheck --severity=warning "$f" 2>&1); then
      printf '[shellcheck]\n%s\n' "$out" >&2
      exit 2
    fi
    ;;
esac
