provider "aws" {
    region = "us-east-2" # var.region
}

resource "aws_key_pair" "rke_key" {
    key_name = var.deployer_key_name
    public_key = file("~/.ssh/id_rsa.pub")
}