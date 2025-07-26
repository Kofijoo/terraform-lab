provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "joshua-tf-state-7262025" # <== CHANGE TO BE UNIQUE
  force_destroy = true

  tags = {
    Name = "terraform-backend-state"
    Owner = "josh"
    Environment = "lab"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-state-locks"
    Owner = "josh"
    Environment = "lab"
  }
}
