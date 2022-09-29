variable "aws_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "aws_subnet_cidr_block" {
  description = "Subnet CIDR Block"
  type        = string
}

variable "aws_availability_zone" {
  type = string
}