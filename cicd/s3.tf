
locals {
  tags = {
    Environment    = var.env_name
  }
}

resource "random_password" "s3_name_hash" {
  length           = 7
  special          = false
  upper = false
}

 

resource "aws_s3_bucket" "codebuild-artifacts-private_bucket" {
  bucket = "codebuild-artifacts-${random_password.s3_name_hash.result}"
  acl    = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags =  local.tags

}


  # Block public access
resource "aws_s3_bucket_public_access_block" "codebuild-artifacts-private_bucket" {
  bucket = aws_s3_bucket.codebuild-artifacts-private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


data "archive_file" "member_zip" {
  type       = "zip"
  source_dir = "../node-js-sample-app"
  output_path = "../node-js-sample-app.zip"
  #depends_on  = [archive_file.member_zip]
}



resource "aws_s3_bucket_object" "object" {
  depends_on = [data.archive_file.member_zip]
  bucket = aws_s3_bucket.codebuild-artifacts-private_bucket.id
  key    = "node-js-sample-app.zip"
  source = data.archive_file.member_zip.output_path
  etag = data.archive_file.member_zip.output_path
  # etag = filemd5("${path.module}./node-js-sample-app.zip")
}

