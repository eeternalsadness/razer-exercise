terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.7"
    }
  }

  required_version = "~> 1.11.0"
}

provider "aws" {
  region = var.region
}

provider "cloudinit" {}
