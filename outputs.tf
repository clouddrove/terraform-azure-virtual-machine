output "network_interface_id" {
  value       = azurerm_network_interface.default[*].id
  description = "The ID of the Network Interface."
}

output "network_interface_private_ip_addresses" {
  value       = azurerm_network_interface.default[*].private_ip_addresses
  description = "The private IP addresses of the network interface."
}

output "availability_set_id" {
  value       = azurerm_availability_set.default[*].id
  description = "The ID of the Availability Set."
}

output "public_ip_id" {
  value       = azurerm_public_ip.default[*].id
  description = "The Public IP ID."
}

output "public_ip_address" {
  value       = azurerm_public_ip.default[*].ip_address
  description = "The IP address value that was allocated."
}

output "linux_virtual_machine_id" {
  value       = azurerm_linux_virtual_machine.default[*].id
  description = "The ID of the Linux Virtual Machine."
}

output "windows_virtual_machine_id" {
  value       = azurerm_windows_virtual_machine.win_vm[*].id
  description = "The ID of the Windows Virtual Machine."
}

output "network_interface_sg_association_id" {
  value       = azurerm_network_interface_security_group_association.default[*].id
  description = "The (Terraform specific) ID of the Association between the Network Interface and the Network Interface."
}

output "tags" {
  value       = module.labels.tags
  description = "The tags associated to resources."
}

output "disk_encryption_set-id" {
  value = azurerm_disk_encryption_set.example[*].id
}

output "key_id" {
  value       = azurerm_key_vault_key.example[*].id
  description = "Id of key that is to be used for encrypting "
}

output "extension_id" {
  value       = { for id in azurerm_virtual_machine_extension.vm_insight_monitor_agent : id.name => id.id }
  description = "The ID of the Virtual Machine Extension."
}
