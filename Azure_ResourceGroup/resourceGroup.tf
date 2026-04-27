## Terraform Resource Group Configuration ##

terraform {
  required_providers {                # Defines which providers Terraform should use
    azurerm = {
      source  = "hashicorp/azurerm"   # Official Azure provider maintained by HashiCorp
      version = "=4.1.0"              # Locks provider version to ensure consistent behavior across environments
    }
  }
}


## Configure the Azure provider ##

provider "azurerm" {
  features {}                       # Required block (even if empty) to enable Azure provider features
}


## Create a Resource Group in Azure ##

resource "azurerm_resource_group" "rg" {
  name       = "asg-rg-old"        # Name of the Resource Group (must be unique within your subscription)
  location   = "West Europe"       # Azure region where resources will be deployed
  managed_by = "Terraform"         # Optional field to indicate this resource is managed by Terraform
  tags = {                         # Key-value metadata for organization and cost tracking
    environment = "prod"           # Defines environment (e.g., dev, staging, prod)
  }
}
