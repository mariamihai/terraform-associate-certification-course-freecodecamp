terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = "eu-west-1"
}

variable "instance_type" {
  type = string
}

locals {
  project_name = "learning_tf"
}

resource "aws_instance" "app_server" {
  ami           = "ami-04dd4500af104442f"
  instance_type = var.instance_type

  tags = {
    Name = "${local.project_name}_ExampleAppServerInstance"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}