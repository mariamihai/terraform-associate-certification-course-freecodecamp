# Saved as Terraform variable in the Terraform Cloud workspace
variable "ssh_public_key" {
  type = string
  default = "xxxxxxxxx"
}

variable "vpc_id" {
  default = "vpc-xxxx"
}

variable "my_ip" {
  default = "X.X.X.X/32"
}