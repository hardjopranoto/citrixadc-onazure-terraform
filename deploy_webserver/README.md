# Step 3 - Deploy Two Webservers
This subfolder contains specific example of deploying two Ubuntu Linux VMs, install NGINX webserver and customising the default HTML page

## Structure
- `variables.tf` contains the following variables that you can customise
  - *admin_username* is the admin username for the Linux servers
  - *admin_password* is the admin password for the Linux servers
  - *resource_prefix* is the name that will be used as the name in creating the azure resource group, virtual network and virtual machine. The default is set to `tfdemo`
  - *location* is the azure region that the Linux servers will be deployed
- `main.tf` is used to specify the  providers and resources required to deploy the two Linux VMs
- `index.html` is the customised version of the webpage that will be installed on the webservers
- `index.js` is a simple javascript file that make up the `index.html` file mentioned above.

## Usage

1. `terraform init`
2. `terraform plan`
3. `teraform apply`
