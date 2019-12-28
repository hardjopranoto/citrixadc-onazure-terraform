# Create vnet peering between the webservers and netscaler
# then configure simple server load balancing on the netscaler
# it is assumed that the webservers and netscaler have already been provisioned\

# Configure the provider.
provider "azurerm" {
  version = "~>1.31"
}


provider "citrixadc" {
  username = "ctxadmin"
  password = "CtxPa55w0rd!"
  endpoint = "http://52.156.166.49/"
}


# This resource will need to be imported
resource "azurerm_resource_group" "tfdemorg" {
  name     = "tfdemo_rg"
  location = var.location
}

# This resource will need to be imported
resource "azurerm_resource_group" "tfnsdemorg" {
  name     = "tfnsdemo_rg"
  location = var.location
}

# This resource will need to be imported
resource "azurerm_virtual_network" "tfnsdemovnet" {
  location            = "australiaeast"
  name                = "tfnsdemo-vnet"
  address_space       = ["10.10.0.0/16"]
  resource_group_name = azurerm_resource_group.tfnsdemorg.name
}

# This resource will need to be imported
resource "azurerm_virtual_network" "tfdemovnet" {
  location            = "australiaeast"
  name                = "tfdemo-vnet"
  address_space       = ["10.11.0.0/16"]
  resource_group_name = azurerm_resource_group.tfdemorg.name
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "peer_tfdemo_to_tfnsdemo"
  resource_group_name       = azurerm_resource_group.tfdemorg.name
  virtual_network_name      = azurerm_virtual_network.tfdemovnet.name
  remote_virtual_network_id = azurerm_virtual_network.tfnsdemovnet.id
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "peer_tfnsdemo_to_tfdemo"
  resource_group_name       = azurerm_resource_group.tfnsdemorg.name
  virtual_network_name      = azurerm_virtual_network.tfnsdemovnet.name
  remote_virtual_network_id = azurerm_virtual_network.tfdemovnet.id
}
