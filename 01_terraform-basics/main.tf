terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mariamihai"

    workspaces {
      name = "terraform-basics"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

locals {
  project_name = "learning_tf"
}
