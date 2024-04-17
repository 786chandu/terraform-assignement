variable "resource_group_name" {}
variable "vm_name" {}
variable "vm_location" {}
variable "vm_subnet_id" {}
variable "enable_public_ip" {}
variable "vm_size" {}
variable "vm_username" {}
variable "vm_pasword" {}
variable "custom_data" {
  
}
variable "security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}