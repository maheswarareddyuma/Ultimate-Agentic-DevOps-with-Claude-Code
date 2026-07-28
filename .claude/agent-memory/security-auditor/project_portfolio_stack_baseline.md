---
name: project-portfolio-stack-baseline
description: Baseline security posture of terraform/ for the portfolio-site stack, and recurring gap pattern from tf-writer's scaffold
metadata:
  type: project
---

As of the 2026-07-28 audit, `terraform/` (main.tf, variables.tf, outputs.tf, providers.tf, backend.tf) for the S3+CloudFront portfolio site in this repo already gets right, consistently, whenever tf-writer scaffolds this stack:
- S3 bucket policy scoped to the CloudFront distribution via `AWS:SourceArn` condition (not the weaker `AWS:SourceAccount` pattern).
- `aws_s3_bucket_public_access_block` with all four flags set true.
- CloudFront uses OAC (`aws_cloudfront_origin_access_control`), not legacy OAI.
- `viewer_protocol_policy = "redirect-to-https"` and `minimum_protocol_version = "TLSv1.2_2021"`.
- `allowed_methods = ["GET", "HEAD"]` only — no unnecessary write methods exposed.
- No hardcoded account IDs/ARNs/secrets in .tf files — account ID pulled via `data.aws_caller_identity.current`.

Recurring gap pattern (seen every time this scaffold is generated): `backend.tf` ships with the S3 backend block fully commented out as an intentional "phase 1/phase 2" bootstrap (see comment header in the file), and the repo has **no `.gitignore`** at all. That combination means local `terraform.tfstate` (containing account ID, bucket/distribution ARNs) sits in the repo working tree with nothing preventing it from being git-added. Also consistently missing: a CloudFront response-headers policy for CSP/X-Frame-Options/HSTS (checklist item, never included by default).

**Why this matters:** these are the two findings worth flagging as HIGH/MEDIUM on every audit of this stack until the user finishes the phase-2 backend migration and adds security headers — everything else about the baseline is already solid, see [[feedback-severity-calibration]].

**How to apply:** On future audits of this same terraform/ directory, check first whether `.gitignore` now exists and whether `backend.tf`'s S3 block has been uncommented — if so, that recurring finding is resolved and shouldn't be repeated.
