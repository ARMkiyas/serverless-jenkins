output "ip" {

  value = var.use_vm ? azurerm_linux_virtual_machine.this[0].public_ip_address : azurerm_container_group.this[0].ip_address


}



output "fqdn" {

  value = var.use_vm ? "${var.subdomain}.${var.dns-zone}" : azurerm_container_group.this[0].fqdn

}
