output "server_name" {
  value = azurerm_mssql_server.sql-server-1.name
}

output "database_name" {
  value = azurerm_mssql_database.sql-database-1.name
}

output "a_record" {
  value = azurerm_private_dns_a_record.a-record.fqdn
}
