resource "aws_s3_bucket" "bucket_gitlab_cache_android" {
  bucket = var.aws_bucket_name

  tags = {
    Name        = "Livelo Bucket for GitLab cache - Android pipeline"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket_gitlab_cache_android.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.bucket_gitlab_cache_android.id

  rule {
    id     = "id-expire-1-days"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 1
    }
  }
}