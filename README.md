# Pre-requisites
## Install
Install [Terraform](https://www.terraform.io/) and [Terragrunt](https://terragrunt.gruntwork.io/).

## Prepare remote state store
We use azure blob storage container as a Terraform backend to store your Terraform state.

Prepare resource group/storage account/container and update `deployment_storage_resource_group_name` and `deployment_storage_account_name` in each site's `site.hcl`. 

## Provide Azure credentials
Provide your Azure service principal credentials via either CI/CD pipeline like Jenkins or local env file. 

The following environment variables are required:
1. `SERVICE_PRINCIPAL_USR`
2. `SERVICE_PRINCIPAL_PSW`
3. `TENANT_ID`
4. `SUBSCRIPTION_ID`

## Prepare environment/site level variables
Fill in environment/site level variables in `env.hcl` and `site.hcl` respectively.

### Sample

`environments/daily/env.hcl`
```
locals {
  env_name        = "Daily"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
}
```
`environments/daily/us/site.hcl`
```
locals {
  site_name                              = "US"
  location                               = "East US 2"
  resource_group_name                    = "terraform-test"
  deployment_storage_resource_group_name = "deployment"
  deployment_storage_account_name        = "deploymentstate"
}
```

# Code structure
The code in this repo uses the following folder hierarchy:
```
├── environments
│   ├── <environment>
│   │   ├── env.hcl
│   │   └── <site>
│   │       ├── site.hcl
│   │       ├── <resource>
│   │       │   └── terragrunt.hcl
├── modules
│   ├── <resource>
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
├── scripts
│   ├── deploy.sh
│   └── destroy.sh
└── terragrunt.hcl

```
where:
- **Environment**: Each environment represents an Azure subscription, like `daily`, `staging`, `production` etc. Environment level variables are defined in `env.hcl`.
- **Site**: Typically, site is a region within one particualar subscription, there is also some exceptions, like 2 sites are both in the same region but for different use cases. Site level variables are defined in `site.hcl`.
- **Resource**: Resource is a single or a collection of Azure resources, like resource group/AKS cluster etc.

## Environments vs Modules
Environments shoud only contain variable definitions for different environments. All common configurations like provider/backend are in the root `terragrunt.hcl`, it makes Terraform code DRY.

While, modules, is the actual Terraform module for one particular resource.

With this approach, copy/paste between environments is minimized. The `terragrunt.hcl` files contain solely the source path of the module to deploy and the inputs to set for that module in the current environment. To create a new environment, you copy an old one and update just the environment-specific inputs in the `terragrunt.hcl` files, which is about as close to the “essential complexity” of the problem as you can get.

## Advantages
Thanks to Terragrunt (a thin wrapper of Terraform), we can have all the following advantages without many home-made scripts:
1. DRY Terraform code and immutable infrastructure
2. DRY provider and remote state configuration
3. Run Terraform commands on multiple modules at once in a proper dependencies order
4. Auto-init and auto-retry

# Deployment
## Deploy
```
Infrastructure deployment:
    -e (Required) environment name (daily, staging, production, etc)
    -s (Required) site name (us, eu, etc)
    -c (Optional) component name (app, networking, resource-group, etc), omit this to deploy all components
    -p (Optional) plan only, do not deploy
```
Sample
```sh
bash ./scripts/deploy.sh -e daily -s us -c resource-group
```
> Make sure you have set required environment variables properly.
## Destroy
```
Infrastructure destroy:
    -e (Required) environment name (daily, staging, production, etc)
    -s (Required) site name (us, eu, etc)
    -c (Optional) component name (app, networking, resource-group, etc), omit this to deploy all components
```
Sample
```sh
bash ./scripts/destroy.sh -e daily -s us -c resource-group
```
> Make sure you have set required environment variables properly.
