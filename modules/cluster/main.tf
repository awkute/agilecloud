provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

locals {
  current_identity = data.aws_caller_identity.current.arn
  cluster_name_env = "${var.cluster_name}_${var.env}"
  tags             = {
    Owner       = var.prj_code
    Environment = var.env
    Terraform   = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = local.cluster_name_env
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni    = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_security_group_additional_rules = {

  }

  node_security_group_additional_rules = {
    ingress_cidr_all = {
      description      = "Node to node all ports/protocols"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "ingress"
      cidr_blocks      = [var.cidr]
    }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  eks_managed_node_groups = {
    worker_group = {
      name           = "${var.prj_code}-${var.env}-worker"
      min_size       = 2
      max_size       = 10
      desired_size   = 2
      instance_types = ["m5.large"]
      capacity_type  = "ON_DEMAND"

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node-type=worker'"

      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        Environment = var.env
      }

      tags = local.tags
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = var.aws_auth_users

  tags = local.tags

}
