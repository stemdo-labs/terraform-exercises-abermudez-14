terraform {
  backend "azurerm" {
    resource_group_name   = "rg-abermudez-dvfinlab"
    storage_account_name  = "staabermudezdvfinlab"
    container_name        = "contenedorabermudez"
    key                   = "terraform.tfstate"  
  }
}

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

resource "azurerm_storage_container" "ctn_abermudez" {
  name = "contenedorabermudez"
  storage_account_name = "staabermudezdvfinlab"
  container_access_type = "private"
}


