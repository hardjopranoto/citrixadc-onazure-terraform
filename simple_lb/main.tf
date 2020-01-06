terraform {
  required_version = ">= 0.12"
}

variable "adcmgmt_ip" {
    type = string
}

provider "citrixadc" {
  username = "nsroot"
  password = "CtxPa55w0rd!"
  endpoint = "http://${var.adcmgmt_ip}"
}

resource "citrixadc_lbvserver" "production_lb" {
  name        = "helloworldLB"
  ipv46       = var.vip_config["vip"]
  port        = "80"
  servicetype = "HTTP"
}

resource "citrixadc_servicegroup" "backend" {
  servicegroupname = "productionBackend"
  lbvservers       = [citrixadc_lbvserver.production_lb.name]
  servicetype      = "HTTP"
  clttimeout       = var.backend_service_config["clttimeout"]
  servicegroupmembers = formatlist(
    "%s:%s",
    var.backend_services,
    var.backend_service_config["backend_port"],
  )
}
