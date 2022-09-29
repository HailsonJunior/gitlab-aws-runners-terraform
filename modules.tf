module "instance" {
  source                    = "./modules/ec2"
  aws_ami                   = var.aws_ami
  aws_instance_type         = var.aws_instance_type
  aws_root_ebs_size         = var.aws_root_ebs_size
  aws_root_ebs_type         = var.aws_root_ebs_type
  gitlab_registration_token = var.gitlab_registration_token
  aws_availability_zone     = var.aws_availability_zone
  aws_cidr_block            = var.aws_cidr_block
  aws_subnet_cidr_block     = var.aws_subnet_cidr_block
  aws_bucket_name           = var.aws_bucket_name
}

module "s3" {
  source          = "./modules/s3"
  aws_bucket_name = var.aws_bucket_name
}