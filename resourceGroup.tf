
resource "azurerm_resource_group" "this" {
  name     = var.resGroup
  location = var.location
  tags = {
    environment = var.env
  }
}
