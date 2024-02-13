terraform {
  cloud {
    hostname = "terraform.xom.cloud"
    organization = "ExxonMobil"
    workspaces {
      name = "HP-AWS-PLATFORM-NOTIFICATIONS-PRD-US-EAST-1"
    }
  }
}

provider "aws" {
  # Default region
  alias  = "us-east-1"
  region = "us-east-1"
}
