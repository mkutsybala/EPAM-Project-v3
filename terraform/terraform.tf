terraform {
  backend "s3" {
   bucket = "mk-s3-bucket-for-back-end"
   region = "eu-west-2"
   key = "infrastructure/terraform.tfstate"
   dynamodb_table = "terraform-lock"
   encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.36.1"
    }
	 http = {
      source = "hashicorp/http"
      version = "~>3.1.0"
    }
  }
}