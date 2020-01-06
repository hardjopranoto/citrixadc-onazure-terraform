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

0. If you are going to do this lab for the first time, you need to accept Azure Marketplace Legal Terms. You only need to do this once by running the following command in Azure Cloud Shell

`az vm image terms accept --urn citrix:netscalervpx-130:netscaler10enterprise:130.41.28`

1. In Azure Cloud Shell, clone this repository by running the following commands

`git clone https://github.com/hardjopranoto/citrixadc-onazure-terraform.git`

2. Deploy Citrix ADC by following this [instruction](https://github.com/hardjopranoto/citrixadc-onazure-terraform/blob/master/deploy_adc)

3. Deploy two Ubuntu linux VMs, install NGINX webserver and customise the HTML page by following this [instruction](https://github.com/hardjopranoto/citrixadc-onazure-terraform/tree/master/deploy_webserver)

4. Create vnet peering between tfdemo-vnet and tfnsdemo-vnet by running the following commands in Azure Cloud Shell

```
vNet1Id=$(az network vnet show \
  --resource-group tfdemo_rg \
  --name tfdemo-vnet \
  --query id --out tsv)
```

```
vNet2Id=$(az network vnet show \
  --resource-group tfnsdemo_rg \
  --name tfnsdemo-vnet \
  --query id --out tsv)
```

```
az network vnet peering create \
  --name tfdemovnet-tfnsdemovnet \
  --resource-group tfdemo_rg \
  --vnet-name tfdemo-vnet \
  --remote-vnet $vNet2Id \
  --allow-vnet-access
```

```
az network vnet peering create \
  --name tfnsdemovnet-tfdemovnet \
  --resource-group tfnsdemo_rg \
  --vnet-name tfnsdemo-vnet \
  --remote-vnet $vNet1Id \
  --allow-vnet-access
```


5. Create a simple load balancing configuration on the two webservers deployed in Step 3 by following this [instruction](https://github.com/hardjopranoto/citrixadc-onazure-terraform/tree/master/simple_lb)

6. Commit the configuration to Citrix ADC persistent store by running the following commands in Azure Cloud Shell

```
pip=$(az network public-ip show -g tfnsdemo_rg -n tfnsdemo-mgmtPIP --query ipAddress  --out tsv)
export NS_URL=http://$pip/
export NS_USER=nsroot
export NS_PASSWORD=nspassword
./ns_commit.sh
```


## Validate
Run through the following steps to validate if the deployments have been done correctly and successfully

1. Run the following commands to obtain the Citrix ADC VIP address

```
vip=$(az network public-ip show -g tfnsdemo_rg -n tfnsdemo-wanPIP --query ipAddress --out tsv)
echo $vip
```

2. Open your browser and point it to `http://a.b.c.d` where a.b.c.d is the value of the $vip from the step above, and you should see the following page being displayed

![Hello World!](https://github.com/hardjopranoto/citrixadc-onazure-terraform/blob/master/helloworld.png)








