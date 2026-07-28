
# --------------------------------------------------------------------------
# Backend bootstrap (two-phase):
#
# Phase 1: Leave this block commented out. Run `terraform init` (local state)
#          and `terraform apply` to create this project's resources. Separately,
#          create an S3 bucket + DynamoDB table to hold Terraform state (e.g.
#          via the AWS CLI or console) before moving to phase 2.
#
# Phase 2: Uncomment the block below, fill in the bucket/key/region/
#          dynamodb_table values to match what was just created, then run
#          `terraform init -migrate-state` to move local state into S3.
# --------------------------------------------------------------------------

# terraform {
#   backend "s3" {
#     bucket         = "<state-bucket-name>"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "<lock-table-name>"
#     encrypt        = true
#   }
# }
