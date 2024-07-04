
resource "azurerm_container_group" "this" {
  name                = var.container_group_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  ip_address_type     = "Public"
  dns_name_label      = "jenkins-master"
  os_type             = "Linux"

  container {
    name   = "jenkins-master"
    image  = "armkiyas/jenkins:latest"
    cpu    = "2"
    memory = "3.0"
    ports {
      port     = 8080
      protocol = "TCP"
    }
    ports {
      port     = 50000
      protocol = "TCP"
    }
    ports {
      port     = 8081
      protocol = "TCP"
    }
    volume {
      name                 = "jenkins-logs"
      mount_path           = "/var/jenkins_home/logs"
      storage_account_name = azurerm_storage_account.this.name
      storage_account_key  = azurerm_storage_account.this.primary_access_key
      share_name           = azurerm_storage_share.this-share.name

    }
    volume {
      name                 = "jenkins-cache"
      mount_path           = "/var/jenkins_home/cache"
      storage_account_name = azurerm_storage_account.this.name
      storage_account_key  = azurerm_storage_account.this.primary_access_key
      share_name           = azurerm_storage_share.this-share.name
    }

    volume {
      name                 = "jenkins-jobs"
      mount_path           = "/var/jenkins_home/jobs"
      storage_account_name = azurerm_storage_account.this.name
      storage_account_key  = azurerm_storage_account.this.primary_access_key
      share_name           = azurerm_storage_share.this-share.name
    }
    volume {
      name                 = "jenkins-job-data"
      mount_path           = "/var/jenkins_home/jenkins-jobs"
      storage_account_name = azurerm_storage_account.this.name
      storage_account_key  = azurerm_storage_account.this.primary_access_key
      share_name           = azurerm_storage_share.this-share.name
    }
    volume {
      name                 = "jenkins-secrets"
      mount_path           = "/var/jenkins_home/secrets"
      storage_account_name = azurerm_storage_account.this.name
      storage_account_key  = azurerm_storage_account.this.primary_access_key
      share_name           = azurerm_storage_share.this-share.name
    }

  }

  tags = {
    environment = var.env
  }




}
