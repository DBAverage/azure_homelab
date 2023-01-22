data "azurerm_private_dns_zone" "dns-zone-1" {
  name                = var.dns_zone_name
  resource_group_name = var.core_infra_resource_group_name
}

data "azurerm_virtual_network" "network-1" {
  name                = var.network_name
  resource_group_name = var.core_infra_resource_group_name
}

resource "azurerm_resource_group" "resource-1" {
  name     = "${var.app_name}-rg-1"
  location = var.location

  tags = {
    environment = var.app_name
  }
}

resource "azurerm_subnet" "subnet-1" {
  name                                      = "${var.app_name}-endpoint-subnet"
  address_prefixes                          = ["10.0.2.0/24"]
  virtual_network_name                      = data.azurerm_virtual_network.network-1.name
  resource_group_name                       = var.core_infra_resource_group_name
  private_endpoint_network_policies_enabled = true
}