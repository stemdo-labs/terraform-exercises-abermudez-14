terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm ={
        source = "hashicorp/azurerm"
        version = "4.5.0"   
     }
  }
}


provider "azurerm"{
    features {}
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
}


resource "azurerm_storage_account" "example" {
  name                     = "abermudez"
  resource_group_name      = "rg-abermudez-dvfinlab"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


