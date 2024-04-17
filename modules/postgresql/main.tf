#-------------------------------
#   Random Password Generator
#-------------------------------

resource "random_password" "passwd" {
 length = 12
  min_upper = 1 
  min_lower = 2
  min_numeric = 4
  special = false 

  keepers = {
    admin_password = var.postgresqlserver_name
  }
}

#-----------------------------
# Resource Group
#-----------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#-------------------------------
# Private DNS Zone
#-------------------------------

resource "azurerm_private_dns_zone" "postgres_zone" {
  name = var.postgresql_private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.rg.name
  
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_pvnl" {
  name = "${var.postgresql_private_dns_zone_name}-pvnl"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_zone.name
  virtual_network_id = var.virtual_network_vnet_id
  resource_group_name = data.azurerm_resource_group.rg.name
}

#----------------------------------
#   Postgresql Server
#----------------------------------
resource "azurerm_postgresql_flexible_server" "postgresql-server" {
  name =  var.postgresqlserver_name
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  #zone = var.postgresql_zone
  administrator_login = var.postgresql_user_name
  administrator_password = random_password.passwd.result
  private_dns_zone_id = azurerm_private_dns_zone.postgres_zone.id
  delegated_subnet_id = var.delegated_subnet_id
  sku_name = var.postgresql_sku
  version = var.postgresql_version
  storage_mb = var.postgresql_storage_inmb
  backup_retention_days = var.postgresql_backup_retention_days
  geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup_enabled
  create_mode = var.create_mode

}

#--------------------------------------
#  Postgresql Server Configuration
#--------------------------------------
resource "azurerm_postgresql_flexible_server_configuration" "postgresql-server-configuration" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.postgresql-server.id
  value     = "CUBE,CITEXT,BTREE_GIST"
}

#---------------------------------------
#  Postgresql Database Creation
#---------------------------------------
resource "azurerm_postgresql_flexible_server_database" "pgdb-creation" {
  name = var.postgresql_db_name
  server_id = azurerm_postgresql_flexible_server.postgresql-server.id
  charset = "UTF8"
  collation = "en_US.utf8"
}