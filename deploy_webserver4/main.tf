/*
* Deploying Ubuntu Linux VM
* Installing NGINX webserver
* and create a basic webpage
*/


variable "resource_prefix" {
  default = "webserver4"
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
  name     = "tfdemo_rg"
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "tfdemo-vnet"
  address_space       = ["10.11.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "lan-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.11.1.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                         = "webserver4-PublicIP"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  allocation_method = "Static"
  }

data "azurerm_public_ip" "publicip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = azurerm_resource_group.rg.name
}


# Create Network Security Group and rules
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
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "${var.resource_prefix}-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.resource_prefix}-nicconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.resource_prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS2_v2"

  storage_os_disk {
    name              = "${var.resource_prefix}OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.resource_prefix}-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

# Copying index.html and index.js to the VM
  provisioner "file" {
    connection {
      host     = azurerm_public_ip.publicip.ip_address
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
    }

    source      = "index.html"
    destination = "index.html"
  }

  provisioner "file" {
    connection {
      host     = azurerm_public_ip.publicip.ip_address
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
    }

    source      = "index.js"
    destination = "index.js"
  }

# Installing NGINX webserver and moving index.hmtl and index.js to the appropriate directory
  provisioner "remote-exec" {
    connection {
      host     = azurerm_public_ip.publicip.ip_address
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
    }

    inline = [
      "sudo apt update",
      "sudo apt-get -y install nginx",
      "sudo ufw allow 'Nginx HTTP'",
      "sudo ufw status",
      "cd /var/www/html",
      "sudo mkdir javascript",
      "sudo cp ~/index.html .",
      "pwd",
      "sudo rm index.nginx-debian.html",
      "ls -la",
      "cd javascript",
      "sudo cp ~/index.js .",
      "pwd",
      "ls -la"
    ]
  }
}

# Displaying the hostname, public ip, private ip for reference
output hostname {
  value = azurerm_virtual_machine.vm.name
}

output public_ip {
  value = azurerm_public_ip.publicip.ip_address
}

output private_ip {
  value = azurerm_network_interface.nic.private_ip_address
}
output admin_username {
  value = var.admin_username
}

output admin_password {
  value = var.admin_password
}
                                