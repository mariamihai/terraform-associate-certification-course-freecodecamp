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

provider "aws" {
  profile = "terraform"
  region  = "eu-west-2"
  alias = "second_region"
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

  #provider = aws.second_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  #azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  #providers = {
  #  aws = aws.second_region
  # }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}