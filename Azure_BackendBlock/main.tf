terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Azure provider from HashiCorp registry
      version = "4.70.0"            # Lock provider version to avoid unexpected changes
    }
  }

  # backend "azurerm" {                              # Optional: Remote backend for storing Terraform state in Azure
  #   resource_group_name  = "asg-resource-group"    # Resource group where storage exists
  #   storage_account_name = "asgnewstorage123"      # Storage account name (must be globally unique)
  #   container_name       = "asg-container"         # Container inside storage account
  #   key                  = "asg.terraform.tfstate" # Name of tfstate file
  # }
}

provider "azurerm" {
  features {} # Required block for Azure provider (even if empty)
}

resource "azurerm_resource_group" "asg_rg" { # Defines an Azure Resource Group
  name       = "asg-resource-group"          # Name of the resource group
  location   = "eastus"                      # Azure region where resources will be created
  managed_by = "Terraform"                   # Optional metadata showing who manages this resource
}

resource "azurerm_storage_account" "asg_storage_account" {          # Creates a Storage Account
  name                     = "asgnewstorage123"                     # Must be globally unique, lowercase, 3–24 chars
  resource_group_name      = azurerm_resource_group.asg_rg.name     # Implicit dependency on resource group
  location                 = azurerm_resource_group.asg_rg.location # Uses same location as RG
  account_tier             = "Standard"                             # Performance tier (Standard or Premium)
  account_replication_type = "LRS"                                  # Redundancy type (Locally Redundant Storage)
}

resource "azurerm_storage_container" "asg_storage_container" {             # Creates a container inside storage account
  name                  = "asg-container"                                  # Name of the container
  storage_account_name  = azurerm_storage_account.asg_storage_account.name # Implicit dependency on storage account
  container_access_type = "private"                                        # Access level (private = no public access)
}