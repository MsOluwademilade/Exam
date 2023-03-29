provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.10.0"
    }
  }
}

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"
    cluster_name = "my-eks"
    cluster_version = "1.24"

    cluster_endpoint_public_access  = true

    vpc_id = module.my-eks-vpc.vpc_id
    subnet_ids = module.my-eks-vpc.private_subnets

    tags = {
        environment = "dev"
        application = "my-eks"
    }

    eks_managed_node_groups = {
        dev = {
            min_size = 2
            max_size = 4
            desired_size = 3

            instance_types = ["t2.medium"]
        }
    }
}