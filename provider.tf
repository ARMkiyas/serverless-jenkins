
terraform {

  # cloud {
  #   organization = "kiyas-cloud"

  #   workspaces {
  #     name = "jenkins-master"
  #   }
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }

}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}



