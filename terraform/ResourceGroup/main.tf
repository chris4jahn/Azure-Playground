terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2"
    }
  }
}

provider "azurerm" {
  features {}
}

module "azure_location" {
  source  = "azurerm/locations/azure"
  version = "0.2.4"

  location = "westeurope"
}

# This is the definition for the acurecaf module for the prefixes and sufixes
locals {
    # here we use the azure location module to get the short name of the location
    location = module.azure_location.location
    region_short = [module.azure_location.short_name]
    name = "naming"
    caf_prefixes = ["myapp"]
    caf_suffixes = ["test", "001"]
    common_tags  = {
        environment = "Test"
        team        = "Cloud Infrastructre"
        location    = module.azure_location.display_name

    }
}

# concat the prefixes and suffixes to create the name for a certain resource
#<caf_prefixes>-<resource_type>-<name>-<local_short>-<caf_suffixes>
# in my case I don't use a prefix here
data "azurecaf_name" "rg" {
    name          = local.name
    resource_type = "azurerm_resource_group"
    #prefixes      = local.caf_prefixes
    suffixes      = concat(local.region_short , local.caf_suffixes)
    clean_input   = true
}

# Create a resource group and use the locations module to get the location
resource "azurerm_resource_group" "rg" {
    name = data.azurecaf_name.rg.result
    location = module.azure_location.name
    tags = "${merge( local.common_tags)}"
}
