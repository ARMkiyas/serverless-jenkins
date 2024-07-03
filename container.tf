
resource "azurerm_container_group" "this" {
  name                = var.container_group_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  ip_address_type     = "Public"
  dns_name_label      = "jenkins-master"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "2"
    memory = "4.0"
    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  tags = {
    environment = var.env
  }


}
