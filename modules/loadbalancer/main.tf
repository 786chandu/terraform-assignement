
#-----------------------------
# Resource Group
#-----------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}


#----------------------------------
#  Loadbalancer Public Ip
#----------------------------------

resource "azurerm_public_ip" "loadbalancer_publicip" {
  name                = lower("${var.lb_name}-${var.environment}")
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard" 
}

#-----------------------------------
#    Loadbalancer
#-----------------------------------
resource "azurerm_lb" "lb" {
  name                = lower(var.lb_name)
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "Lbpublicip"
    public_ip_address_id = azurerm_public_ip.loadbalancer_publicip.id
  }
}

#------------------------------------
#   Backend Pool Address
#------------------------------------
resource "azurerm_lb_backend_address_pool" "lb-backend" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-association01" {
  network_interface_id    = var.first_nic_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-association02" {
  network_interface_id    = var.second_nic_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id
}

#-------------------------------------
#   Health Probe
#-------------------------------------
resource "azurerm_lb_probe" "health_probe" {
  name                      = "http-health-probe"
  loadbalancer_id           = azurerm_lb.lb.id
  protocol                  = "Http"
  port                      = 80
  request_path              = "/"
  number_of_probes          = "2"  
}

#-------------------------------------
#   LB Rule
#--------------------------------------
resource "azurerm_lb_rule" "lb_rule" {
  name = "web-apprule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  #backend_address_pool_ids = azurerm_lb_backend_address_pool.lb-backend.id
  probe_id = azurerm_lb_probe.health_probe.id
  loadbalancer_id = azurerm_lb.lb.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-backend.id]
}
# resource "azurerm_lb_backend_address_pool_address" "backend01" {
#   name                    = "backendone"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id
#   #virtual_network_id      = var.backend01_first_virtual_network_id
#   ip_address              = var.backend01_first_virtual_machine_ip
# }

# # resource "azurerm_lb_backend_address_pool" "lb-backendtwo" {
# #   loadbalancer_id = azurerm_lb.lb.id
# #   name            = "BackEndAddressPoolSecond"
  
# # }

# resource "azurerm_lb_backend_address_pool_address" "backend02" {
#   name                    = "backendtwo"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id
#   #virtual_network_id      = var.backend01_second_virtual_network_id
#   ip_address              = var.backend01_second_virtual_machine_ip
# }


#------------------------------
# Loadbalancer NAT Pool
#------------------------------
# resource "azurerm_lb_nat_pool" "lbnat" {
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   loadbalancer_id                = azurerm_lb.lb.id
#   name                           = "SampleApplicationPool"
#   protocol                       = "Tcp"
#   frontend_port_start            = 80
#   frontend_port_end              = 81
#   backend_port                   = 80
#   frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
# }

# #-------------------------------
# #   Loadbalancer NAT Rule
# #-------------------------------
# resource "azurerm_lb_nat_rule" "example" {
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   loadbalancer_id                = azurerm_lb.lb.id
#   name                           = "Http"
#   protocol                       = "Tcp"
#   frontend_port_start            = 80
#   frontend_port_end              = 80
#   #frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.lb-backend.id
# }



