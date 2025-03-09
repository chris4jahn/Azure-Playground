module "azure_location" {
  source  = "azurerm/locations/azure"
  version = "0.2.4"

  location = "westeurope"
}

# define the prefixes and sufixes
locals {
    #subscription_id = "xxxx-xxxx-xxxx-xxxx"
    location = module.azure_location.location
    region_short = [module.azure_location.short_name]
    name = "naming"
    caf_prefixes = ["myapp"]
    caf_suffixes = ["test", "001"]
    common_tags  = {
        environment = "Test"
        team        = "Cloud Infrastructre"
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

resource "azurerm_resource_group" "rg" {
    name = data.azurecaf_name.rg.result
    location = module.azure_location.name
    tags = "${merge( local.common_tags)}"
}
