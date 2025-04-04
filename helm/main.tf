provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "web" {
  name       = "web"
  chart      = "../helm/web"
  values     = "../helm/web"
}

resource "helm_release" "api" {
  name       = "api"
  chart      = "../helm/api"
  values     = "../helm/api"
}

resource "helm_release" "mysql" {
  name       = "mysql"
  chart      = "../helm/mysql"
  values     = "../helm/mysql"
}