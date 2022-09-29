resource "aws_instance" "gitlab_runner_bastion" {
  ami                         = var.aws_ami
  instance_type               = var.aws_instance_type
  key_name                    = aws_key_pair.gitlab-runners-key-android.key_name
  subnet_id                   = module.network.gitlab_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.network.gitlab_sg_id]
  iam_instance_profile        = module.iam.profile_name
  user_data                   = data.cloudinit_config._.rendered

  provisioner "file" {
    source      = "modules/ec2/ansible/gitlab-config.yml"
    destination = "/tmp/gitlab-config.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      agent       = false
      private_key = file("modules/ec2/id_rsa")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.public_ip},' --private-key ./id_rsa /tmp/gitlab-config.yml --extra-vars \"BUCKET_NAME=${var.aws_bucket_name} VPC_ID=${module.network.gitlab_vpc_id} SUBNET_ID=${module.network.gitlab_subnet_id} AMI=${var.aws_ami} IAM_PROFILE=${module.iam.profile_name}\""
    ]

    on_failure = fail

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      agent       = false
      private_key = file("modules/ec2/id_rsa")
    }
  }

  root_block_device {
    volume_size           = var.aws_root_ebs_size
    volume_type           = var.aws_root_ebs_type
    delete_on_termination = true
  }

  tags = {
    Name = "GitLab Runner Bastion"
  }
}

resource "aws_key_pair" "gitlab-runners-key-android" {
  key_name   = "gitlab-runners-android-key"
  public_key = file("modules/ec2/id_rsa.pub")
}

module "network" {
  source                = "../network"
  aws_availability_zone = var.aws_availability_zone
  aws_cidr_block        = var.aws_cidr_block
  aws_subnet_cidr_block = var.aws_subnet_cidr_block
}

module "iam" {
  source          = "../iam"
  aws_bucket_name = var.aws_bucket_name
}