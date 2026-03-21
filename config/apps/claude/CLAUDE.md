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
