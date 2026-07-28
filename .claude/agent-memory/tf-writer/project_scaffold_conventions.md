---
name: project-scaffold-conventions
description: Defaults and exact resource choices used when scaffolding terraform/ for the portfolio-site S3+CloudFront stack
metadata:
  type: project
---

Initial `terraform/` scaffold (5 files: providers.tf, variables.tf, backend.tf, outputs.tf, main.tf) was generated 2026-07-28 with these fixed choices:

- Defaults: `region = ap-south-1`, `project_name = portfolio-site`, `environment = production`, `domain_name = ""`.
- AWS provider pinned `~> 6.56` (was latest per registry at time of writing — re-check via `get_latest_provider_version` before bumping).
- S3 bucket name is `${var.project_name}-${data.aws_caller_identity.current.account_id}` for global-uniqueness without a `random_id` resource.
- CloudFront uses `aws_cloudfront_origin_access_control` (OAC), never legacy OAI. Bucket policy uses `AWS:SourceArn` condition pinned to the distribution ARN.
- Default cache behavior uses the AWS-managed **CachingOptimized** policy by its fixed ID `658327ea-f89d-4fab-a63d-7e88639e58f6` — no inline `forwarded_values`/TTL blocks. If a different managed policy is ever needed, look it up (managed cache policy IDs are stable/well-known, not account-specific).
- No `aws_s3_bucket_versioning` on the site bucket — was deliberately left out per the scaffold spec ("no speculative resources beyond what's listed"); versioning is only mentioned for the *state* bucket in `backend.tf`'s bootstrap comments, not created as a resource (state bucket/DynamoDB table are expected to be created manually or by a separate bootstrap step, phase 1 of the two-phase backend migration).
- `backend.tf` ships fully commented out with a two-phase bootstrap explanation: init locally first, apply to create state bucket + DynamoDB lock table, then uncomment and `terraform init -migrate-state`.

**Why:** User gave an exact, itemized file-by-file spec for this stack — treat future `/scaffold-terraform` runs on this repo as reusing these exact conventions unless the user overrides region/project_name/provider version.
**How to apply:** When regenerating or extending `terraform/` in this repo, match these exact resource names/IDs so diffs stay minimal; don't add versioning, OAI, inline cache TTLs, or extra bootstrap resources unless explicitly asked.
