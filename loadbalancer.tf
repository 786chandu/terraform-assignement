module "loadbalancer" {
  source = "./modules/loadbalancer"
  resource_group_name = var.resource_group_name
  environment = var.environment
  location = var.virtual_network_location
  lb_name = lower("${var.application}-${var.environment}")
  first_nic_id = module.vmprivate1.network_interface_id
  second_nic_id = module.vmprivate2.network_interface_id
#   backend01_first_virtual_network_id = module.network1.vnet_id
#   backend01_first_virtual_machine_ip = module.vmprivate1.private_ip_address
#   backend01_second_virtual_network_id = module.network1.vnet_id
#   backend01_second_virtual_machine_ip = module.vmprivate2.private_ip_address
}