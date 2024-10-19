provider "azurerm" {
  features {}
}

resource "azurerm_key_vault" "vault_abermudez" {
  name                        = "vaultabermudez"
  location                    = "West Europe"
  resource_group_name         = "rg-abermudez-dvfinlab"
  tenant_id                   = "2835cee8-01b5-4561-b27c-2027631bcfe1"
  sku_name                    = "standard"
}

resource "azurerm_storage_account" "sta_abermudez" {
  name                     = "cuentaabermudez"
  resource_group_name      = "rg-abermudez-dvfinlab"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
