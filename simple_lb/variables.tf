vip_config = {
  vip = "10.10.1.5"
}

backend_service_config = {
  clttimeout   = 40
  backend_port = 80
}

backend_services = [
  "10.11.1.4",
  "10.11.1.5",
]

variable "location" {
  default = "australiaeast"
}
