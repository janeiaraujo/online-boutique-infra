resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name

  tags = merge(
    {
      Name        = var.bucket_name
      Environment = var.environment
      FinOps      = "cost-center:12345"
    },
    var.additional_tags
  )

  #lifecycle {
  #  prevent_destroy = true  # Evita destruição acidental
  #  ignore_changes  = [tags]
  #}
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
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

 # lifecycle {
 #   prevent_destroy = true  # Evita destruição acidental
 # }
}
