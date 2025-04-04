# Create ansible inventory dynamically 

resource "local_file" "ansible_inventory" {
  filename = "/home/ubuntu/kubernetes-project-november/cluster/ansible/hosts"

  content = <<EOT

[master]
${aws_instance.master.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[worker1]
${aws_instance.worker1.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[worker2]
${aws_instance.worker2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[all:children]
master
workers

[workers]
${aws_instance.worker1.public_ip}
${aws_instance.worker2.public_ip}
EOT
}

# Create variables.tf dynamically for terraform-cluster creation  

resource "local_file" "terraform_vars" {

filename = "/home/ubuntu/kubernetes-project-november/cluster/terraform-cluster/main.tf"

content = <<EOT

terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "~> 1.4.0"
    }
  }
}

# provider "rke" {
#   log_file = "rke_debug.log"
# }

# Create a new RKE cluster using arguments
resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true
  
  nodes {
    address = "${aws_instance.master.public_ip}"
    user    = "rke"
    role    = ["controlplane", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  nodes {
    address = "${aws_instance.worker1.public_ip}"
    user    = "rke"
    role    = ["worker"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  nodes {
    address = "${aws_instance.worker2.public_ip}"
    user    = "rke"
    role    = ["worker"]
    ssh_key = file("~/.ssh/id_rsa")
  }
}

output kube_config {
  value = rke_cluster.cluster.kube_config_yaml
  sensitive = true 
}

EOT
}
