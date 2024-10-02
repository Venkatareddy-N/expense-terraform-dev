terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "venkatswan"                    #s3-bucket name
    key            = "expense-terraform-dev-bastion" # every repo should have unique S3-key
    region         = "us-east-1"
    dynamodb_table = "venkatswan-db" # dynamoDB table name
  }
}

provider "aws" {
  region = "us-east-1"
}