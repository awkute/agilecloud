
locals {
  name                  = var.name
}

module "key_pair" {
  source              = "terraform-aws-modules/key-pair/aws"
  key_name            = local.name
  create_private_key  = true
}
