provider "azurerm" {
  features {}
}


resource "azurerm_storage_account" "sta_abermudez" {
  name                     = "cuentaabermudez"          
  resource_group_name      = "rg-abermudez-dvfinlab"    
  location                 = "West Europe"              
  account_tier             = "Standard"                 
  account_replication_type = "LRS"                      
}

import {
  to = azurerm_storage_account.sta_abermudez
  id = "/subscriptions/86f76907-b9d5-46fa-a39d-aff8432a1868/resourceGroups/rg-abermudez-dvfinlab/providers/Microsoft.Storage/storageAccounts/cuentaabermudez"
}
