variable "region" {
  default = "eu-west-1"
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.0.3"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.28.1"
    }
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform.tfstate"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.kubernetes_endpoint
  cluster_ca_certificate = data.terraform_remote_state.eks.outputs.kubernetes_certificate
  token                  = data.terraform_remote_state.eks.outputs.kubernetes_token
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.kubernetes_endpoint
    cluster_ca_certificate = data.terraform_remote_state.eks.outputs.kubernetes_certificate
    token                  = data.terraform_remote_state.eks.outputs.kubernetes_token
  }
}