variable "location" {
  description = "Location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "main_virtual_network_name" {
  description = "Virtual network name"
}

variable "main_virtual_network_address_space" {
  description = "Virtual network address space"
  type = set(string)
}

variable "app_subnet_name" {
  description = "App subnet name"
}

variable "app_subnet_address_prefixes" {
  description = "App subnet address prefixes"
  type = set(string)
}

variable "app_subnet_security_group_name" {
  description = "App subnet security group name"
}
