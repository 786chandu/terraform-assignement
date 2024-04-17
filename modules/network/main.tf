#---------------------------------
#          Resource Group
#---------------------------------
data "azurerm_resource_group" "rg"{
  name = var.resource_group_name
}

#----------------------------------
#          Virtual Network
#----------------------------------
resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  address_space = [var.address_space]
  location = var.virtual_network_location
  resource_group_name = data.azurerm_resource_group.rg.name
}

#-----------------------------------
#           Subnet 
#-----------------------------------

resource "azurerm_subnet" "public" {
  name = "${var.vnet_name}-public-subnet1"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.public_subnet_cidr]
}

resource "azurerm_subnet" "private1" {
  name =  "${var.vnet_name}-private-subnet1"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.private_subnet1_cidr]
}

resource "azurerm_subnet" "private2" {
  name =  "${var.vnet_name}-private-subnet2"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.private_subnet2_cidr]
}

resource "azurerm_subnet" "private3" {
  name =  "${var.vnet_name}-private-subnet3"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.private_subnet3_cidr]
}