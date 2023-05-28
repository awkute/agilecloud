################################################################################
# To run this main file, you need to
# 1. Set aws credential with name dev-lf
# 2. Use below command to create s3 bucket first if it is not exist
#    aws s3api create-bucket --bucket tf-dev-cim-lf-ap-northeast-1t --create-bucket-configuration LocationConstraint=ap-northeast-1
################################################################################

locals {
  name             = var.name
  region           = var.region
  vpc_cidr         = var.cidr
  azs              = slice(data.aws_availability_zones.available.names, 0, 2)
  current_identity = data.aws_caller_identity.current.arn
  tags             = {
    Owner       = var.prj_code
    Environment = var.env
    Terraform   = "true"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.name
  cidr = var.cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 2 )]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 4)]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true


  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags

}

