
resource "azurerm_container_group" "this" {
  name                = var.container_group_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  ip_address_type     = "Public"
  dns_name_label      = "jenkins-kiyas-cloud-master"
  os_type             = "Linux"


  image_registry_credential {
    username = var.username
    password = var.password
    server   = "index.docker.io"
  }

  exposed_port = [
    {
      port     = 80
      protocol = "TCP"
    },
    {
      port     = 443
      protocol = "TCP"
    }
  ]

  container {
    name   = "jenkins-master"
    image  = var.image
    cpu    = "2"
    memory = "4.0"
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


    secure_environment_variables = {
      JENKINS_ADMIN_PASSWORD = var.jenkins_admin_password

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

  container {
    name   = "caddy"
    image  = "caddy"
    cpu    = "0.5"
    memory = "0.5"


    ports {
      port     = 80
      protocol = "TCP"
    }
    ports {
      port     = 443
      protocol = "TCP"
    }

    volume {
      name                 = "aci-caddy-data"
      mount_path           = "/data"
      storage_account_key  = azurerm_storage_account.this.primary_access_key
      storage_account_name = azurerm_storage_account.this.name
      share_name           = azurerm_storage_share.caddy-share.name
    }

    commands = ["caddy", "reverse-proxy", "--from", "jenkins-kiyas-cloud-master.eastus.azurecontainer.io", "--to", "localhost:8080"]

  }


  tags = {
    environment = var.env
  }




}
