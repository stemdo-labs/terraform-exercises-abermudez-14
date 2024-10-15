data "azurerm_resource_group" "existent_rg" {
  name = var.existent_resource_group_name
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existent_rg.name
  
  tags = local.todas_tags
    
}
locals {
  todas_tags = merge(
    {
      owner       = var.owner_tag,
      environment = var.environment_tag
    },
    var.vnet_tags
  )
}