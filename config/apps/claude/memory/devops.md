# DevOps Context

## AWS
- Single AWS account (company)
- No multi-account setup

## Terraform
- Backend: S3 + DynamoDB locking
- Repo structure: monorepo
- Environments: `dev`, `pro` (and `pre` coming soon)

## Kubernetes
- Not in use currently — planned for the future
- When adopted: likely EKS given AWS context

## Environments
- Current: `dev`, `pro`
- Upcoming: `pre`
- Order: dev → pre → pro
