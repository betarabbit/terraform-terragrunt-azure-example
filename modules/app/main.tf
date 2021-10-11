resource "azurerm_kubernetes_cluster" "app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                 = "system"
    type                 = "VirtualMachineScaleSets"
    enable_auto_scaling  = true
    node_count           = var.default_node_pool.node_count
    min_count            = var.default_node_pool.min_count
    max_count            = var.default_node_pool.max_count
    vm_size              = var.default_node_pool.vm_size
    os_disk_type         = var.default_node_pool.os_disk_type
    os_disk_size_gb      = var.default_node_pool.os_disk_size_gb
    os_sku               = var.default_node_pool.os_sku
    orchestrator_version = var.default_node_pool.orchestrator_version
    vnet_subnet_id       = var.subnet_id
    availability_zones   = [1, 2, 3]

  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_key
    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "Standard"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
  }

  sku_tier = var.sku_tier

  kubernetes_version = var.kubernetes_version

  tags = {
    environment = "app terraform test"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "app" {
  for_each = var.user_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.app.id
  enable_auto_scaling   = true
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  vm_size               = each.value.vm_size
  os_disk_type          = each.value.os_disk_type
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_sku                = each.value.os_sku
  orchestrator_version  = each.value.orchestrator_version
  vnet_subnet_id        = var.subnet_id
  availability_zones    = [1, 2, 3]

  tags = {
    environment = "app terraform test"
  }
}
