# This block tells Terraform which plugins it needs to download
terraform {
  required_providers {
    # AWS provider to create the server, security group, and static IP
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # TLS provider to automatically generate secure SSH keys locally
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    # Local provider to save the generated SSH key to a .pem file on your laptop
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# This block tells Terraform which AWS region to deploy our infrastructure into
provider "aws" {
  region = "us-east-1" # N. Virginia data center
}