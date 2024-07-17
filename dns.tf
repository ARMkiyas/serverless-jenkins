
module "dns_record" {
  source = "github.com/ARMkiyas/terraform-az-dns-module"

  resource_group_name = var.dns_resource_group
  zone_name           = var.dns-zone
  create_dns_zone     = var.create_dns_zone




  a_records = var.use_vm ? [
    {
      name    = var.subdomain
      ttl     = 300
      records = [azurerm_linux_virtual_machine.this[0].public_ip_address]
    },
  ] : []

  cname_records = var.use_vm ? [] : [
    {
      name   = var.subdomain
      ttl    = 300
      record = azurerm_container_group.this[0].fqdn
    },
  ]



}


