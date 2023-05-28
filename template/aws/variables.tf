// Make sure this is uniq
variable "prj_code" {
  default = "replace-me"
}

// Make sure this is uniq
variable "cidr" {
  default = "172.19.0.0/16"
}

variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "key_pair_name" {
  default = "petclinic"
}

variable "aws_auth_users" {
  default = [
    {
      userarn  = "arn:aws:iam::026882776119:user/hyu"
      username = "admin1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::026882776119:user/Gao"
      username = "admin2"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::026882776119:user/misawa"
      username = "admin3"
      groups   = ["system:masters"]
    },
  ]
}

variable "external-dns_domain" {
  default = "nt2data.com"
}

variable "petclinic_cert_arn" {
  default = "arn:aws:acm:us-east-1:026882776119:certificate/fae92f50-5dff-446f-9b92-df30845388cb"
}
