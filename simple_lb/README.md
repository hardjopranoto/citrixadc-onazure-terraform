# Step 5 - Create Simple Load Balance Configuration in Citrix ADC
This subfolder contains specific example of configuring a simple load balance configuration in Citrix ADC using Terraform with Citrix ADC provider

## Requirements
[Terraform Provider for Citrix ADC](https://github.com/citrix/terraform-provider-citrixadc) must be deployed locally in your environment

## Structure
- `terraform.tfvars` has the variable inputs specified in `variables.tf`
- `variables.tf` describes the input variables to the terraform config
- `main.tf` is used to specify the  providers and resources required

## Usage

1. Obtain the Citrix ADC management interface public IP address 

```
az network public-ip show -g tfnsdemo_rg -n tfnsdemo-mgmtPIP 

(lines removed for brevity)
  "ddosSettings": null,
  "dnsSettings": null,
  "etag": "W/\"731df655-ba5e-46dc-9e8c-ae5618096a2c\"",
  "id": "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tfnsdemo_rg/providers/Microsoft.Network/publicIPAddresses/tfnsdemo-mgmtPIP",
  "idleTimeoutInMinutes": 4,
  "ipAddress": "a.b.c.d",
  "ipConfiguration": {
    "etag": null,
(lines removed for brevity)
```

Where `a.b.c.d` is the value of the assigned public IP address for Citrix ADC management

2. `terraform plan`
3. `teraform apply`