# Step 5 - Create Simple Load Balance Configuration in Citrix ADC
This subfolder contains specific example of configuring a simple load balance configuration in Citrix ADC using Terraform with Citrix ADC provider

## Requirements
[Terraform Provider for Citrix ADC](https://github.com/citrix/terraform-provider-citrixadc) must be deployed locally in your environment

## Structure
- `terraform.tfvars` has the variable inputs specified in `variables.tf`
- `variables.tf` describes the input variables to the terraform config
- `main.tf` is used to specify the  providers and resources required

## Usage

1. Run the following command in Azure Cloud Shell to get Citrix ADC Management IP and export it into Terraform variable

`export TF_VAR_adcmgmt_ip=$(az network public-ip show -g tfnsdemo_rg -n tfnsdemo-mgmtPIP --query ipAddress --output tsv)`

2. `terraform init`
3. `terraform plan`
4. `teraform apply`