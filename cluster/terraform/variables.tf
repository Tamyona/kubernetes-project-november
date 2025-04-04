# main
# variable "region" {
#     type = string
#     default = "us-east-2"
# }

variable "deployer_key_name" {
    type = string
    default = "rke-key"
}

# EC2
variable "instance_type" {
    type = string
    default = "t2.medium"
    description = "The EC2 instance type to use"
}

# EBS block
variable "root_volume_size" {
  type    = number
  default = 30
  description = "The size of the root EBS volume in GiB"
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
  description = "The type of the root EBS volume (e.g., gp2, gp3, io1)"
}

# Tags
variable "master_tag_name" {
  type    = string
  default = "master"
  description = "The tag name for master instance"
}

variable "worker1_tag_name" {
  type    = string
  default = "worker1"
  description = "The tag name for worker1 instance"
}

variable "worker2_tag_name" {
  type    = string
  default = "worker2"
  description = "The tag name for worker2 instance"
}


# Security Groups
variable "all_inbound_description" {
    type = string
    default = "Allow all inbound traffic"
}

variable "all_inbound_port" {
    type = number
    default = 0
}

variable "all_inbound_protocol" {
    type = string
    default = "-1"      # -1 meaning all protocols
}

variable "all_inbound_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
