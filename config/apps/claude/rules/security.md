# Security Rules

## Applies To
All files and contexts — these rules are always active regardless of language or domain.

## Secrets and Credentials

- **Never hardcode** secrets, tokens, passwords, API keys, or account identifiers in any file
- **Never log** secrets — not in echo, printf, terraform output, kubectl logs, or CI step output
- **Never store** secrets in environment variable defaults in Dockerfiles (`ENV TOKEN=abc`)
- Secrets must come from: AWS Secrets Manager, SSM Parameter Store, GitHub Actions secrets, or a secrets manager — never from the repo
- If a secret is accidentally committed: flag it immediately, do not try to fix it silently with a follow-up commit

## AWS

- IAM: least privilege always — specific actions, specific resources, specific conditions
- No `*` in IAM `Action` or `Resource` without a comment justifying the exception
- No long-lived IAM access keys — prefer OIDC/IAM roles (for GHA, EKS workloads, EC2 instances)
- S3: block public access, enforce SSL (`aws:SecureTransport`), enable versioning and encryption
- Security groups: no `0.0.0.0/0` ingress except HTTP/HTTPS on load balancers
- CloudTrail: must be enabled in all accounts/regions; never disable
- Root account: MFA required, no programmatic access keys

## Terraform

- No credentials in `terraform.tfvars` or any file that could be committed
- Provider credentials via environment variables or IAM role assumption — never hardcoded in provider block
- `sensitive = true` on all variables and outputs that contain secrets
- See `terraform.md` for full Terraform security rules

## Containers / Docker

- Never pass secrets as `ARG` or `ENV` in Dockerfiles — use BuildKit secret mounts
- Run as non-root user always
- No secrets in image layers (they persist even after `RUN rm`)
- Base images pinned to digest or specific version tag — never `latest`

## Kubernetes / Helm

- No secrets in `values.yaml` or `ConfigMap` — use `Secret` resources or External Secrets Operator
- `Secret` resources must not be committed to git in plaintext — use Sealed Secrets or ESO
- RBAC: ServiceAccounts scoped to namespace with minimum required permissions
- No `cluster-admin` bindings except for system components
- Pod security: `runAsNonRoot: true`, `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`

## GitHub Actions

- No secrets in `run:` steps via `${{ secrets.X }}` — assign to `env:` first
- Pin all third-party actions to a commit SHA
- `GITHUB_TOKEN` permissions: set to minimum required at job level
- Never use `pull_request_target` with checkout of untrusted code

## Shell Scripts

- Never use `eval` with external or user-supplied input
- Validate and sanitize all inputs before passing to commands
- Never construct command strings with unquoted variables
- See `shell.md` for full shell security rules

## Code Review Checklist (security)

When reviewing any code, always check:
1. Are there any hardcoded secrets, tokens, or credentials?
2. Is any sensitive data logged or printed?
3. Is user/external input validated before use?
4. Are IAM permissions at minimum required scope?
5. Are there any public exposure points that should be private?
6. Are dependencies/images pinned to known versions?
