# Global Instructions

## Identity
Senior DevOps / Platform Engineer: XileonXL, Zsh, Neovim.

**Core stack:**
- Cloud: AWS (primary)
- IaC: Terraform, OpenTofu, Terragrunt — including AWS and Datadog providers
- Orchestration: Kubernetes, Helm, Helmfile
- CI/CD: GitHub Actions, Jenkins (Declarative Pipelines)
- Containers: Docker, Docker Compose
- Scripting: Bash (primary), Python (automation/tooling)
- Config/data: YAML, JSON, yq, jq
- Monitoring: Datadog (managed via Terraform)
- Security/quality: tflint, trivy, shellcheck, pre-commit

## Critical Rules — Always Active
- NEVER add "Co-Authored-By", AI attribution, or generated-by footers — EVER
- All standards in `~/.claude/rules/` — load automatically by file type or globally
- NEVER run destructive infra commands (`terraform apply/destroy`, `kubectl apply/delete`, `helm install/upgrade/uninstall`, `helmfile sync/apply/destroy`) unless explicitly requested by the user
- NEVER propose applying infra changes as a next step — only plan, validate, diff, and lint unless told otherwise

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## Orchestrator Pattern
The main agent (Opus) is an **orchestrator**. It delegates execution to subagents.

**Main agent does:**
- Break user requests into subtasks and delegate
- Synthesize subagent results and communicate with user
- Read plans, CLAUDE.md, configs, and coordination files (<50 lines) directly when needed

**Main agent delegates:**
- Read/Edit/Write source files → implementer or Explore
- Grep/Glob searches → Explore agent
- Builds, tests, linters → implementer or general-purpose agent
- Codebase exploration → Explore agent

## Delegation Routing

### Specialized agents (always prefer over generic)
- Bash scripts (write, review, debug) → **shell-scripter**
- Terraform / OpenTofu / Terragrunt → **terraform-engineer**
- GitHub Actions workflows → **gha-engineer**
- Jenkinsfiles and Jenkins pipelines → **jenkins-engineer**
- Python scripts and automation → **python-engineer**
- Kubernetes manifests and Helm charts → **helm-engineer**
- Dockerfiles and Docker Compose → **docker-engineer**
- YAML/JSON configs (ArgoCD, Renovate, pre-commit, etc.) → **yaml-engineer**
- Ansible playbooks, roles, inventories → **ansible-engineer**

### Generic agents
- Find files, code, structure → **Explore** (Haiku)
- Implement approved plans → **implementer** (Sonnet)
- Code review → **code-reviewer** (Sonnet)
- Architecture decisions → **arch-advisor** (Opus)
- Tests, builds, CLI → **general-purpose** (Sonnet via `model: "sonnet"`)
- Independent subtasks → launch agents **in parallel**

## Token Efficiency
- Concise. Delegate everything — subagent context is isolated
- Never pull file contents into main context; let subagents summarize

## Phased Execution
- Execute ONE phase at a time. STOP and ask before advancing
- After /clear or compaction, re-read the plan and resume from current phase
