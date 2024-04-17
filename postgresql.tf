module "postgresql" {
  source = "./modules/postgresql"
  resource_group_name = data.azurerm_resource_group.rg.name
  postgresqlserver_name = "${var.application}-${var.environment}"
  location      = var.virtual_network_location
#   postgresql_zone = var.postgresql_zone
  postgresql_user_name = var.postgresql_user_name
  delegated_subnet_id = module.network1.private_subnet3_id
  postgresql_sku  = var.postgresql_sku
  postgresql_version = var.postgresql_version
  postgresql_storage_inmb = var.postgresql_storage_inmb
  postgresql_backup_retention_days = var.postgresql_backup_retention_days
  postgresql_geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup_enabled
  create_mode         = var.create_mode
  postgresql_db_name  = var.postgresql_db_name
  postgresql_private_dns_zone_name = var.postgresql_private_dns_zone_name
  virtual_network_vnet_id = module.network1.vnet_id
}

output "postgresql" {
  value = module.postgresql
}