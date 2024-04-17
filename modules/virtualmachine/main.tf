#-------------------------
# Local
#-------------------------
locals {
  vm_name = var.vm_name
  formatted_vm_name = replace(replace(replace(lower(local.vm_name), "-", ""), ":", ""), ":", "")
}

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
    admin_password = var.vm_username
  }
}



#-----------------------------
# Resource Group
#-----------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#--------------------------------
#  Network Security Group
#--------------------------------
 resource "azurerm_network_security_group" "nsg" {
   name = lower("${var.vm_name}_nsg")
   resource_group_name = data.azurerm_resource_group.rg.name
   location = var.vm_location
   dynamic "security_rule" {
    for_each = var.security_rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      
    }
  } 
 }

 resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
   subnet_id = var.vm_subnet_id
   network_security_group_id = azurerm_network_security_group.nsg.id
 }

#------------------------------
#         NIC
#------------------------------

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.vm_location
  resource_group_name = data.azurerm_resource_group.rg.name
  
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

}

#--------------------------------
#    Virtual Machine
#--------------------------------

resource "azurerm_linux_virtual_machine" "vm" {
    name = var.vm_name
    location = var.vm_location
    resource_group_name = data.azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    size = var.vm_size
    admin_username = var.vm_username
    admin_password = random_password.passwd.result
    disable_password_authentication = false
    custom_data = var.custom_data

    source_image_reference {
      publisher = "Canonical"
      offer = "0001-com-ubuntu-server-focal"
      sku = "20_04-lts-gen2"
      version = "latest"
    }
    os_disk {
      name   = local.formatted_vm_name  
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"      
    }

    }



