resource "aws_security_group" "allow_all_inbound" {
  name        = "all_inbound"
  description = var.all_inbound_description

  ingress {
    description = var.all_inbound_description
    from_port   = var.all_inbound_port
    to_port     = var.all_inbound_port
    protocol    = var.all_inbound_protocol    # -1 meaning all protocols
    cidr_blocks = var.all_inbound_cidr_blocks
  }

  egress {
    from_port   = var.all_inbound_port
    to_port     = var.all_inbound_port
    protocol    = var.all_inbound_protocol    
    cidr_blocks = var.all_inbound_cidr_blocks
  }

  tags = {
    Name = "allow_all_inbound"
  }
}