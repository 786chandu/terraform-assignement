output "jumphost_admin_user" {
  value = azurerm_linux_virtual_machine.jumphostvm.admin_username
}

output "jumphost_admin_password" {
  value = azurerm_linux_virtual_machine.jumphostvm.admin_password
}