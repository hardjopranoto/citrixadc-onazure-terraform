# Deploying Citrix ADC on Azure with Terraform

## Introduction
This is a sample infrastructure-as-code project to showcase the deployment of Citrix ADC in Microsoft Azure using terraform. As part of this, two Linux Ubuntu running NGINX webserver will be provisioned and they will be load balanced by the Citrix ADC.

![Citrix ADC on Azure](https://github.com/hardjopranoto/citrixadc-onazure-terraform/blob/master/citrixadc-onazure-terraform.png)

## Requirements
- Terraform
- Azure subscription
- [Terraform Provider for Citrix ADC](https://github.com/citrix/terraform-provider-citrixadc)
- Azure Cloud Shell (optional)

In order to use this repository, you will need to deploy the above listed tools. We will use Terraform to provision Citrix ADC from Azure Marketplace (it is assumed that you have your Azure subscription that you can use). You can deploy Terraform tool on a Linux server or alternatively you can use Azure Cloud Shell.

I personally like to use the Azure Cloud Shell for the convenience that Terraform is already installed and it is maintained and kept up to date by Microsoft. Please follow this instruction to set up Azure Cloud Shell for the first time. https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart

You also need to copy the [Terraform Provider for Citrix ADC](https://github.com/citrix/terraform-provider-citrixadc) binary to your Azure Cloud Shell by following the usage instruction.

## Usage

1. Open Azure Cloud Shell and clone this repository by running the following commands

`git clone https://github.com/hardjopranoto/citrixadc-onazure-terraform.git`

2. Deploy Citrix ADC by following this [instruction](https://github.com/hardjopranoto/citrixadc-onazure-terraform/blob/master/deploy_adc)

3. Deploy two Ubuntu linux VMs, install NGINX webserver and customise the HTML page by following this [instruction](https://github.com/hardjopranoto/citrixadc-onazure-terraform/tree/master/deploy_webserver)

4. Create vnet peering between tfdemo-vnet and tfnsdemo-vnet. Follow this instruction on [how to create vnet peering using Azure portal](https://docs.microsoft.com/en-us/azure/virtual-network/quick-create-portal)

5. Create a simple load balancing configuration on the two webservers deployed in Step 3 by following this [instruction](https://github.com/hardjopranoto/citrixadc-onazure-terraform/tree/master/simple_lb)

6. Commit the configuration to Citrix ADC persistent store. To do that, run the following commands

```
export NS_URL=http://<host>:<port>/
export NS_USER=nsroot
export NS_PASSWORD=nspassword
./ns_commit.sh
```


## Validate
Run through the following steps to validate if the deployments have been done correctly and successfully

1. Run `az network public-ip show -g tfnsdemo_rg -n tfnsdemo-wanPIP` to obtain `a.b.c.d` which is the public VIP address

```
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

2. Open your browser and point it to `http://a.b.c.d` and you should see the following page being displayed

![Hello World!](https://github.com/hardjopranoto/citrixadc-onazure-terraform/blob/master/helloworld.png)








