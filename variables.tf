#custom variables outside of modules
variable "cluster-name" {
  type        = string
  description = "The name of your EKS Cluster"
}

variable "eks_version" {
  type = string
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

