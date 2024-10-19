provider "azurerm" {
  features {}
}

module "vnet_abermudez" {
    source = "./modules/vnet_abermudez"


    owner_tag = var.owner_tag
    environment_tag = var.environment_tag
    location = var.location
    vnet_address_space = var.vnet_address_space
    vnet_tags = var.vnet_tags
    vnet_name = var.vnet_name
    existent_resource_group_name = var.existent_resource_group_name
}



module "subnet_abermudez" {
  source = "./modules/subnet_abermudez"
  subnet_name = var.subnet_name
  resource_group_name = var.existent_resource_group_name
  address_prefixes = var.address_prefixes
  virtual_network_name = module.vnet_abermudez.vnet_name


}



module "nsg_abermudez" {
  source = "./modules/nsg_abermudez"
  count = 2
  location = var.location
  resource_group_name = var.resource_group_name
  id = module.subnet_abermudez.subnet_lista[count.index].id
}



