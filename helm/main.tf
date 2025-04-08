provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "api" {
  name       = "api"
  chart      = "${path.module}/api"
  values     = [file("${path.module}/api/values.yaml")]
}

resource "helm_release" "mysql" {
  name       = "mysql"
  chart      = "${path.module}/mysql"
  values     = [file("${path.module}/mysql/values.yaml")]
  depends_on = [helm_release.api]
}

resource "helm_release" "web" {
  name       = "web"
  chart      = "${path.module}/web"
  values     = [file("${path.module}/web/values.yaml")]
  depends_on = [helm_release.mysql]
}