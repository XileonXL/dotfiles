---
name: pre-commit-check
description: Use this skill when the user wants to run linters and static analysis on their code before committing or merging. Trigger phrases: "run the checks", "lint this", "check my code", "pre-commit", "run linters", "validate everything", "is this ready to commit".
version: 1.0.0
---

# Pre-Commit Check Skill

Runs static analysis and linting tools relevant to the current codebase and consolidates results into a single actionable report.

## When This Skill Applies

- User wants to validate code before committing or opening a PR
- User wants a quick quality check across their current changes
- User asks to run linters without specifying which ones

## Process

### 1. Detect relevant tools
Scan the working directory to determine which tools apply:

| Files present | Tool to run |
|---|---|
| `*.tf`, `*.tfvars` | `tflint` |
| `Chart.yaml`, `templates/` | `helm lint` |
| `*.sh`, `*.bash` | `shellcheck` |
| `.pre-commit-config.yaml` | `pre-commit run --all-files` |
| `*.py` | `ruff check` |
| `*.yaml`, `*.yml` | `yamllint` (if config present) |

### 2. Run tools in parallel
Execute all applicable tools simultaneously. Capture stdout and stderr for each.

### 3. Consolidated report

```
## Pre-Commit Check Results

### tflint
✓ No issues  /  ✗ N issues found
[issues if any]

### helm lint
✓ No issues  /  ✗ N issues found
[issues if any]

### shellcheck
✓ No issues  /  ✗ N issues found
[issues if any]

### pre-commit
✓ All hooks passed  /  ✗ N hooks failed
[failures if any]

---
### Summary
- Blocking issues: N  ← must fix before commit
- Warnings: N
- Clean tools: [list]
```

### 4. Fix or delegate
- For fixable issues (tflint auto-fix, `terraform fmt`, `ruff --fix`): ask user before auto-fixing
- For complex issues: delegate to the relevant specialized agent with the specific error

## Rules

- Run only read/lint commands — never `terraform apply`, `helm upgrade`, or any mutating command
- If `pre-commit` is configured, prefer running it over individual tools (it already orchestrates them)
- Always show the raw tool output for any failure so the user can see the exact error
- If no applicable tools are found, tell the user which tools are missing and how to install them
