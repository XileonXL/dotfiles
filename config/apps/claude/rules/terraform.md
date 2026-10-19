---
description: Terraform, OpenTofu and Terragrunt rules
paths:
  - "**/*.tf"
  - "**/*.tfvars"
  - "**/*.hcl"
---

# Terraform / OpenTofu / Terragrunt Rules

## Applies To
Files: `*.tf`, `*.tfvars`, `*.hcl`, `terragrunt.hcl`

## Naming Conventions

- All resource names, variable names, output names, and locals: `snake_case`
- Module names in `source`: lowercase, hyphenated (`my-module`)
- Workspace names: `<env>` (e.g. `prod`, `staging`, `dev`)
- AWS resource name tags and Terraform identifiers must match: if the resource is `aws_s3_bucket.audit_logs`, the Name tag is `audit-logs`
- Cloud resource names never repeat the resource type: an RDS cluster is always a database, so it is `<project>-<env>`, not `<project>-<env>-database`. Add a suffix only to tell apart resources of the same type, and make it the purpose or the thing it serves (`-documents`, `-tfstate`, `-database` for the security group of the database), never the type (`-bucket`, `-sg`, `-cluster`, `-queue`) nor the technology behind it (`-aurora`, `-postgres`), which can change while the purpose stays
- Never put the AWS account ID in a resource name (bucket names included). For globally unique names, pick a distinctive name and choose another if it is taken
- Descriptions are short and stable: say what the resource belongs to, not how it behaves (`Aurora bidsenseai-pro`, not `Aurora cluster: no ingress, access only via the Data API`). Many descriptions are immutable (security groups, subnet groups) and a detailed one forces a replacement every time the behavior changes

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

- Remote state only: S3 with native locking (`use_lockfile = true`). No DynamoDB lock table
- One state bucket per project; each environment uses its own key in it (`<env>/terraform.tfstate`). Never share a state file between envs
- Never edit state manually; use `terraform state mv` if needed and document why

## Tagging (AWS)

Tags that are identical across every resource in a state go in `default_tags` on the
provider, not in each resource:

```hcl
provider "aws" {
  region = var.aws_zone

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.aws_environment
    }
  }
}
```

Per-resource tags carry only what varies:
```hcl
tags = {
  Name    = "<resource-identifier>"
  Project = "<project>"
}
```

Required on every taggable resource, whether through `default_tags` or directly:
- `Environment`
- `Project`
- `ManagedBy = "Terraform"`

`Name` only on resources without a name of their own, where the console shows the tag as
the display name: VPCs, subnets, route tables, EBS volumes, EC2 instances. Never on
resources that already have a name attribute (security groups, S3 buckets, RDS clusters,
Lambda functions, SQS queues, IAM roles): the tag would duplicate it and can drift.

`ManagedBy = "Terraform"` with a capital T: it is a product name, and it leaves room for
other values (`CloudFormation`, `Console`) to read consistently. There is no formal AWS or
HashiCorp standard here; this is convention.

**Never write `Terraform = "true"`.** It states the same thing as a boolean under a key
that cannot express anything else.

**Tagging is per provider, not universal.** Datadog tags are a flat `key:value` list in
lowercase (`managed-by:terraform`, `environment:pro`) and the Datadog provider has no
`default_tags`. Do not carry the AWS spelling across.

Datadog documents which characters are legal in a tag but does not prescribe `-` over `_`.
Pick one and keep it: renaming a tag breaks every monitor, dashboard and saved search that
filters on it.

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
