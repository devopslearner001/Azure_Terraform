## Terraform ResourceGroup  ##

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "98be8a0e-a472-4391-915d-040d50197832"  # (optional but recommended)
  tenant_id = "b16e2942-acf7-4664-a827-c99d7e81a77d"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name       = "asg-rg-old"
  location   = "West Europe"
  managed_by = "Terraform"
  tags = {
    environment = "prod"
    owner       = "atul_singh"
  }
}
