provider "aws" {
  profile = "terraform"
  region  = "eu-west-1"
}

provider "aws" {
  profile = "terraform"
  region  = "eu-west-2"
  alias   = "second_region"
}