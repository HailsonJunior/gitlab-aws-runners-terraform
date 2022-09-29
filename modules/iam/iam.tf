resource "aws_iam_role" "role" {
  name = "gitlab-runner"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# This policy gives our bastion access to resources
resource "aws_iam_policy" "policy" {
  name = "gitlab-runner-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "attachment"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "gitlab-runner-profile"
  role = aws_iam_role.role.name
}