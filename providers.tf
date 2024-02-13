terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0"
    }
    git = {
      source  = "innovationnorway/git"
      version = "0.1.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~>2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.1.0"
    }
  }
}
