terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "asg-rg" { # This code block is an example of a resourceGroup
  name       = "asg-resource-group"
  location   = "eastus"
  managed_by = "Morpheus"
  tags = {
    environment = "asg-dev"
    owner       = "asg-morphteam"
  }
}


## Terraform supports two types of dependencies:##
# 1. Implicit Dependency (automatic)
# 2. Explicit Dependency (manual using depends_on)


resource "azurerm_storage_account" "asg_storage_account" { # This code block is an example of a azurerm_storage_account with Implicit Dependency
  name                     = "asgstorageaccount"
  resource_group_name      = azurerm_resource_group.asg-rg.name
  location                 = azurerm_resource_group.asg-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



# resources "azurerm_storage_account" "asg_storage_account" {                        # This code block is an example of a azurerm_storage_account with Explicit Dependency
#    depends_on               = [azurerm_storage_account.asg_storage_account]
#    name                     = "asgstorage"
#    resource_group_name      = asg-resource-group
#    location                 = eastus
#    account_tier             = "Standard"
#    account_replication_type = "LRS"
# }
