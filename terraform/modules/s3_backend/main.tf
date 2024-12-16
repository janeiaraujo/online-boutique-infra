resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
  acl    = "private"
  versioning {
    enabled = true
  }

  tags = merge(
    {
      Name        = var.bucket_name
      Environment = var.environment
      FinOps      = "cost-center:12345"
    },
    var.additional_tags
  )
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    {
      Name        = var.dynamodb_table
      Environment = var.environment
      FinOps      = "cost-center:12345"
    },
    var.additional_tags
  )
}
