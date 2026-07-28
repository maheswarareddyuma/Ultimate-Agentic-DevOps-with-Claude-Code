---
name: feedback-oidc-scoping
description: Scope GitHub OIDC trust policy sub condition to the exact CI trigger, not a repo-wide wildcard
metadata:
  type: feedback
---

When writing an `aws_iam_role` trust policy for GitHub Actions OIDC
(`token.actions.githubusercontent.com`), scope the `StringLike` condition on
`token.actions.githubusercontent.com:sub` to the *specific ref* the CI
workflow actually triggers on (e.g.
`repo:OWNER/REPO:ref:refs/heads/main`), not the looser
`repo:OWNER/REPO:*` wildcard.

**Why:** explicitly requested tightest reasonable scope — the role should
only be assumable by the exact workflow trigger (push to main), not any
branch/tag/PR from the repo, even though the OIDC provider itself isn't
branch-restricted.

**How to apply:** before writing a GitHub Actions trust policy, check what
event(s)/branch(es) the actual workflow in `.github/workflows/` triggers on
and match the `sub` condition to that. If the workflow later adds triggers
(e.g. PR previews), the sub condition needs a matching second value or a
broader pattern — don't widen it preemptively.

Also relevant: this project has no local Terraform execution tool available
to the `tf-writer` agent (no Bash) — only Read/Write/Edit/Glob/Grep and the
Terraform registry MCP tools (version/module/provider lookups, not
init/validate/plan). `terraform fmt`/`validate` must be run by the
orchestrator or user, not by tf-writer itself.
