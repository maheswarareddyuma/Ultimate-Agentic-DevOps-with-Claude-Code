---
name: cloudfront-tls-default-cert
description: CloudFront minimum_protocol_version is silently overridden to TLSv1 when cloudfront_default_certificate=true — verify against tfstate/live state, not just main.tf
metadata:
  type: feedback
---

When `viewer_certificate.cloudfront_default_certificate = true` (no custom domain/ACM
cert), AWS ignores whatever `minimum_protocol_version` is declared in the config
(e.g. `TLSv1.2_2021`) and always reports/enforces `TLSv1` on the live distribution.
Confirmed by reading `terraform/terraform.tfstate` for the `portfolio-site` project:
config said `TLSv1.2_2021`, live state showed `"minimum_protocol_version": "TLSv1"`.

**Why:** A code-only review of main.tf would wrongly report this as "TLS 1.2_2021
minimum, good" when the live distribution is not actually enforcing that floor. This
was carried forward as a false "known-good" in a prior audit pass without checking
state/live AWS.

**How to apply:** For any CloudFront audit, if `cloudfront_default_certificate = true`,
flag the `minimum_protocol_version` setting as a no-op (MEDIUM, not a pass) and check
`terraform.tfstate` (or live `aws cloudfront get-distribution`) to confirm what's
actually enforced, rather than trusting the declared value in main.tf. Only a custom
domain + ACM certificate + `ssl_support_method = "sni-only"` actually makes this field
effective.
