output "security_group_id" {
  value = azurerm_network_security_group.nsg.id
}
output "vm_private_ip" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}
output "private_ip_address" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}
output "network_interface_id" {
  value = azurerm_network_interface.nic.id
}

output "vm_admin_user" {
  value = azurerm_linux_virtual_machine.vm.admin_username
}
output "vm_admin_password" {
    value = azurerm_linux_virtual_machine.vm.admin_password
}