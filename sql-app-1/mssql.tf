# Create the SQL Server 
resource "azurerm_mssql_server" "sql-server-1" {
  name                          = "${var.app_name}-mssql-instance-1" #NOTE: globally unique
  resource_group_name           = azurerm_resource_group.resource-1.name
  location                      = azurerm_resource_group.resource-1.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_user
  administrator_login_password  = var.sql_admin_pass
  public_network_access_enabled = false
}


resource "azurerm_mssql_database" "sql-database-1" {
  depends_on = [azurerm_mssql_server.sql-server-1]

  name                        = "mssql-db-1"
  server_id                   = azurerm_mssql_server.sql-server-1.id
  sku_name                    = "GP_S_Gen5_2"
  zone_redundant              = false
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5
}
# test-netconnection homelab-sql-server-instance-1.database.windows.net -port 1433

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
