---
name: cloudfront-price-class-portfolio
description: Portfolio site CloudFront distribution using PriceClass_200; candidate for downgrade to PriceClass_100
metadata:
  type: project
---

**Fact**: terraform/main.tf line 79 configures CloudFront with `price_class = "PriceClass_200"` for static portfolio website.

**Why**: PriceClass_200 reaches ~95% of traffic globally with 174 edge locations, adding ~20% cost vs PriceClass_All. For a personal portfolio (not serving critical global audience), PriceClass_100 (83 locations, 48% of traffic) is often sufficient and saves 25-30% on CloudFront egress costs.

**How to apply**: Before recommending PriceClass_100 downgrade, confirm the portfolio doesn't rely on low-latency access from Asia-Pacific or other regions outside North America/Europe. If primary audience is US/EU, PriceClass_100 is safe. For global reach, keep PriceClass_200.
