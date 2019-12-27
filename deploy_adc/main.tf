# Terraform script to deploy Netscaler in two-arm mode in Azure using azurerm

# Define the variables and default values to be used throughout this script
variable "admin_username" {
  default = "nsroot"
}

variable "admin_password" {
  default = "CtxPa55w0rd!"
}

variable "resource_prefix" {
  default = "tfnsdemo"
}

# You'll usually want to set this to a region near you.
variable "location" {
  default = "australiaeast"
}



# Configure the provider.
provider "azurerm" {
  version = "~>1.31"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}_rg"
  location = var.location
}

# Create virtual network and three subnets
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_prefix}-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "wansubnet" {
  name                 = "wansubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.10.1.0/24"
}
resource "azurerm_subnet" "lansubnet" {
  name                 = "lansubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.10.2.0/24"
}

# Create public IP for management interface
resource "azurerm_public_ip" "mgmtpip" {
  name                         = "${var.resource_prefix}-mgmtPIP"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  allocation_method            = "Static"
}

# Create public IP for WAN interface
resource "azurerm_public_ip" "wanpip" {
  name                         = "${var.resource_prefix}-wanPIP"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  allocation_method            = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_prefix}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface for netscaler wan
resource "azurerm_network_interface" "wannic" {
  name                      = "${var.resource_prefix}-wannic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
      name                          = "${var.resource_prefix}-mgmtipconfig"
      subnet_id                     = azurerm_subnet.wansubnet.id
      private_ip_address_allocation = "static"
      private_ip_address            = "10.10.1.4"
      public_ip_address_id          = azurerm_public_ip.mgmtpip.id
      primary                       = true
  }

  ip_configuration {
    name                          = "${var.resource_prefix}-wanipconfig"
    subnet_id                     = azurerm_subnet.wansubnet.id
    private_ip_address_allocation = "static"
    private_ip_address            = "10.10.1.5"
    public_ip_address_id          = azurerm_public_ip.wanpip.id
  }
}

# Create network interface for netscaler lan
resource "azurerm_network_interface" "lannic" {
  name                      = "${var.resource_prefix}-lannic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.resource_prefix}-lanipconfig"
    subnet_id                     = azurerm_subnet.lansubnet.id
    private_ip_address_allocation = "static"
    private_ip_address            = "10.10.2.4"
  }
}

# Create Netscaler virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.resource_prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [
    "${azurerm_network_interface.wannic.id}",
    "${azurerm_network_interface.lannic.id}"
  ]
  primary_network_interface_id = azurerm_network_interface.wannic.id
  vm_size               = "Standard_A2"

  storage_image_reference {
    publisher = "citrix"
    offer     = "netscalervpx-130"
    sku       = "netscaler10platinum"
    version   = "130.41.28"
  }

  plan {
    name = "netscaler10platinum"
    publisher = "citrix"
    product = "netscalervpx-130"
  }

storage_os_disk {
    name              = "${var.resource_prefix}OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_prefix}-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "null_resource" "setup_ip" {
  provisioner "local-exec" {
    environment = {
      INITIAL_WAIT_SEC    = "360"
      PUBLIC_NSIP         = azurerm_public_ip.mgmtpip.ip_address
      INSTANCE_PWD        = var.admin_password
      VIP_IPADDR          = "10.10.1.5"
      SNIP_IPADDR         = "10.10.2.4"
      SUBNET_MASK         = "255.255.255.0"
    }

    interpreter = ["bash"]
    command     = "setup_ip.sh"
  }
}
