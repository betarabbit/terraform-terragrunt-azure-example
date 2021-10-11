variable "location" {
  description = "Location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "name" {
  description = "App AKS cluster name"
}

variable "dns_prefix" {
  description = "App AKS DNS prefix"
}

variable "client_id" {
  description = "Azure service principal ID"
}

variable "client_secret" {
  description = "Azure service pricipal password"
  sensitive   = true
}

variable "ssh_key" {
  description = "App AKS cluster SSH key"
  sensitive   = true
}

variable "service_cidr" {
  description = "Service CIDR"
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS service IP"
  default     = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "Docker bridge CIDR"
  default     = "172.17.0.1/16"
}

variable "subnet_id" {
  description = "App AKS subnet ID"
}

variable "sku_tier" {
  description = "App AKS cluster SKU tier"
}

variable "kubernetes_version" {
  description = "App AKS cluster Kubernetes version"
}

variable "default_node_pool" {
  description = "App AKS cluster system node pool config"

  type = object({
    node_count           = number
    min_count            = number
    max_count            = number
    os_disk_type         = string
    os_disk_size_gb      = number
    vm_size              = string
    orchestrator_version = string
    os_sku               = string
  })
}

variable "user_node_pools" {
  description = "App AKS cluster user node pools config"

  type = map(object({
    name                 = string
    node_count           = number
    min_count            = number
    max_count            = number
    os_disk_type         = string
    os_disk_size_gb      = number
    vm_size              = string
    orchestrator_version = string
    os_sku               = string
  }))
}
