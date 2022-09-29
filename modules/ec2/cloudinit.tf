data "cloudinit_config" "_" {
  part {
    filename     = "cloud-config.cfg"
    content_type = "text/cloud-config"
    content      = <<-EOF
      hostname: gitlab-runner-bastion
      package_update: true
      package_upgrade: true
      packages:
        - apt-transport-https
        - ca-certificates
        - curl
        - gnupg-agent
        - software-properties-common
        - awscli
        - ansible
      EOF
  }

  # Install GitLab Runner
  part {
    filename     = "install-gitlab-runner.sh"
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/sh
      curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb"
      dpkg -i gitlab-runner_amd64.deb
    EOF
  }

  # Install Docker Machine
  part {
    filename     = "install-docker-machine.sh"
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/sh
      curl -O "https://gitlab-docker-machine-downloads.s3.amazonaws.com/v0.16.2-gitlab.15/docker-machine-Linux-x86_64"
      cp docker-machine-Linux-x86_64 /usr/local/bin/docker-machine
      chmod +x /usr/local/bin/docker-machine
    EOF
  }

  # Register GitLab Runner
  part {
    filename     = "register-runner.sh"
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/sh
      sudo gitlab-runner register \
        --non-interactive \
        --url "https://gitlab.com/" \
        --registration-token ${var.gitlab_registration_token} \
        --executor "docker+machine" \
        --docker-image alpine:latest \
        --description "GitLab Runner Bastion Docker Machine" \
        --maintenance-note "Free-form maintainer notes about this runner" \
        --tag-list "docker-machine,aws" \
        --run-untagged="false" \
        --locked="false" \
        --access-level="not_protected"
    EOF
  }

  ## Set AWS credentials
  #part {
  #  filename     = "aws-credentials.sh"
  #  content_type = "text/x-shellscript"
  #  content      = <<-EOF
  #    #!/bin/sh
  #    aws --profile default configure set aws_access_key_id "${var.AWS_KEY}"
  #    aws --profile default configure set aws_secret_access_key "${var.AWS_SECRET}"
  #  EOF
  #}
}