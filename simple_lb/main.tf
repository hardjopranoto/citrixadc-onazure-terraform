terraform {
  required_version = ">= 0.12"
}

provider "citrixadc" {
  username = "ctxadmin"
  password = "CtxPa55w0rd!"
  endpoint = "http://13.73.203.23/"
}

resource "citrixadc_lbvserver" "production_lb" {
  name        = "productionLB"
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
