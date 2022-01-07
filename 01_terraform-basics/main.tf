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

resource "aws_instance" "app_server" {
  ami           = "ami-04dd4500af104442f"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}