# Create ansible inventory dynamically 

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/hosts"

  content = <<EOT

[nodes]
${aws_instance.master.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
${aws_instance.worker1.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
${aws_instance.worker2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[master]
${aws_instance.master.public_ip} 
[workers]
${aws_instance.worker1.public_ip}
${aws_instance.worker2.public_ip}
EOT
}

# Create variables file for another Terraform-cluster module
resource "local_file" "terraform_cluster_vars" {
  filename = "${path.module}/../terraform-cluster/variables.tf"

  content = <<EOT

variable "master_ip" {
  default = "${aws_instance.master.public_ip}"
}

variable "worker1_ip" {
  default = "${aws_instance.worker1.public_ip}"
}

variable "worker2_ip" {
  default = "${aws_instance.worker2.public_ip}"
}
EOT
}