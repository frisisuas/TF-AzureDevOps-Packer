data "http" "icanhazip" {
  url = "http://icanhazip.com"
}

resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  name                = "vm-NSG"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_security_rule" "nsg_regla" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "rdp-casa"
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = 1100
  protocol                    = "Tcp"
  resource_group_name         = azurerm_resource_group.rg.name
  source_port_range           = "*"
  destination_port_range      = "3389"
  destination_address_prefix  = "*"
  source_address_prefix       = chomp(data.http.icanhazip.body)
}
resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  name                = "vnet"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    "10.0.10.0/24"
  ]
}

resource "azurerm_public_ip" "pip" {
  allocation_method       = "Dynamic"
  location                = var.location
  name                    = "pip"
  resource_group_name     = azurerm_resource_group.rg.name
  idle_timeout_in_minutes = 30

}

resource "azurerm_network_interface" "nic" {
  location            = var.location
  name                = "nic-vm"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
    name                          = "pip"
    private_ip_address_allocation = "Dynamic"
  }
}
