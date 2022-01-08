terraform {
  cloud {
    organization = "mariamihai"

    workspaces {
      name = "terraform-provisioners"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "sg_app_server" {
  name        = "sg_app_server"
  description = "AppServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [{
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.my_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
  ]

  egress {
    description = "Outgoing traffic"  
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_public_key
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_instance" "app_server" {
  ami                    = "ami-04dd4500af104442f"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_app_server.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}