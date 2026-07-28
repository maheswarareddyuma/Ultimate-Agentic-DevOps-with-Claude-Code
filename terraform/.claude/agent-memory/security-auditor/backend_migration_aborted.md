---
name: backend-migration-aborted
description: S3+DynamoDB backend migration was attempted then reverted on 2026-07-28 — backend.tf is intentionally back to the phase-1 (fully commented) template, state is local-only
metadata:
  type: project
---

An S3 backend + DynamoDB lock table migration was briefly attempted for this project
(uncommenting `backend.tf`, running `terraform init -migrate-state`), then reverted at
the user's request on 2026-07-28. The temporary state bucket and lock table created in
AWS were deleted. `backend.tf` was manually recreated from memory during the revert
(it briefly went missing from disk) and, as of this audit, matches the original
two-phase bootstrap template exactly (fully commented `terraform { backend "s3" {...} }`
block with placeholder bucket/dynamodb_table values). Local state
(`terraform/terraform.tfstate` + `.tfstate.backup`) is the current source of truth, and
no stray `.terraform/terraform.tfstate` backend-cache file or leftover S3-backend
artifacts were found on disk.

**Why:** So a future audit doesn't mistake the commented-out backend.tf for an
unfinished/broken migration, or "fix" it by uncommenting it. Also relevant if the user
later restarts the S3 backend migration — the phase-1/phase-2 comment convention in
backend.tf is the intended workflow, not a mistake to clean up.

**How to apply:** When re-auditing this repo, verify backend.tf is still the fully
commented template (no `terraform.tf` backend block active) unless the user says they
completed the migration. If they mention resuming migration, expect Phase 2 to involve
uncommenting the block, filling in a real bucket/dynamodb_table name, and running
`terraform init -migrate-state`.
