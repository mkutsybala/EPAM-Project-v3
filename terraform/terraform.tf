terraform {
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