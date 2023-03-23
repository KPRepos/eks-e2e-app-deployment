data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


data "terraform_remote_state" "infra" {
    backend = "s3"
    config = {
      bucket = "bucket_name"
      key    = "lab-latest-eks-lab-nodejs.state"
      region = var.region
    }
}


locals {
  name = var.env_name
  region = var.region
  }