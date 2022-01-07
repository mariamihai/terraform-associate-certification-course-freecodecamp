terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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

resource "aws_instance" "app_server" {
  ami           = "ami-04dd4500af104442f"
  instance_type = var.instance_type

  tags = {
    Name = "ExampleAppServerInstance"
  }
}