/*
* Deploying two Ubuntu Linux VM
* Installing NGINX webserver
* and create a basic webpage
*/



# Configure the provider.
provider "azurerm" {
  version = "~>1.31"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}_rg"
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_prefix}-vnet"
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

# Create public IP
resource "azurerm_public_ip" "publicip" {
  count               = 2
  name                = "${var.resource_prefix}webserver${count.index}-PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  }

data "azurerm_public_ip" "publicip" {
  count               = 2
  name                = azurerm_public_ip.publicip.name[count.index]
  resource_group_name = azurerm_resource_group.rg.name
}


# Create network interface
resource "azurerm_network_interface" "nic" {
  count                     = 2
  name                      = "${var.resource_prefix}webserver${count.index}-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.resource_prefix}webserver${count.index}-nicconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"{
    public_ip_address_id          = azurerm_public_ip.publicip.id[count.index]
  }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  count                 = 2
  name                  = "${var.resource_prefix}webserver${count.index}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS2_v2"

  storage_os_disk {
    name              = "${var.resource_prefix}webserver${count.index}OsDisk"
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
    computer_name  = "${var.resource_prefix}webserver${count.index}-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

# Copying index.html and index.js to the VM
  provisioner "file" {
    connection {
      count    = 2
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
      count    = 2
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
      count    = 2
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
                               
