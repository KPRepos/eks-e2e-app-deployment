terraform {
  backend "s3" {
    bucket = "bucket_name"
    key    = "lab-latest-devops.state"
    region = "region_name"
  }
}

provider "aws" {
  region = "region_name"
}
