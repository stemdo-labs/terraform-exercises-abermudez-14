


provider "azurerm" {
  features {}

}



# Crear red virtual
resource "azurerm_virtual_network" "vnet" {

  name                = "vnet_ab_wkly"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg
}
# Crear subred

resource "azurerm_subnet" "subnet" {

  name                 = "subnet_ab_wkly"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Crear grupo de seguridad

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg_ab_wkly"
  location            = var.location
  resource_group_name = var.rg

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Asociar grupo de seguridad

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Crear IP publica para cada maquina
resource "azurerm_public_ip" "public_ip" {
  name                = "ip-publica-lb"
  location            = var.location
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  for_each           = var.maquinas
  name               = "interfaz-${each.key}"
  location           = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    // public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id  // Eliminar esta línea
  }
}



// Resto de tu configuración...


# Crear maquinas virtuales

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.maquinas
  name                = each.key
  resource_group_name = var.rg
  admin_password = var.admin_password
  location            = var.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.image["publisher"]
    offer     = each.value.image["offer"]
    sku       = each.value.image["sku"]
    version   = each.value.image["version"]
  }
}

# Crear balanceador de carga

resource "azurerm_lb" "load_balancer" {
  name                = "lb_abermudez"
  location            = var.location
  resource_group_name = var.rg
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id  // Asegúrate de que esta línea esté bien
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "backend-pool" 
  loadbalancer_id     = azurerm_lb.load_balancer.id
}

# Asociar el pool a las interfaces de red

resource "azurerm_network_interface_backend_address_pool_association" "nic_backend_association" {
  for_each                  = azurerm_network_interface.nic
  network_interface_id      = each.value.id
  ip_configuration_name      = "internal"
  backend_address_pool_id    = azurerm_lb_backend_address_pool.backend_pool.id
}


# Reglas del balanceador

resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.http_probe.id
}

resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http-probe"
  protocol                       = "Http"
  port                           = 80
  request_path                   = "/"
  interval_in_seconds            = 5
  number_of_probes               = 2
}
