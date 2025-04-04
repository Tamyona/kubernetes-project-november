# AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20250305"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Master Instance
resource "aws_instance" "master" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.rke_key.key_name
  security_groups = [aws_security_group.allow_all_inbound.name]
  
  root_block_device {
    volume_size = var.root_volume_size  # Set root volume to 30 GiB
    volume_type = var.root_volume_type  # Use gp3 for better performance (or gp2 for standard SSD)
  }
  
  tags = {
    Name = var.master_tag_name
  }
}

# Worker Instance
resource "aws_instance" "worker1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.rke_key.key_name
  security_groups = [aws_security_group.allow_all_inbound.name]
  
  root_block_device {
    volume_size = var.root_volume_size  # Set root volume to 30 GiB
    volume_type = var.root_volume_type  # Use gp3 for better performance (or gp2 for standard SSD)
  }
  
  tags = {
    Name = var.worker1_tag_name
  }
}

# Worker Instance
resource "aws_instance" "worker2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.rke_key.key_name
  security_groups = [aws_security_group.allow_all_inbound.name]
  
  root_block_device {
    volume_size = var.root_volume_size  # Set root volume to 30 GiB
    volume_type = var.root_volume_type  # Use gp3 for better performance (or gp2 for standard SSD)
  }
  
  tags = {
    Name = var.worker2_tag_name
  }
}

# Outputs - should we use separate file
output master_ip {
    value = aws_instance.master.public_ip
}

output worker1_ip {
    value = aws_instance.worker1.public_ip
}

output worker2_ip {
    value = aws_instance.worker2.public_ip
}