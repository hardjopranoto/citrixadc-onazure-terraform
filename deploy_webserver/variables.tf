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
  default = "tfdemo"
}

# You'll usually want to set this to a region near you.
variable "location" {
  default = "australiaeast"
}
