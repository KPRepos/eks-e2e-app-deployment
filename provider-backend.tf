terraform {
  backend "s3" {
    bucket = "bucket_name"
    key    = "lab-latest-eks-lab-nodejs.state"
    region = "region_name"
  }
}


provider "aws" {
  region = local.region
  ignore_tags {
    key_prefixes = ["kubernetes.io/role/*"]
  }
}

