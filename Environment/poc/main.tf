module "poc" {
  source              = "../.."
  resource_group_name = "task-test-rg"
  environment = "poc"
  application = "assignment"

  # First Virtual Network
  first_virtualnetwork_name          = "vnet1"
  virtual_network_location = "australiacentral"
  first_virtualnetwork_address_space = "10.0.0.0/16"
  first_public_subnet_cidr           = "10.0.0.0/18"
  first_private_subnet1_cidr         = "10.0.64.0/18"
  first_private_subnet2_cidr         = "10.0.128.0/18"
  first_private_subnet3_cidr         = "10.0.192.0/18"

  # Second Virtual Network
#   second_virtualnetwork_name          = "vnet2"
#   second_virtualnetwork_address_space = "11.0.0.0/16"
#   second_public_subnet_cidr           = "11.0.0.0/18"
#   second_private_subnet1_cidr         = "11.0.64.0/18"
#   second_private_subnet2_cidr         = "11.0.128.0/18"

  #First Virtual Machine
  first_vm_name                      = "poctask1"
  first_vm_size                      = "Standard_B1s"

  #Second Virtual Machine
  second_vm_name                    = "poctask2"
  second_vm_size                      = "Standard_B1s"

  #Jumphost Virtual Machine
  jumphost_username                 = "azureadmin"
  jumphost_vm_name                  = "jumhostpoc"
  jumphost_vm_size                  = "Standard_B1s"

  #Postgresql Settings
#   postgresql_zone                  = 3
  postgresql_user_name             = "pgadmin"
  postgresql_sku                   = "B_Standard_B1ms" 
  postgresql_version               = "11"
  postgresql_storage_inmb          = "32768" 
  postgresql_backup_retention_days = "7"
  postgresql_geo_redundant_backup_enabled = false
  create_mode                      = "Default"
  postgresql_db_name               = "postgres"
  postgresql_private_dns_zone_name = "postgreszone.com"
}

output "outputs" {
  value = module.poc
  sensitive = true
}
