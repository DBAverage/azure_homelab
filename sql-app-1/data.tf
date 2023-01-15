data "azurerm_private_dns_zone" "dns-zone-1" {
  name                = var.dns_zone_name
  resource_group_name = var.core_infra_resource_group_name
}

data "azurerm_virtual_network" "network-1" {
  name                = var.network_name
  resource_group_name = var.core_infra_resource_group_name
}
