output "gitlab_subnet_id" {
  value = aws_subnet.gitlab-subnet.id
}

output "gitlab_sg_id" {
  value = aws_security_group.gitlab-sg.id
}

output "gitlab_vpc_id" {
  value = aws_vpc.gitlab-vpc.id
}