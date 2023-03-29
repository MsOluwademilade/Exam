data "aws_availability_zones" "azs" {}
module "my-eks-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.19.0"
  name            = "my-eks-vpc"
  cidr            = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }
}