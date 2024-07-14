


resource "random_string" "storage_name_mask" {
  length  = 4
  special = false
  upper   = false

}


resource "azurerm_storage_account" "this" {
  count = var.use_vm ? 0 : 1

  name                     = "cloudcarestorage${random_string.storage_name_mask.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type






  tags = {
    environment = var.env
  }
}



resource "azurerm_storage_share" "jenkins-logs-share" {



  count = var.use_vm ? 0 : 1

  name                 = "jenkins-logs-share"
  storage_account_name = azurerm_storage_account.this[0].name
  quota                = 10


  depends_on = [azurerm_storage_account.this]
}


resource "azurerm_storage_share" "jenkins-cache-share" {

  count = var.use_vm ? 0 : 1

  name                 = "jenkins-cache-share"
  storage_account_name = azurerm_storage_account.this[0].name
  quota                = 10


  depends_on = [azurerm_storage_account.this]


}





resource "azurerm_storage_share" "jenkins-jobs-share" {

  count = var.use_vm ? 0 : 1

  name                 = "jenkins-jobs-share"
  storage_account_name = azurerm_storage_account.this[0].name
  quota                = 10


  depends_on = [azurerm_storage_account.this]
}

resource "azurerm_storage_share" "jenkins-job-data-share" {

  count = var.use_vm ? 0 : 1

  name                 = "jenkins-job-data-share"
  storage_account_name = azurerm_storage_account.this[0].name
  quota                = 10


  depends_on = [azurerm_storage_account.this]
}


resource "azurerm_storage_share" "jenkins-secrets-share" {

  count = var.use_vm ? 0 : 1

  name                 = "jenkins-secrets-share"
  storage_account_name = azurerm_storage_account.this[0].name
  quota                = 10


  depends_on = [azurerm_storage_account.this]
}
resource "azurerm_storage_share" "jenkins-workspace-share" {

  count = var.use_vm ? 0 : 1

  name                 = "jenkins-workspace-share"
  storage_account_name = azurerm_storage_account.this[0].name
  quota                = 10


  depends_on = [azurerm_storage_account.this]
}


resource "azurerm_storage_share" "caddy-share" {
  count                = var.use_vm ? 0 : 1
  name                 = "caddy-share"
  storage_account_name = azurerm_storage_account.this[0].name
  quota                = 1


  depends_on = [azurerm_storage_account.this]
}


