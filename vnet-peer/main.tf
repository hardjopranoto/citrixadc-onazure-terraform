provisioner "local-exec" {
  command = <<EOT
    az network vnet peering create
      --name "peer-${var.resource1_prefix}-to-${var.resource2_prefix}""
      --resource-group "${var.resource1_prefix}_rg"
      --vnet-name "${var.resource1_prefix}-vnet"
      --remote-vnet "${var.resource2_prefix}-vnet
      --allow-vnet-access
      --subscription ${var.subscription_id}
EOT
}        
