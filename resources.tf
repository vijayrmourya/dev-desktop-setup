module "instane_with_key_iam" {
  source = "../terraform-modules/instance_with_key_pair"

  ami_id                              = data.aws_ami.ubuntu_ami.id
  instance_type                       = var.instance_type
  associate_public_ip_address_setting = var.instance_public_ip_enable
  instance_tags                       = var.tag_instance

  security_group_name        = var.security_group_name
  security_group_description = var.sg_description
  vpc_id                     = aws_default_vpc.default.id
  ingress_rules              = local.security_group_ingress
  egress_rules               = local.security_group_egress
  sg_tags                    = var.tag_sg

  tls_private_key_algorithm              = var.tls_key_algo
  tls_private_key_rsa_bits               = var.key_rsa_bits
  aws_key_pair_key_name                  = var.key_name
  local_file_private_key_filename        = local.key_out_path
  local_file_private_key_file_permission = var.key_permissions
}
