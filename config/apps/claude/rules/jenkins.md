# Jenkins Pipeline Rules

## Applies To
Files: `Jenkinsfile`, `Jenkinsfile.*`, `*.jenkinsfile`

## Syntax

- Always Declarative Pipeline; use `script {}` blocks for complex Groovy within declarative
- Never Scripted Pipeline unless Declarative cannot express the requirement — justify in a comment

## Mandatory Options

Every pipeline must include:
```groovy
options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 30, unit: 'MINUTES')
    disableConcurrentBuilds()
    timestamps()
}
```

Adjust `timeout` per pipeline needs, but never omit it.

## Secrets

- Never hardcode credentials, tokens, passwords, or keys in a Jenkinsfile
- Always use `withCredentials` or `credentials()` binding referencing a Jenkins credential ID
- Credential IDs must follow the convention: `<scope>-<service>-<type>` (e.g. `aws-prod-role`, `dockerhub-push-creds`)
- Prefer IAM roles on Jenkins agents over static AWS credentials

## Deployment Gates

- Any stage that mutates infrastructure or deploys to production must be gated:
  - `when { branch 'main' }` minimum
  - `input` step for manual approval before production
- `terraform apply` and `helm upgrade` in pipelines always require an `input` approval step
- Never auto-apply on PR builds — plan only

## Post Block

Always define `post` at the pipeline level with at minimum:
```groovy
post {
    always  { cleanWs() }
    failure { /* notify */ }
}
```

## Stage Structure

- Stages ordered: Checkout → Validate/Lint → Build → Test → Plan → [Approval] → Deploy
- Parallel stages for independent checks (lint, shellcheck, helm lint)
- One logical operation per stage — no mega-stages

## Parameters

- Validate parameter values before using in `sh` steps — never pass raw `params.*` to shell unsanitized
- Deployment parameters (env, tag) must have explicit `description` fields
- Default `DRY_RUN` to `true` for any pipeline that applies changes

## What Claude Must Never Do

- Never write a Jenkinsfile with `terraform apply`, `helm upgrade`, or `kubectl apply` without an `input` approval gate
- Never suggest hardcoding credentials even as placeholders — always use `withCredentials`
- Never omit `timeout` — unbounded pipelines are a reliability risk
