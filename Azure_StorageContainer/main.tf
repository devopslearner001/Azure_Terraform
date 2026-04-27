#############################################################
# TERRAFORM BLOCK
#    → Defines which provider Terraform should use and its version
#############################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official Azure provider from HashiCorp
      version = "4.70.0"
    }
  }
}


#############################################################
# PROVIDER BLOCK
#    → Used to authenticate and interact with Azure APIs
#############################################################

provider "azurerm" {
  features {} # Mandatory block (even if empty)
}


#############################################################
# RESOURCE GROUP
#    → Logical container for all Azure resources
#############################################################

resource "azurerm_resource_group" "asg_rg" {
  name       = "asg-resource-group" # Name of the Resource Group in Azure
  location   = "eastus"             # Region where resources will be created
  managed_by = "Morpheus"
  tags = {
    environment = "asg-dev"
    owner       = "asg-morphteam"
  }
}


#############################################################
# DEPENDENCY CONCEPT
#    → Terraform supports two types:
#
# 1. Implicit Dependency:
#    → Automatically created when one resource references another
#
# 2. Explicit Dependency:
#    → Manually defined using "depends_on"
#############################################################



#############################################################
# STORAGE ACCOUNT (IMPLICIT DEPENDENCY)
#    → Depends automatically on Resource Group
#############################################################

resource "azurerm_storage_account" "asg_storage_account" {

  name                     = "asgnewstorage123"                     # Must be globally unique
  resource_group_name      = azurerm_resource_group.asg_rg.name     # ↑ Implicit dependency: RG must exist first
  location                 = azurerm_resource_group.asg_rg.location # ↑ Automatically picks same location as RG
  account_tier             = "Standard"                             # Performance tier
  account_replication_type = "LRS"                                  # Locally Redundant Storage
}



#############################################################
# STORAGE CONTAINER (IMPLICIT DEPENDENCY)
#    → Depends on Storage Account
#############################################################

resource "azurerm_storage_container" "asg_storage_container" {
  name                  = "asg-container"                                  # Container name
  storage_account_name  = azurerm_storage_account.asg_storage_account.name # ↑ Implicit dependency: Storage Account must exist
  container_access_type = "private"                                        #  No public access
}



#############################################################
# STORAGE ACCOUNT (EXPLICIT DEPENDENCY EXAMPLE)
#    → It understands which resource to create first

# Shows how to manually define dependency using depends_on
# ↑ Explicit dependency:
#  → It understands which resource to create first
#  →Terraform will create this storage account ONLY AFTER container is created
#############################################################

# resource "azurerm_storage_account" "asg_storage_account_2" {
#   name                = "asgstorage456"                                                # Must be globally unique
#   resource_group_name = azurerm_resource_group.asg_rg.name
#   location            = "eastus"
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   depends_on = [
#     azurerm_storage_container.asg_storage_container
#   ]
# }

#############################################################
# NOTES (IMPORTANT)
#############################################################

# 1. Terraform works on "state" and "dependency graph"
#    → It understands which resource to create first

# 2. Implicit Dependency (BEST PRACTICE)
#    Example:
#    resource_group_name = azurerm_resource_group.asg_rg.name
#    → Terraform auto understands dependency

# 3. Explicit Dependency (USE ONLY WHEN NEEDED)
#    depends_on = [resource_name]
#    → Force order manually

# 4. Naming Rules:
#    - Storage account name must be:
#      ✔ globally unique
#      ✔ lowercase
#      ✔ no special characters

# 5. Execution Flow:
#    Step 1 → Resource Group
#    Step 2 → Storage Account
#    Step 3 → Storage Container
#    Step 4 → Explicit dependent resources

# 6. Real DevOps Use Case:
#    - Storage Account → Terraform backend
#    - Container → store tfstate files
#    - Resource Group → environment isolation

# 7. Common Mistakes (you had earlier):
#    ❌ "resources" instead of "resource"
#    ❌ Missing quotes ("eastus")
#    ❌ Wrong references (asg-resource-group instead of Terraform reference)
#    ❌ Circular dependencies

#############################################################






