provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "web" {
  name       = "web"
  chart      = "../helm/web"
#   values     = [file("${path.module}/../charts/web/values.yaml")]
}

resource "helm_release" "api" {
  name       = "api"
  chart      = "../helm/api"
#   values     = [file("${path.module}/../charts/api/values.yaml")]
}

resource "helm_release" "mysql" {
  name       = "mysql"
  chart      = "../helm/mysql"
#   values     = [file("${path.module}/../charts/mysql/values.yaml")]
}