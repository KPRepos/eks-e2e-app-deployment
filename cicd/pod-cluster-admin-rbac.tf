locals {
  iam_role_test = [
     {
      rolearn  = aws_iam_role.codebuild-eks-cicd-build-app-service-role.arn
      username = "build"
      groups   =  ["system:masters"]
      }
  ]
}



locals {

  merged_map_roles = distinct(concat(
    try(yamldecode(yamldecode(data.terraform_remote_state.infra.outputs.aws_auth_configmap_yaml).data.mapRoles), []),
    local.iam_role_test,
  ))

  aws_auth_configmap_yaml = templatefile("${path.module}/templates/aws_auth_cm.tpl",
    {
      map_roles    = local.merged_map_roles
      # map_users    = var.map_users
      # map_accounts = var.map_accounts
    }
  )
}


resource "kubernetes_config_map_v1_data" "aws_auth" {
  # depends_on = [data.http.wait_for_cluster]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles"    = yamlencode(local.merged_map_roles)
  }

  force = true
}


provider "kubernetes" {
  host                   = data.terraform_remote_state.infra.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_certificate_authority_data)
  # load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.infra.outputs.cluster_name]
  }
  
}
