#-------------------------------
# Public ip Address
#-------------------------------
resource "azurerm_public_ip" "jumphost_publicip" {
  name                = "jumphostvmpublicip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.virtual_network_location
  allocation_method   = "Static"
}

#---------------------------------
#  NSG
#---------------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "jumphostnsg"
  location            = var.virtual_network_location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

 resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
   subnet_id = module.network1.public_subnet_id
   network_security_group_id = azurerm_network_security_group.nsg.id
 }

#------------------------------
#         NIC
#------------------------------

resource "azurerm_network_interface" "jumphost_nic" {
  name                = "jumphost-nic"
  location            = var.virtual_network_location
  resource_group_name = data.azurerm_resource_group.rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network1.public_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumphost_publicip.id

  }
}

#-------------------------------
#   Random Password Generator
#-------------------------------

resource "random_password" "jumphost_randompassword" {
 length = 12
  min_upper = 1 
  min_lower = 2
  min_numeric = 4
  special = false 

  keepers = {
    admin_password = var.jumphost_username
  }
}

#--------------------------------
#    Virtual Machine
#--------------------------------

resource "azurerm_linux_virtual_machine" "jumphostvm" {
    name = var.jumphost_vm_name
    location = var.virtual_network_location
    resource_group_name = data.azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.jumphost_nic.id]
    size = var.jumphost_vm_size
    disable_password_authentication = false
    admin_username = var.jumphost_username
    admin_password = random_password.jumphost_randompassword.result
    source_image_reference {
      publisher = "Canonical"
      offer = "0001-com-ubuntu-server-focal"
      sku = "20_04-lts-gen2"
      version = "latest"
    }
    os_disk {
      name   = "jumphostosdisk"  
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"   
    }
    }





