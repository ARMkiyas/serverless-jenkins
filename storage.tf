


resource "random_string" "storage_name_mask" {
  length  = 4
  special = false
  upper   = false

}


resource "azurerm_storage_account" "this" {
  name                     = "cloudcarestorage${random_string.storage_name_mask.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  tags = {
    environment = var.env
  }
}



resource "azurerm_storage_share" "this-share" {
    name                 = "jenkins-share"
    storage_account_name = azurerm_storage_account.this.name
    quota = 50
}
