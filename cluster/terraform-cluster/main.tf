terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "~> 1.4.0"
    }
  }
}

resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true
  
  nodes {
    address = var.master_ip
    user    = "rke"
    role    = ["controlplane", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  nodes {
    address = var.worker1_ip
    user    = "rke"
    role    = ["worker"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  nodes {
    address = var.worker2_ip
    user    = "rke"
    role    = ["worker"]
    ssh_key = file("~/.ssh/id_rsa")
  }
}

output kube_config {
  value = rke_cluster.cluster.kube_config_yaml
  sensitive = true 
}