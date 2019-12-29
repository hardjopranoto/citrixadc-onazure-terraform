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

2. Deploy Citrix ADC by running the following commands

```
cd citrixadc-onazure-terraform/deploy_adc
terraform init
terraform plan
terraform apply
```

3. Deploy two Ubuntu linux VMs, install NGINX webserver and customise the HTML page

```
cd citrixadc-onazure-terraform/deploy_webserver
terraform init
terraform plan
terraform apply
```







