---
name: infra-review
description: Use this skill when the user asks to review infrastructure code, a PR with infra changes, or wants a comprehensive audit of Terraform, Helm, GitHub Actions, Docker, or YAML files together. Trigger phrases: "review this PR", "review my infra", "audit these changes", "check this before I apply", "what's wrong with this infra".
version: 1.0.0
---

# Infra Review Skill

Performs a comprehensive, multi-domain review of infrastructure code by launching specialized agents in parallel.

## When This Skill Applies

- User shares a PR, branch, or set of files containing infra changes
- User wants a pre-apply review of Terraform, Helm, GHA, Docker, or YAML
- User asks for an audit or sanity check before merging or deploying

## Process

### 1. Identify domains present
Before launching agents, scan which domains are present in the changeset:
- `.tf`, `.tfvars` files → terraform-engineer
- `Chart.yaml`, `templates/`, `values*.yaml` → helm-engineer
- `.github/workflows/*.yml` → gha-engineer
- `Dockerfile`, `docker-compose*.yml` → docker-engineer
- Other `.yaml`/`.json` configs → yaml-engineer

### 2. Launch agents in parallel
Delegate to each relevant specialized agent simultaneously. Each agent receives:
- The files in its domain
- Instruction to return findings structured as: **Critical / Warnings / Suggestions**

### 3. Consolidate results
Synthesize all agent outputs into a single report:

```
## Infra Review Summary

### Critical (must fix before apply/merge)
- [domain] description

### Warnings (should fix)
- [domain] description

### Suggestions (optional improvements)
- [domain] description

### Approved (no issues found)
- [domain] ✓
```

## Rules

- NEVER suggest running `apply`, `deploy`, or any mutating command as a next step
- Always surface security findings first regardless of domain
- If a finding in one domain has cross-domain implications (e.g. a GHA workflow that runs terraform apply without plan review), flag it explicitly
- If no files are provided, ask the user to share the relevant files or git diff
