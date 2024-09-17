output "AMI_ID" {
  value = data.aws_ami.ubuntu_ami.id
}

output "instance_id" {
  value = module.instane_with_key_iam.instance_id
}

output "instance_public_ip" {
  value = module.instane_with_key_iam.instance_public_ip
}

output "ssh_command" {
  value = "ssh -i ${module.instane_with_key_iam.private_key_out_path} ${var.instance_username}@${module.instane_with_key_iam.instance_public_ip}"
}