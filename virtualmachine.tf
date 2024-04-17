locals {
  userdata = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y nginx
    hostname=$(hostname)
    echo "<h1>Hostname: $hostname</h1>" | sudo tee -a /var/www/html/index.html > /dev/null
    sudo systemctl restart nginx
    sudo systemctl enable nginx
EOF
}





module "vmprivate1" {
  source = "./modules/virtualmachine"
  resource_group_name = data.azurerm_resource_group.rg.name
  vm_name = var.first_vm_name
  vm_location = var.virtual_network_location
  vm_subnet_id = module.network1.private_subnet1_id
  enable_public_ip = false
  vm_size    = var.first_vm_size
  custom_data = base64encode(local.userdata)
  vm_username = "azureadmin"
  vm_pasword = "azure@123"
  security_rules = [
    {
      name                       = "AllowHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowSSH"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = azurerm_network_interface.jumphost_nic.ip_configuration[0].private_ip_address
      destination_address_prefix = "*"
    },
  ]
}

module "vmprivate2" {
  source = "./modules/virtualmachine"
  resource_group_name = data.azurerm_resource_group.rg.name
  vm_name = var.second_vm_name
  vm_location = var.virtual_network_location
  vm_subnet_id = module.network1.private_subnet2_id
  enable_public_ip = false
  vm_size    = var.second_vm_size
  custom_data =  base64encode(local.userdata)
  vm_username = "azureadmin"
  vm_pasword = "azure@123"
  security_rules = [
    {
      name                       = "AllowHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowSSH"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = azurerm_network_interface.jumphost_nic.ip_configuration[0].private_ip_address
      destination_address_prefix = "*"
    },
  ]
}

output "vmprivate1" {
  value = module.vmprivate1
  sensitive = true
}

output "vmprivate2" {
  value = module.vmprivate2
  sensitive = true
}
