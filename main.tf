locals {
  region = "us-east-1"
}

provider "aws" {
  region = local.region
}