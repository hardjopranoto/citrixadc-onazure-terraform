# Define the variables and default values to be used for provisioning the Citrix ADC

variable "admin_username" {
  default = "nsroot"
}

variable "admin_password" {
  default = "CtxPa55w0rd!"
}

variable "resource_prefix" {
  default = "cugcdemo"
}

variable "location" {
  default = "australiaeast"
}

variable "mgmt_url" {
  type = string
  default = ""
}

variable "helloworld_url" {
  type = string
  default = ""
}

variable "vnet_range" {
  type = string
  default = "10.8.0.0/16"
}

variable "wan_subnet" {
  type = string
  default = "10.8.1.0/24"
}

variable "lan_subnet" {
  type = string
  default = "10.8.2.0/24"
}

variable "mgmt_ip" {
  type = string
  default = "10.8.1.4"
}

variable "virtual_ip" {
  type = string
  default = "10.8.1.5"
} 
variable "subnet_ip" {
  type = string
  default = "10.8.2.4"
}

variable "netmask" {
  type = string
  default = "255.255.255.0"
}

variable "vm_size" {
  type = string
  default = "Standard_A2"
}

variable "publisher" {
  type = string
  default = "citrix"
}

variable "offer" {
  type = string
  default = "netscalervpx-130"
}

variable "sku" {
  type = string
  default = "netscaler10platinum"
}

variable "ver" {
  type = string
  default = "130.47.24"
}

variable "plan_name" {
  type = string
  default = "netscaler10platinum"
}

variable "plan_product" {
  type = string
  default = "netscalervpx-130"
}
