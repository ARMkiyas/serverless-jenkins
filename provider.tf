
terraform {

  # cloud {
  #   organization = "kiyas-cloud"

  #   workspaces {
  #     name = "cloudcare"
  #   }
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }

  }

}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}



