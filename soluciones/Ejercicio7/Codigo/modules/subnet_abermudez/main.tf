resource "azurerm_subnet" "subnet_abermudez" {
  count = 2  
  name                 = "subnet${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.${count.index+1}.0/24"]
}

output "subnet_lista" {
  value = azurerm_subnet.subnet_abermudez
}