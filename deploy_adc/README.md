# Step 2 - Deploy Citrix ADC
This subfolder contains specific example of deploying Citrix ADC in Azure using Terraform

## Structure
- `main.tf` is used to specify the variables, providers and resources required to deploy Citrix ADC VM in Azure. The file also contains the following variables that you can customise:
  - *admin_username* is the admin username for the Citrix ADC
  - *admin_password* is the admin password for the Citrix ADC
  - *resource_prefix* is the name that will be used as the name in creating the azure resource group, virtual network and virtual machine
  - *location* is the azure region that the Citrix ADC will be deployed
- `setup_ip.sh` is a bash script used to create a VIP and a SNIP address on the Citrix ADC

## Usage

1. `terraform init`
2. `terraform plan`
3. `teraform apply`
