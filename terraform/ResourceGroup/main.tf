resource "azurerm_resource_group" "rg" {
  name     = "RG-Terraform-Storage-GWC-01"
  location = "germanywestcentral" #See: https://learn.microsoft.com/en-us/azure/virtual-machines/regions
}