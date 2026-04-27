resource "azurerm_resource_group" "asg-rg" {
  name     = var.resourceGroup_name
  location = "West Europe"
}