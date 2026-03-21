# Terraform / OpenTofu / Terragrunt Rules

## Applies To
Files: `*.tf`, `*.tfvars`, `*.hcl`, `terragrunt.hcl`

## Naming Conventions

- All resource names, variable names, output names, and locals: `snake_case`
- Module names in `source`: lowercase, hyphenated (`my-module`)
- Workspace names: `<env>` (e.g. `prod`, `staging`, `dev`)
- AWS resource name tags and Terraform identifiers must match: if the resource is `aws_s3_bucket.audit_logs`, the Name tag is `audit-logs`

## Module Structure

Every module must have:
```
module/
├── main.tf
├── variables.tf   # All inputs with type, description, validation where useful
├── outputs.tf     # All outputs with description
└── versions.tf    # terraform{} block + required_providers with version constraints
```

Root (live) infrastructure:
```
infra/
├── envs/
│   ├── prod/
│   ├── staging/
│   └── dev/
└── modules/
```

## Version Pinning

Always pin providers with `~>` (minor-level):
```hcl
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}
```

## Variables

Every variable must have `description` and explicit `type`. No `any`. Sensitive variables get `sensitive = true` and no `default`:
```hcl
variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
```

## Outputs

Every output must have `description`. Mark sensitive outputs with `sensitive = true`.

## State

- Remote state only: S3 + DynamoDB locking
- State bucket per environment; never share state between envs
- Never edit state manually; use `terraform state mv` if needed and document why

## Tagging (AWS)

All taggable AWS resources must include:
```hcl
tags = merge(var.common_tags, {
  Name = "<resource-identifier>"
})
```

`common_tags` must include at minimum:
- `Environment`
- `Project`
- `ManagedBy = "terraform"`
- `Owner`

## Security

- No hardcoded credentials, account IDs, or ARNs that should be variables
- IAM policies: least privilege; no `*` actions or resources without explicit justification in a comment
- S3 buckets: block public access by default, versioning enabled, encryption enabled
- Security groups: no `0.0.0.0/0` ingress except ports 80/443 on ALBs
- KMS: use customer-managed keys for sensitive data

## Datadog (via Terraform)

- All Datadog monitors, dashboards, and SLOs must be managed in Terraform — no manual creation in the UI
- Monitor names: `[<env>] <service> - <what is being monitored>`
- Always set `notify_no_data = true` and a reasonable `no_data_timeframe` on monitors
- Group monitors with `tags` matching the service and environment

## Lifecycle

- `prevent_destroy = true` on stateful resources: RDS, S3 buckets, KMS keys, EKS clusters
- `create_before_destroy = true` for zero-downtime replacements (ASGs, security groups)
- `ignore_changes` only with a comment explaining why

## What Claude Must Never Do

- Never run `terraform apply`, `destroy`, `import`, `force-unlock`, or `taint` without explicit user instruction
- Never propose apply as a next step after plan — present the plan output and wait
- Never modify `.tfstate` files directly
