variable "aws_ami" {
  description = "AMI for instances"
  type        = string
}

variable "aws_instance_type" {
  type = string
}

variable "aws_root_ebs_size" {
  description = "EBS block storage size"
  type        = number
}

variable "aws_root_ebs_type" {
  description = "EBS block storage type"
  type        = string
}

variable "gitlab_registration_token" {
  type = string
}

variable "aws_availability_zone" {
  type = string
}

variable "aws_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "aws_subnet_cidr_block" {
  description = "Subnet CIDR Block"
  type        = string
}

variable "aws_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}