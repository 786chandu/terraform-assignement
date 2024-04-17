output "postgresql_db_name" {
  value = azurerm_postgresql_flexible_server.postgresql-server.administrator_login
}

output "postgresql_db_password" {
  value = azurerm_postgresql_flexible_server.postgresql-server.administrator_password
}

output "postgresql_db_fdqn" {
  value = azurerm_postgresql_flexible_server.postgresql-server.fqdn
}

output "postgresql_db_username" {
  value = azurerm_postgresql_flexible_server_database.pgdb-creation.name
}