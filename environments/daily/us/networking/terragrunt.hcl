include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../resource-group"]
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules//networking"
}

inputs = {
  main_virtual_network_name          = "vnetAppTerraformTest"
  main_virtual_network_address_space = ["10.151.0.0/16"]
  app_subnet_name                  = "appTerraformTestSubnet"
  app_subnet_address_prefixes      = ["10.151.0.0/21"]
  app_subnet_security_group_name   = "nsgAppTerraformTest"
}
