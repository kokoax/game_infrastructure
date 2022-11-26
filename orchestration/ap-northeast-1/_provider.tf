variable "region"  {}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = "waiha"
}
