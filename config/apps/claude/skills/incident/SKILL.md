---
name: incident
description: Use this skill when the user is debugging a production issue, investigating an outage, troubleshooting a failing deployment, or diagnosing unexpected infrastructure behavior. Trigger phrases: "something is down", "this is failing", "what's wrong", "help me debug", "we have an incident", "pipeline is broken", "pod is crashing", "terraform is erroring", "alarm is firing".
version: 1.0.0
---

# Incident Skill

Structured debugging framework for infrastructure and platform incidents. Focuses on diagnosis and remediation steps — never executes mutating commands autonomously.

## When This Skill Applies

- Production or staging outage or degradation
- Failing CI/CD pipeline
- Crashing or unhealthy Kubernetes workloads
- Terraform plan/apply errors
- Unexpected AWS resource behavior
- Datadog alert investigation

## Process

### 1. Establish context (ask if not provided)
- What is the symptom? (error message, alarm name, behavior observed)
- When did it start?
- What changed recently? (deploy, config change, infra change, dependency update)
- What environment? (prod/staging/dev)
- What is the blast radius? (one service, one region, full platform)

### 2. Structured diagnosis

Present findings in this order:

```
## Incident Analysis

### Symptom
[What is failing and how it manifests]

### Most Likely Causes
1. [Highest probability cause] — reasoning
2. [Second candidate] — reasoning
3. [Other candidate] — reasoning

### Evidence to Collect
- [Specific log query, metric, or command to run to confirm/rule out each cause]
  Example: `kubectl logs -n <ns> <pod> --previous`
  Example: `terraform state show <resource>`

### Remediation Steps
For each confirmed cause, provide ordered steps:
1. [Step] — impact: [what this changes]
2. [Step] — impact: [what this changes]

### Prevention
- [What to add/change to prevent recurrence]
```

### 3. Domain routing
If deeper investigation is needed, delegate to the appropriate agent:
- Terraform state/config issues → **terraform-engineer**
- K8s / Helm issues → **helm-engineer**
- GHA pipeline failures → **gha-engineer**
- Shell script failures → **shell-scripter**

## Rules

- NEVER suggest running `kubectl delete`, `terraform apply`, `helm rollback`, or any mutating command without explicit user request
- Always present `Evidence to Collect` before `Remediation Steps` — confirm the cause before acting
- If the user is under time pressure, lead with the single most likely cause and its remediation, then show the full analysis
- For Datadog alerts: ask for the monitor name/ID, the triggering query, and the affected service before diagnosing
- For AWS issues: ask for the region, service, and any relevant resource IDs or CloudTrail events
