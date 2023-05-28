locals {
  tags = {
    Owner       = data.aws_caller_identity.current.arn
    Environment = var.env
    Terraform   = "true"
  }
}

#module "records" {
#  source  = "terraform-aws-modules/route53/aws//modules/records"
#  version = "~> 2.0"
#
#  zone_name = keys(module.inno_zone.route53_zone_zone_id)[0]
#
#  records = [
#    {
#      name    = "aaaa"
#      type    = "A"
#      ttl     = 3600
#      records = [
#        "52.194.225.175",
#      ]
#    },
#  ]
#
#  depends_on = [module.inno_zone]
#}
