module "network1" {
  source = "./modules/network"
  resource_group_name = data.azurerm_resource_group.rg.name
  vnet_name = var.first_virtualnetwork_name
  virtual_network_location = var.virtual_network_location
  address_space = var.first_virtualnetwork_address_space
  public_subnet_cidr = var.first_public_subnet_cidr
  private_subnet1_cidr = var.first_private_subnet1_cidr
  private_subnet2_cidr = var.first_private_subnet2_cidr
  private_subnet3_cidr = var.first_private_subnet3_cidr
}

# module "network2" {
#   source = "./modules/network"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   vnet_name = var.second_virtualnetwork_name
#   virtual_network_location = var.virtual_network_location
#   address_space = var.second_virtualnetwork_address_space
#   public_subnet_cidr = var.second_public_subnet_cidr
#   private_subnet1_cidr = var.second_private_subnet1_cidr
#   private_subnet2_cidr = var.second_private_subnet2_cidr
# }

# resource "azurerm_virtual_network_peering" "peering_network1_to_network2" {
#   name                            = "network1-to-network2"
#   resource_group_name             = data.azurerm_resource_group.rg.name
#   virtual_network_name            = module.network1.vnet_name
#   remote_virtual_network_id       = module.network2.vnet_id
#   allow_forwarded_traffic         = true
#   allow_gateway_transit           = false
#   use_remote_gateways             = false
# }

# resource "azurerm_virtual_network_peering" "peering_network2_to_network1" {
#   name                            = "network2-to-network1"
#   resource_group_name             = data.azurerm_resource_group.rg.name
#   virtual_network_name            = module.network2.vnet_name
#   remote_virtual_network_id       = module.network1.vnet_id
#   allow_forwarded_traffic         = true
#   allow_gateway_transit           = false
#   use_remote_gateways             = false
# }

output "network1" {
  value = module.network1
}