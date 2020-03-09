# Defining the variables for admin_username and admin_password for the VM
# You may change this to your own admin username and password
# Resource prefix name will be prompted during run time

variable "admin_username" {
  type = string
  default = "localadmin"
}

variable "admin_password" {
  type = string
  default = "C0mpl3xPa55w0rd!"
}

variable "resource_prefix" {
  type = string
  default = "cugc"
}

# You'll usually want to set this to a region near you.
variable "location" {
  default = "australiaeast"
}

variable "vnet_range" {
  type = string
  default = "10.12.0.0/16"
}

variable "lan_subnet" {
  type = string
  default = "10.12.1.0/24"
}

variable "vm_size" {
  type = string
  default = "Standard_DS2_v2"
}

variable "publisher" {
  type = string
  default = "Canonical"
}

variable "offer" {
  type = string
  default = "UbuntuServer"
}

variable "sku" {
  type = string
  default = "18_04-lts-gen2"
}

variable "ver" {
  type = string
  default = "latest"
}