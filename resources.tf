module "instane_with_key_iam" {
  source = "../terraform-modules/instance_with_key_pair"

  ami_id                              = data.aws_ami.ubuntu_ami.id
  instance_type                       = "t3.medium"
  associate_public_ip_address_setting = true
  instance_tags = {
    Name = "vmourya-dev-deskop"
  }

  security_group_name        = "dev-desktop-rules"
  security_group_description = "ingress and egress rules for personal development server"
  vpc_id                     = aws_default_vpc.default.id
  ingress_rules = [
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
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # Allows all protocols and ports
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  sg_tags = {
    Name = "dev-desktop-sg"
  }

  tls_private_key_algorithm              = "RSA"
  tls_private_key_rsa_bits               = 4096
  aws_key_pair_key_name                  = "dev-desktop-key"
  local_file_private_key_filename        = "${path.module}/dev-desktopkey.pem"
  local_file_private_key_file_permission = "0600"
}
