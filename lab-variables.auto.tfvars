####General tfvars
cluster-name                         = "eks-devops-lab"
eks_version                          = "1.24"
env_name                             = "devops-lab"
cluster_endpoint_public_access_cidrs = ["73.215.213.121/32"]
cluster_endpoint_public_access       = true
deploy_eks_alb_controller            = "yes"
####

###EKS NodeGroup Sizing
min_size       = 1
max_size       = 3
desired_size   = 1
instance_types = ["t3.medium"]
###

#### Automatically updated by Startup.sh##
region = "us-west-2"
####
