output "network_interface_id" {
  value       = azurerm_network_interface.default[*].id
  description = "The ID of the Network Interface."
}

output "network_interface_private_ip_addresses" {
  value       = try(azurerm_network_interface.default[*].private_ip_addresses, null)
  description = "The private IP addresses of the network interface."
}

output "availability_set_id" {
  value       = try(azurerm_availability_set.default[*].id, null)
  description = "The ID of the Availability Set."
}

output "public_ip_id" {
  value       = try(azurerm_public_ip.default[*].id, null)
  description = "The Public IP ID."
}

output "public_ip_address" {
  value       = try(azurerm_public_ip.default[*].ip_address, null)
  description = "The IP address value that was allocated."
}

output "linux_virtual_machine_id" {
  value       = try(azurerm_linux_virtual_machine.default[*].id, null)
  description = "The ID of the Linux Virtual Machine."
}

output "windows_virtual_machine_id" {
  value       = try(azurerm_windows_virtual_machine.win_vm[*].id, null)
  description = "The ID of the Windows Virtual Machine."
}

output "network_interface_sg_association_id" {
  value       = try(azurerm_network_interface_security_group_association.default[*].id, null)
  description = "The (Terraform specific) ID of the Association between the Network Interface and the Network Interface."
}

output "tags" {
  value       = module.labels.tags
  description = "The tags associated to resources."
}

output "disk_encryption_set-id" {
  value = try(azurerm_disk_encryption_set.example[*].id, null)
}

output "key_id" {
  value       = try(azurerm_key_vault_key.example[*].id, null)
  description = "Id of key that is to be used for encrypting "
}

output "extension_id" {
  value       = { for id in azurerm_virtual_machine_extension.vm_insight_monitor_agent : id.name => id.id }
  description = "The ID of the Virtual Machine Extension."
}

output "service_vault_id" {
  description = "The Principal ID associated with this Managed Service Identity."
  value       = azurerm_recovery_services_vault.example[*].identity[0].principal_id
}

output "service_vault_tenant_id" {
  description = "The Tenant ID associated with this Managed Service Identity."
  value       = azurerm_recovery_services_vault.example[*].identity[0].tenant_id

}

output "vm_backup_policy_id" {
  description = "The ID of the VM Backup Policy."
  value       = azurerm_backup_policy_vm.policy[*].id
}
