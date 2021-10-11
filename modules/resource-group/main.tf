resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "app terraform test"
  }
}
