provider "azurerm" {
  features {}
}

module "vnet_abermudez" {
    source = "git::github.com/abermudez-14/ejercicio6-tf/modules/vnet_abermudez"


    owner_tag = var.owner_tag
    environment_tag = var.environment_tag
    location = var.location
    vnet_address_space = var.vnet_address_space
    vnet_tags = var.vnet_tags
    vnet_name = var.vnet_name
    existent_resource_group_name = var.existent_resource_group_name
}

