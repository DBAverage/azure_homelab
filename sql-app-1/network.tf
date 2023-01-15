resource "azurerm_subnet" "subnet-1" {
  name                                      = var.app_name
  address_prefixes                          = ["10.0.2.0/24"]
  virtual_network_name                      = data.azurerm_virtual_network.network-1.name
  resource_group_name                       = var.core_infra_resource_group_name
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_private_endpoint" "endpoint-1" {
  depends_on          = [azurerm_mssql_server.sql-server-1]
  name                = "${var.app_name}-mssql-endpoint-1"
  location            = azurerm_resource_group.resource-1.location
  resource_group_name = azurerm_resource_group.resource-1.name
  subnet_id           = azurerm_subnet.subnet-1.id

  private_service_connection {
    name                           = "${var.app_name}-mssql-endpoint-connection-1"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql-server-1.id
    subresource_names              = ["sqlServer"]
  }
}

# DB Private Endpoint Connecton
data "azurerm_private_endpoint_connection" "connection" {
  depends_on          = [azurerm_private_endpoint.endpoint-1]
  name                = azurerm_private_endpoint.endpoint-1.name
  resource_group_name = azurerm_resource_group.resource-1.name
}

# Create a DB Private DNS A Record
resource "azurerm_private_dns_a_record" "a-record" {
  depends_on          = [azurerm_mssql_server.sql-server-1]
  name                = lower(azurerm_mssql_server.sql-server-1.name)
  zone_name           = data.azurerm_private_dns_zone.dns-zone-1.name
  resource_group_name = var.core_infra_resource_group_name
  ttl                 = 15000
  records             = [data.azurerm_private_endpoint_connection.connection.private_service_connection.0.private_ip_address]
}
