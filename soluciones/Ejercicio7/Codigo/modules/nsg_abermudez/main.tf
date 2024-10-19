resource "azurerm_network_security_group" "nsg_abermudez" {
  name                = "nsg_abermudez"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "rule_abermudez"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }    
}

resource "azurerm_subnet_network_security_group_association" "asociar_abermudez" {
  subnet_id                 = var.id
  network_security_group_id = azurerm_network_security_group.nsg_abermudez.id
}