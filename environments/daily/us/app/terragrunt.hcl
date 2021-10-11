include {
  path = find_in_parent_folders()
}

locals {
  kubernetes_version = "1.19.11"
  name               = "app-terraform-test"
}

dependency "networking" {
  config_path = "../networking"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    app_subnet_id = "fake-app-subnet-id"
  }
}

dependencies {
  paths = ["../networking", "../resource-group"]
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules//app"
}

inputs = {
  name               = local.name
  dns_prefix         = local.name
  ssh_key            = file("~/.ssh/id_rsa.pub")
  sku_tier           = "Free"
  subnet_id          = dependency.networking.outputs.app_subnet_id
  kubernetes_version = local.kubernetes_version
  default_node_pool = {
    node_count           = 2
    min_count            = 2
    max_count            = 5
    vm_size              = "Standard_D2s_v3"
    os_disk_type         = "Managed"
    os_disk_size_gb      = 100
    os_sku               = "Ubuntu"
    orchestrator_version = local.kubernetes_version
  }
  user_node_pools = {
    managerpool = {
      name                 = "managerpool"
      node_count           = 3
      min_count            = 3
      max_count            = 10
      vm_size              = "Standard_D4s_v3"
      os_disk_type         = "Managed"
      os_disk_size_gb      = 100
      os_sku               = "Ubuntu"
      orchestrator_version = local.kubernetes_version
    }
    workerpool = {
      name                 = "managerpool"
      node_count           = 2
      min_count            = 2
      max_count            = 10
      vm_size              = "Standard_L16s_v2"
      os_disk_type         = "Managed"
      os_disk_size_gb      = 100
      os_sku               = "Ubuntu"
      orchestrator_version = local.kubernetes_version
    }
  }
}
