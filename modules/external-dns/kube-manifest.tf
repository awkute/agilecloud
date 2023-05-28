data "kubectl_path_documents" "docs" {
  pattern = "${path.module}/manifests/*.yaml"
  vars = {
    namespace           = var.namespace
    external-dns_role   = aws_iam_role.external-dns[0].arn
    external-dns_domain = var.external-dns_domain
    region              = var.region
  }
}
#
#resource "kubectl_manifest" "external-dns_full_deploy" {
#  for_each  = toset(data.kubectl_path_documents.docs.documents)
#  yaml_body = each.value
#}

resource "kubectl_manifest" "external-dns" {
  count     = 4
  yaml_body = element(data.kubectl_path_documents.docs.documents, count.index)
}
