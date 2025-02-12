variable "address_space" {
    default = "174.0.0.0/16"
    description = "CIDR of the vnet"
}

resource "azurerm_resource_group" "rg" {
  name     = "RG-Terraform-VNET-GWC-01"
  location = "germanywestcentral" #See: https://learn.microsoft.com/en-us/azure/virtual-machines/regions
}

resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-Terraform-GWC-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space = [var.address_space]
}
