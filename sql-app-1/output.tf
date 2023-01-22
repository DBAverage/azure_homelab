output "mssql_server_name" {
  value = azurerm_mssql_server.sql-server-1.name
}

output "mssql_database_name" {
  value = azurerm_mssql_database.sql-database-1.name
}

output "mssql_fqdn" {
  value = azurerm_private_dns_a_record.a-record.fqdn
}


# output "app_service" {
#   value = azurerm_linux_web_app.app-1
# }