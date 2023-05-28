data "kubectl_path_documents" "docs" {
  pattern = "${path.module}/manifests/*.yaml"
  vars    = {
    region   = var.region
    cert_arn = var.cert_arn
    prj_code = var.prj_code
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
