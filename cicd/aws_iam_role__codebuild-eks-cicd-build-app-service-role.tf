
data "aws_iam_policy_document" "codebuild_access_s3_policy" {
  statement {
    actions = [
            "s3:GetObject",
            "s3:GetObjectVersion"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.codebuild-artifacts-private_bucket.arn}/*"]
  }
}



resource "aws_iam_role_policy" "codebuild_access_s3_role_policy" {
  role = aws_iam_role.codebuild-eks-cicd-build-app-service-role.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:GetObject",
            "s3:GetObjectVersion"],
            "Resource": "${aws_s3_bucket.codebuild-artifacts-private_bucket.arn}/*"
        }
    ]
}
POLICY
}


# Allow EC2 instances to assume the role
data "aws_iam_policy_document" "codebuild-eks-cicd-build-app-service-rolepolicy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

  }
}


resource "aws_iam_role" "codebuild-eks-cicd-build-app-service-role" {
  assume_role_policy = data.aws_iam_policy_document.codebuild-eks-cicd-build-app-service-rolepolicy.json
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "${var.env_name}-codebuild-eks-cicd-build-app-service-role"
  # path                  = "/service-role/"
  tags                  = {}
  inline_policy {
    policy = data.aws_iam_policy_document.codebuild_access_s3_policy.json
  }
}

        
