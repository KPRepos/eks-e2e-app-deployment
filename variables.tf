#custom variables outside of modules
variable "cluster-name" {
  type        = string
  description = "The name of your EKS Cluster"
}

variable "eks_version" {
  type        = string
  description = "EKS version"
}

variable "region" {
  type        = string
  description = "The AWS Region to deploy to"
}


variable "env_name" {
  type = string
}


variable "min_size" {
  type = string
}

variable "max_size" {
  type = string
}

variable "desired_size" {
  type = string
}

variable "cluster_endpoint_public_access_cidrs" {

  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "deploy_eks_alb_controller" {
  type = string
}

variable "cluster_endpoint_public_access" {
  type        = string
  description = "true or false"
  default     = true
}

variable "instance_types" {
  type    = list(any)
  default = ["t3.small"]
}
