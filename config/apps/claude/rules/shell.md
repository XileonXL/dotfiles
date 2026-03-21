# Shell / Bash Rules

## Applies To
Files: `*.sh`, `*.bash`, scripts without extension identified as shell

## Shebang and Strict Mode

Every Bash script must start with:
```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `set -e` — exit on error
- `set -u` — exit on undefined variable
- `set -o pipefail` — pipe failures propagate
- Never use `#!/bin/bash` — use `env bash` for portability

## ShellCheck

All scripts must pass `shellcheck` with zero warnings. If a false positive is unavoidable, suppress with an inline directive and a comment explaining why:
```bash
# shellcheck disable=SC2034  # VAR is used by sourcing script
```

## Quoting

Always double-quote variables and command substitutions:
```bash
# Bad
cp $src $dst
echo ${var}

# Good
cp "${src}" "${dst}"
echo "${var}"
```

Exceptions: inside `[[ ]]` where word splitting doesn't apply, or intentional glob expansion.

## Script Structure

Every non-trivial script follows this layout:
```bash
#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${0}")"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} [OPTIONS]

Description of the script.

Options:
  -h, --help      Show this help
  -n, --dry-run   Dry run, no changes
EOF
}

main() {
  # argument parsing, logic
}

main "$@"
```

## Variables

- Constants: `readonly VAR_NAME` or `declare -r VAR_NAME`
- Function-scoped variables: always `local`
- Globals: uppercase snake_case (`MY_GLOBAL`)
- Locals: lowercase snake_case (`my_local`)

## Error Handling

- Check exit codes of critical commands
- Log errors to stderr: `echo "[ERROR] message" >&2`
- Provide context: what failed and why, not just that it failed
- Use `trap` for cleanup:
```bash
trap 'cleanup' EXIT ERR INT TERM

cleanup() {
  # remove temp files, release locks, etc.
}
```

## Command Usage

```bash
# Prefer [[ ]] over [ ]
[[ -f "${file}" ]] && ...

# Prefer $() over backticks
result=$(some_command)

# Prefer printf over echo for predictability
printf '%s\n' "${var}"

# Use mktemp for temp files
tmp=$(mktemp)

# Check required commands at startup
command -v terraform &>/dev/null || { echo "[ERROR] terraform not found" >&2; exit 1; }

# Use read -r
while IFS= read -r line; do ...

# Never parse ls
for f in /path/*; do ...
```

## Functions

- One function = one responsibility
- Declare before use (or use `main` pattern)
- Return meaningful exit codes; use `return 0` / `return 1` explicitly in functions

## Logging

Use consistent log levels:
```bash
log_info()  { printf '[INFO]  %s\n' "$*"; }
log_warn()  { printf '[WARN]  %s\n' "$*" >&2; }
log_error() { printf '[ERROR] %s\n' "$*" >&2; }
```

## What Claude Must Never Do

- Never use `set +e` to silence errors without a comment and a corresponding `set -e` to restore
- Never use `eval` with user-supplied input
- Never use `rm -rf` without first validating the variable is non-empty:
```bash
[[ -n "${tmp_dir}" ]] && rm -rf "${tmp_dir}"
```
