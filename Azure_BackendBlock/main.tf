terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Azure provider from HashiCorp registry
      version = "4.70.0"            # Lock provider version to avoid unexpected changes
    }
  }

  backend "azurerm" {                              # Optional: Remote backend for storing Terraform state in Azure
    resource_group_name  = "asg-resource-group"    # Resource group where storage exists
    storage_account_name = "asgnewstorage123"      # Storage account name (must be globally unique)
    container_name       = "asg-container"         # Container inside storage account
    key                  = "asg.terraform.tfstate" # Name of tfstate file
  }
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




### 🚀 Terraform Backend in Azure (azurerm) ###

# In Terraform, the backend defines where the state file (.tfstate) is stored.
# By default, Terraform stores state locally, but in real-world DevOps environments, we use a remote backend like Microsoft Azure for better security, collaboration, and reliability.


### 🔧 Backend Configuration Example ###
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "asg-resource-group"
#     storage_account_name = "asgnewstorage123"
#     container_name       = "asg-container"
#     key                  = "asg.terraform.tfstate"
#   }
# }


#### 🧠 How It Works ###

# Run initialization: terraform init
# Terraform connects to Azure Storage
# State file is created or accessed in the storage container
# All operations (plan, apply, destroy) use this shared state



### 🎯 Why Use Azure Backend? ###

# ✅ Team Collaboration
# Multiple users can work on the same infrastructure

# 🔒 State Locking
# Prevents concurrent changes (avoids corruption)

# 🔐 Security
# Keeps sensitive data सुरक्षित in Azure Storage

# ⚡ Reliability
# No dependency on local machine

# 📈 Scalability
# Works for small to enterprise-level environments


### 🏗️ Step-by-Step Setup ###

# 1️⃣ Create Resource Group
# az group create \  --name asg-resource-group \  --location eastus

# 2️⃣ Create Storage Account
# az storage account create \  --name asgnewstorage123 \  --resource-group asg-resource-group \  --location eastus \  --sku Standard_LRS

# 3️⃣ Create Container
# az storage container create \  --name asg-container \  --account-name asgnewstorage123

# 4️⃣ Add Backend Block
# Add the backend configuration in your main.tf

# 5️⃣ Initialize Terraform
# terraform init


### 📂 What Happens After Setup? ###

# Terraform state is stored in Azure
# Team members use the same state file
# Infrastructure changes are tracked centrally


### ⚠️ Best Practices ###

# ✔️ Always use remote backend in team environments
# ✔️ Enable storage account versioning
# ✔️ Use RBAC (least privilege access)
# ✔️ Never commit .tfstate files to Git
# ✔️ Secure storage account access


### 💬 One-Line Summary ###

# Terraform Azure backend stores infrastructure state in Azure Storage, making it secure, shared, and reliable for DevOps teams.

