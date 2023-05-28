# Policy


data "aws_iam_policy_document" "external-dns" {
  count = var.enabled ? 1 : 0
  statement {
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }

}

resource "aws_iam_policy" "external-dns" {
  count       = var.enabled ? 1 : 0
  name        = "${var.cluster_name}-external-dns"
  path        = "/"
  description = "Policy for external-dns service"

  policy = data.aws_iam_policy_document.external-dns[0].json
}

# Role
data "aws_iam_policy_document" "external-dns_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:external-dns",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "external-dns" {
  count              = var.enabled ? 1 : 0
  name               = "${var.cluster_name}-external-dns"
  assume_role_policy = data.aws_iam_policy_document.external-dns_assume[0].json
}

resource "aws_iam_role_policy_attachment" "external-dns" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.external-dns[0].name
  policy_arn = aws_iam_policy.external-dns[0].arn
}
