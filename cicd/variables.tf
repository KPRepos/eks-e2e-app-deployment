
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = [
  ]
}



variable "region" {
  # default     = "us-west-2"
  type        = string
  description = "The AWS Region to deploy to"
}

variable "cluster-name" {
  type        = string
  description = "The name of your EKS Cluster"
}


variable "env_name" {
  type = string
}


variable "table_name_net" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_net"
}

variable "table_name_iam" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_iam"
}

variable "table_name_c9net" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_c9net"
}

variable "table_name_cicd" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_cicd"
}

variable "table_name_cluster" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_cluster"
}

variable "table_name_nodeg" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_nodeg"
}

variable "table_name_eks-cidr" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_eks-cidr"
}

variable "table_name_sampleapp" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_sampleapp"
}

variable "table_name_tf-setup" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform_locks_tf-setup"
}

variable "stages" {
    type=list(string)
    default=["tf-setup","net","iam","c9net","cluster","nodeg","cicd","eks-cidr","sampleapp"]
}

variable "stagecount" {
    type=number
    default=9
}
