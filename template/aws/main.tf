terraform {
  backend "s3" {
    // region and bucket is fixed
    region = "ap-northeast-1"
    bucket = "petclinic-dev-ap-northeast-1.terraform"

    // Make sure this is uniq, recommend to replace prj_code and region code for different
    key = "replace-me-infra.tfstate"
  }
}

module "network" {
  source   = "../../modules/network"
  prj_code = var.prj_code
  name     = var.prj_code
  cidr     = var.cidr
}

module "common_key_pair" {
  source = "../../modules/keypair"
  name   = "${var.prj_code}-${var.key_pair_name}"
}

module "eks" {
  source          = "../../modules/cluster"
  cluster_name    = "${var.prj_code}-${var.env}"
  cluster_version = "1.23"
  env             = var.env
  subnet_ids      = module.network.vpc.public_subnets
  vpc_id          = module.network.vpc.vpc_id
  prj_code        = var.prj_code
  aws_auth_users  = var.aws_auth_users
  cidr            = var.cidr
}

module "load_balancer_controller" {
  source                           = "../../modules/aws-lb"
  enabled                          = true
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.cluster_id
}

module "external-dns" {
  source                           = "../../modules/external-dns"
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.cluster_id
  external-dns_domain              = var.external-dns_domain
  region                           = var.region
}

module "petclinic" {
  source   = "../../modules/petclinic"
  region   = var.region
  cert_arn = var.petclinic_cert_arn
  prj_code = var.prj_code
}
