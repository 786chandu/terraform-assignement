output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_subnet1_id" {
  value = azurerm_subnet.private1.id
}

output "private_subnet2_id" {
  value = azurerm_subnet.private2.id
}

output "private_subnet3_id" {
  value = azurerm_subnet.private3.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
