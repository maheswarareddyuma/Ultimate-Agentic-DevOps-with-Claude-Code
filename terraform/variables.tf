variable "region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name, used for resource naming and the Project tag"
  type        = string
  default     = "portfolio-site"
}

variable "environment" {
  description = "Deployment environment, used for the Environment tag"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Custom domain name for the CloudFront distribution (leave empty to use the default *.cloudfront.net domain)"
  type        = string
  default     = ""
}
