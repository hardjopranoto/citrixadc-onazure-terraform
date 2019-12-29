# This script is currently not working due to possibly az cli bug
resource "null_resource" "vnet_peer" {
  provisioner "local-exec" {
  command = "az network vnet peering create -g tfdemo_rg -n tfdemoVnetTotfnsdemoVnet --vnet-name tfdemo-vnet --remote-vnet tfnsdemo-vnet --allow-vnet-access"
  }
}        
