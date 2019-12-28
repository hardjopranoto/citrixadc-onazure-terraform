resource "null_resource" "vnet_peer" {
  provisioner "local-exec" {
  command = <<EOT
    az network vnet peering create
      --name peer-tfdemo-to-tfnsdemo
      --resource-group tfdemo_rg
      --vnet-name tfdemo-vnet
      --remote-vnet tfnsdemo-vnet
      --allow-vnet-access
      --subscription eebeec37-91ca-43f9-a46b-1cd65dfcc8e7
  EOT
  }
}        
