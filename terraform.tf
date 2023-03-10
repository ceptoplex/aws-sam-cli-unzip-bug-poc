terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.51.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "null_resource" "build_lambda_function" {
  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command = "make build-go"
  }
}

resource "aws_iam_role" "this" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Sid = ""
      }
    ]
  })
}

resource "aws_lambda_function" "this" {
  function_name = "example-function"
  role          = aws_iam_role.this.arn

  runtime  = "go1.x"
  handler  = "example"
  filename = "bin/functions.zip"

  depends_on = [
    null_resource.build_lambda_function
  ]
}

# This null_resource is just used to encode metadata for AWS SAM tooling to enable local execution:
resource "null_resource" "sam_metadata_" {
  triggers = {
    resource_name        = "aws_lambda_function.this"
    resource_type        = "ZIP_LAMBDA_FUNCTION"
    original_source_code = "."
    built_output_path    = "bin/functions.zip"
  }

  depends_on = [
    null_resource.build_lambda_function
  ]
}
