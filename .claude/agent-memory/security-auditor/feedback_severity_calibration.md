---
name: feedback-severity-calibration
description: How to calibrate finding severity for this hobby portfolio-site stack
metadata:
  type: feedback
---

Don't inflate severity for gaps that don't matter given the actual stakes of this project (static HTML/CSS portfolio, no PII, no auth, no dynamic backend).

**Why:** User explicitly said (2026-07-28 audit) "this is a small hobby portfolio site, so weigh severity accordingly — don't inflate low-stakes gaps (like missing WAF on a static site with no PII) to critical."

**How to apply:**
- Missing WAF on CloudFront: not a finding worth flagging above LOW/informational for this stack.
- Missing S3/CloudFront access logging: LOW at most — nice-to-have, not a gap that matters without PII or auth.
- Missing S3 versioning: LOW — only matters here for deploy-rollback convenience, not data-loss/compliance.
- Reserve HIGH/CRITICAL for things with real blast radius: local unencrypted state with no `.gitignore` (real risk of state file leaking account ID/ARNs into git), missing security response headers (CSP/X-Frame-Options — explicitly on the checklist), broad IAM/bucket policy scope, hardcoded secrets.
- Always weigh severity against "what's the actual asset at risk" not just "does this deviate from a general AWS best-practice checklist."

See [[project-portfolio-stack-baseline]] for what this specific stack already gets right.
