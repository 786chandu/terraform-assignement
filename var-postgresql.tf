# variable "postgresql_zone" {}
variable "postgresql_user_name" {}
variable "postgresql_sku" {}
variable "postgresql_version" {}
variable "postgresql_storage_inmb" {}
variable "postgresql_backup_retention_days" {}
variable "postgresql_geo_redundant_backup_enabled" {
    type = bool
}
variable "create_mode" {}
variable "postgresql_db_name" {}
variable "postgresql_private_dns_zone_name" {}