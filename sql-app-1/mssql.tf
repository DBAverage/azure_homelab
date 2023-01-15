resource "azurerm_resource_group" "resource-1" {
  name     = "${var.app_name}-rg-1"
  location = var.location

  tags = {
    environment = var.app_name
  }
}

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