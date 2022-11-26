variable "region" {}

provider "aws" {
  region  = var.region
  profile = "waiha"
}
