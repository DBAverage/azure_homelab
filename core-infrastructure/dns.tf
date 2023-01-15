resource "azurerm_private_dns_zone" "dns-zone-1" {
  name                = "mssql.mushroomkingdom.io"
  resource_group_name = azurerm_resource_group.resource-1.name
}

resource "azurerm_private_dns_zone" "dns-zone-2" {
  name                = "mssql.database.windows.net"
  resource_group_name = azurerm_resource_group.resource-1.name
}

# link vnet to dns zone
resource "azurerm_private_dns_zone_virtual_network_link" "dns-link-1" {
  name                  = "mssql-vnet-link-1"
  resource_group_name   = azurerm_resource_group.resource-1.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone-1.name
  virtual_network_id    = azurerm_virtual_network.network-1.id
  registration_enabled  = true
}

# link vnet to dns zone
resource "azurerm_private_dns_zone_virtual_network_link" "dns-zone-to-vnet-link" {
  name                  = "mssql-db-vnet-link"
  resource_group_name   = azurerm_resource_group.resource-1.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone-2.name
  virtual_network_id    = azurerm_virtual_network.network-1.id
}


resource "azurerm_private_dns_resolver" "private_dns_resolver" {
  name                = "private_dns_resolver"
  resource_group_name = azurerm_resource_group.resource-1.name
  location            = azurerm_resource_group.resource-1.location
  virtual_network_id  = azurerm_virtual_network.network-1.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "dns_inbound_endpoint" {
  name                    = "dns-resolver-1"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = azurerm_private_dns_resolver.private_dns_resolver.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet-18.id
  }
}