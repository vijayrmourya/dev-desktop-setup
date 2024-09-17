variable "instance_username" {
  default = "ubuntu"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "instance_public_ip_enable" {
  default = true
}

variable "tag_instance" {
  default = {
    Name = "vmourya-dev-deskop"
  }
}

variable "security_group_name" {
  default = "dev-desktop-rules"
}

variable "sg_description" {
  default = "ingress and egress rules for personal development server"
}

locals {
  my_ip = chomp(data.http.my_ip.response_body)
  security_group_ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${local.my_ip}/32"]
      description = "Allow SSH from my IP"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["${local.my_ip}/32"]
      description = "Allow HTTP from my IP"
    },
    {

      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["${local.my_ip}/32"]
      description = "Allow HTTPS from my IP"
    }
  ]
  security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # Allows all protocols and ports
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  key_out_path = "${path.module}/dev-desktopkey.pem"
}

variable "tag_sg" {
  default = {
    Name = "dev-desktop-sg"
  }
}

variable "tls_key_algo" {
  default = "RSA"
}

variable "key_rsa_bits" {
  default = 4096
}

variable "key_name" {
  default = "dev-desktop-key"
}

variable "key_permissions" {
  default = "0600"
}