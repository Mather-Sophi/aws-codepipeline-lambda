terraform {
  required_version = ">= 0.12"

  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "~> 4.0"
    }
  }

}
