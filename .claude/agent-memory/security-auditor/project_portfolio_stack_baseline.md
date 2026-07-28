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

Update (2026-07-29 audit): a root `.gitignore` now exists and covers `terraform/.terraform/`, `terraform/*.tfstate`, `terraform/*.tfstate.backup`, `*.tfplan` — the "state file can leak into git" risk is resolved, downgrade that finding to LOW/informational. `backend.tf` still ships with the S3 backend block fully commented out as the intentional "phase 1/phase 2" bootstrap (see comment header) — state is still local and unencrypted/unlocked, but no longer git-exposed, so this is now just a LOW nice-to-have (migrate when convenient), not a HIGH. Still consistently missing every audit: a CloudFront response-headers policy for CSP/X-Frame-Options/HSTS (checklist item, never included by default) — this is the main recurring finding now, MEDIUM.

**Why this matters:** security headers is the one real recurring gap worth flagging on every audit of this stack until it's added — everything else about the baseline is already solid, see [[feedback-severity-calibration]].

**How to apply:** On future audits of this same terraform/ directory, check first whether `.gitignore` still covers tfstate and whether `backend.tf`'s S3 block has been uncommented — if backend is migrated too, drop the LOW local-state note entirely. Keep flagging missing CloudFront security headers policy at MEDIUM until `aws_cloudfront_response_headers_policy` is added.
