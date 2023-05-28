variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster."
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "helm_chart_version" {
  type        = string
  default     = "1.4.4"
  description = "AWS Load Balancer Controller Helm chart version."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "AWS Load Balancer Controller Helm chart namespace which the service will be created."
}

variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "hosted zone region"
}

variable "external-dns_domain" {
  type        = string
  description = "hosted zone name"
}
