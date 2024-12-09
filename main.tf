##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

##-----------------------------------------------------------------------------
## Terraform resource to create a network interface for virtual machine.
##-----------------------------------------------------------------------------
resource "azurerm_network_interface" "default" {
  count                          = var.enabled ? var.machine_count : 0
  name                           = var.vm_addon_name == null ? format("%s-nic-%s", module.labels.id, count.index + 1) : format("%s-nic-%s", module.labels.id, var.vm_addon_name)
  resource_group_name            = var.resource_group_name
  location                       = var.location
  dns_servers                    = var.dns_servers
  ip_forwarding_enabled          = var.enable_ip_forwarding
  accelerated_networking_enabled = var.enable_accelerated_networking
  internal_dns_name_label        = var.internal_dns_name_label
  tags                           = module.labels.tags

  ip_configuration {
    name                          = var.vm_addon_name == null ? format("%s-ip-config-%s", module.labels.id, count.index + 1) : format("%s-ip-config-%s", module.labels.id, var.vm_addon_name)
    subnet_id                     = var.private_ip_address_version == "IPv4" ? element(var.subnet_id, count.index) : ""
    private_ip_address_version    = var.private_ip_address_version
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = var.public_ip_enabled ? element(azurerm_public_ip.default[*].id, count.index) : null
    primary                       = var.primary
    private_ip_address            = var.private_ip_address_allocation == "Static" ? element(var.private_ip_addresses, count.index) : ""
  }

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

##-----------------------------------------------------------------------------
## Terraform resource to create a availability set for virtual machine.
##-----------------------------------------------------------------------------
resource "azurerm_availability_set" "default" {
  count                        = var.enabled && var.availability_set_enabled ? 1 : 0
  name                         = var.vm_addon_name == null ? format("%s-vm-availability-set", module.labels.id) : format("%s-vm-availability-set-%s", module.labels.id, var.vm_addon_name)
  resource_group_name          = var.resource_group_name
  location                     = var.location
  platform_update_domain_count = var.platform_update_domain_count
  platform_fault_domain_count  = var.platform_fault_domain_count
  proximity_placement_group_id = var.proximity_placement_group_id
  managed                      = var.managed
  tags                         = module.labels.tags

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

##-----------------------------------------------------------------------------
## Terraform resource to create a public IP for network interface.
##-----------------------------------------------------------------------------
resource "azurerm_public_ip" "default" {
  count                   = var.enabled && var.public_ip_enabled ? var.machine_count : 0
  name                    = var.vm_addon_name == null ? format("%s-pip-%s", module.labels.id, count.index + 1) : format("%s-pip-%s", module.labels.id, var.vm_addon_name)
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku                     = var.sku
  allocation_method       = var.sku == "Standard" ? "Static" : var.allocation_method
  ip_version              = var.ip_version
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  domain_name_label       = var.domain_name_label
  reverse_fqdn            = var.reverse_fqdn
  public_ip_prefix_id     = var.public_ip_prefix_id
  ddos_protection_mode    = var.ddos_protection_mode
  tags                    = module.labels.tags

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

##-----------------------------------------------------------------------------
## Terraform resource to create a linux virtual machine.
##-----------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "default" {
  count                           = var.is_vm_linux && var.enabled ? var.machine_count : 0
  name                            = var.vm_addon_name == null ? format("%s-virtual-machine-%s", module.labels.id, count.index + 1) : format("%s-virtual-machine-%s", module.labels.id, var.vm_addon_name)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  user_data                       = var.user_data != null ? (var.user_data) : null
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.disable_password_authentication == true ? null : var.admin_password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids           = [element(azurerm_network_interface.default[*].id, count.index)]
  source_image_id                 = var.source_image_id != null ? var.source_image_id : null
  availability_set_id             = var.availability_set_enabled ? azurerm_availability_set.default[0].id : null
  proximity_placement_group_id    = var.proximity_placement_group_id
  encryption_at_host_enabled      = var.enable_encryption_at_host
  patch_assessment_mode           = var.patch_assessment_mode
  patch_mode                      = var.linux_patch_mode
  provision_vm_agent              = var.provision_vm_agent
  zone                            = var.vm_availability_zone
  tags                            = module.labels.tags

  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.public_key
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled ? [1] : []

    content {

      storage_account_uri = var.blob_endpoint
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.addtional_capabilities_enabled ? [1] : []

    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }

  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []

    content {
      type         = var.vm_identity_type
      identity_ids = var.identity_ids
    }
  }

  dynamic "plan" {
    for_each = var.plan_enabled ? [1] : []

    content {
      name      = var.plan_name
      publisher = var.plan_publisher
      product   = var.plan_product
    }
  }

  os_disk {
    name                      = var.vm_addon_name == null ? format("%s-vm-os-disk", module.labels.id) : format("%s-storage-os-disk-%s", module.labels.id, var.vm_addon_name)
    storage_account_type      = var.os_disk_storage_account_type
    caching                   = var.caching
    disk_encryption_set_id    = var.enable_disk_encryption_set ? azurerm_disk_encryption_set.example[0].id : null
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.write_accelerator_enabled
  }

  dynamic "source_image_reference" {
    for_each = var.storage_image_reference_enabled ? [1] : []

    content {
      publisher = var.image_publisher
      offer     = var.custom_image_id == "" ? var.image_offer : ""
      sku       = var.custom_image_id == "" ? var.image_sku : ""
      version   = var.custom_image_id == "" ? var.image_version : ""
    }
  }


  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }

  depends_on = [
    azurerm_role_assignment.azurerm_disk_encryption_set_key_vault_access
  ]
}

##-----------------------------------------------------------------------------
## Terraform resource to create a windows virtual machine.
##-----------------------------------------------------------------------------
resource "azurerm_windows_virtual_machine" "win_vm" {
  count                        = var.is_vm_windows && var.enabled ? var.machine_count : 0
  name                         = var.vm_addon_name == null ? format("%s-win-virtual-machine-%s", module.labels.id, count.index + 1) : format("%s-win-virtual-machine-%s", module.labels.id, var.vm_addon_name)
  computer_name                = var.computer_name != null ? var.computer_name : format("%s-win-virtual-machine-%s", module.labels.id, count.index + 1)
  resource_group_name          = var.resource_group_name
  location                     = var.location
  network_interface_ids        = [element(azurerm_network_interface.default[*].id, count.index)]
  size                         = var.vm_size
  admin_password               = var.admin_password
  admin_username               = var.admin_username
  source_image_id              = var.source_image_id != null ? var.source_image_id : null
  provision_vm_agent           = var.provision_vm_agent
  allow_extension_operations   = var.allow_extension_operations
  dedicated_host_id            = var.dedicated_host_id
  enable_automatic_updates     = var.enable_automatic_updates
  license_type                 = var.license_type
  availability_set_id          = var.availability_set_enabled ? azurerm_availability_set.default[0].id : null
  encryption_at_host_enabled   = var.enable_encryption_at_host
  proximity_placement_group_id = var.proximity_placement_group_id
  patch_mode                   = var.windows_patch_mode
  patch_assessment_mode        = var.patch_assessment_mode
  zone                         = var.vm_availability_zone
  timezone                     = var.timezone
  tags                         = module.labels.tags

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled ? [1] : []

    content {
      storage_account_uri = var.blob_endpoint
    }
  }
  dynamic "additional_capabilities" {
    for_each = var.addtional_capabilities_enabled ? [1] : []

    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }
  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []

    content {
      type         = var.vm_identity_type
      identity_ids = var.identity_ids
    }
  }
  os_disk {
    storage_account_type      = var.os_disk_storage_account_type
    caching                   = var.caching
    disk_encryption_set_id    = var.enable_disk_encryption_set ? azurerm_disk_encryption_set.example[0].id : null
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.enable_os_disk_write_accelerator
    name                      = var.vm_addon_name == null ? format("%s-win-vm-storage-data-disk-%s", module.labels.id, count.index + 1) : format("%s-win-storage-data-disk-%s", module.labels.id, var.vm_addon_name)
  }
  dynamic "source_image_reference" {
    for_each = var.source_image_id != null ? [] : [1]
    content {
      publisher = var.custom_image_id != null ? var.image_publisher : ""
      offer     = var.custom_image_id != null ? var.image_offer : ""
      sku       = var.custom_image_id != null ? var.image_sku : ""
      version   = var.custom_image_id != null ? var.image_version : ""
    }
  }
  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }

  depends_on = [
    azurerm_role_assignment.azurerm_disk_encryption_set_key_vault_access
  ]
}

##-----------------------------------------------------------------------------
## VIRTUAL MACHINE NETWORK SECURITY GROUP ASSOCIATION.
##-----------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "default" {
  count                     = var.enabled && var.network_interface_sg_enabled ? var.machine_count : 0
  network_interface_id      = azurerm_network_interface.default[count.index].id
  network_security_group_id = var.network_security_group_id
}

##-----------------------------------------------------------------------------
## Azure Disk Encryption helps protect and safeguard your data to meet your organizational security and compliance commitments.
##-----------------------------------------------------------------------------
resource "azurerm_disk_encryption_set" "example" {
  count               = var.enabled && var.enable_disk_encryption_set ? var.machine_count : 0
  name                = var.vm_addon_name == null ? format("%s-vm-dsk-encrpt-%s", module.labels.id, count.index + 1) : format("vm-%s-dsk-encrpt-%s", module.labels.id, var.vm_addon_name)
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = var.enable_disk_encryption_set ? azurerm_key_vault_key.example[0].id : null

  identity {
    type = "SystemAssigned"
  }
}

##-----------------------------------------------------------------------------
## The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created.
##-----------------------------------------------------------------------------
resource "azurerm_role_assignment" "azurerm_disk_encryption_set_key_vault_access" {
  count                = var.enabled && var.enable_disk_encryption_set ? var.machine_count : 0
  scope                = var.key_vault_id
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_disk_encryption_set.example[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "ad_role_assignment" {
  for_each             = var.enabled ? var.user_object_id : {}
  scope                = var.is_vm_windows ? azurerm_windows_virtual_machine.win_vm[0].id : azurerm_linux_virtual_machine.default[0].id
  role_definition_name = lookup(each.value, "role_definition_name", "")
  principal_id         = lookup(each.value, "principal_id", "")
}

##-----------------------------------------------------------------------------
## azurerm_key_vault_key provides a secure store for secrets.
##-----------------------------------------------------------------------------
resource "azurerm_key_vault_key" "example" {
  count        = var.enabled && var.enable_disk_encryption_set ? var.machine_count : 0
  name         = var.vm_addon_name == null ? format("%s-vm-vault-key-%s", module.labels.id, count.index + 1) : format("vm-%s-vault-key-%s", module.labels.id, var.vm_addon_name)
  key_vault_id = var.key_vault_id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

##-----------------------------------------------------------------------------
## A Key Vault access policy determines whether a given security principal, namely a user, application or user group, can perform different operations on Key Vault secrets, keys, and certificates.
##-----------------------------------------------------------------------------
resource "azurerm_key_vault_access_policy" "main" {
  count        = var.enabled && var.enable_disk_encryption_set && var.key_vault_rbac_auth_enabled == false ? var.machine_count : 0
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_disk_encryption_set.example[0].identity[0].tenant_id
  object_id    = azurerm_disk_encryption_set.example[0].identity[0].principal_id
  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "Get",
    "WrapKey",
    "UnwrapKey",
    "List",
    "Decrypt",
    "Sign"
  ]
}

##-----------------------------------------------------------------------------
##  This is where you are creating the managed disk. The name argument specifies the name of the disk.
##-----------------------------------------------------------------------------
resource "azurerm_managed_disk" "data_disk" {
  for_each = var.enabled ? { for it, data_disk in var.data_disks : data_disk.name => {
    it : it,
    data_disk : data_disk,
    }
  } : {}
  name                   = format("%s-%s-vm-managed-disk", module.labels.id, each.value.data_disk.name)
  resource_group_name    = var.resource_group_name
  location               = var.location
  storage_account_type   = lookup(each.value.data_disk, "storage_account_type", "StandardSSD_LRS")
  create_option          = var.create_option
  disk_size_gb           = each.value.data_disk.disk_size_gb
  disk_encryption_set_id = var.enable_disk_encryption_set ? azurerm_disk_encryption_set.example[0].id : null
  depends_on = [
    azurerm_role_assignment.azurerm_disk_encryption_set_key_vault_access
  ]
}

##-----------------------------------------------------------------------------
## Manages attaching a Disk to a Virtual Machine.
##-----------------------------------------------------------------------------
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  for_each = var.enabled ? { for it, data_disk in var.data_disks : data_disk.name => {
    it : it,
    data_disk : data_disk,
    }
  } : {}
  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = var.is_vm_windows ? azurerm_windows_virtual_machine.win_vm[0].id : azurerm_linux_virtual_machine.default[0].id
  lun                = each.value.it
  caching            = "ReadWrite"
}

##-----------------------------------------------------------------------------
## azurerm_virtual_machine_extension. Manages a Virtual Machine Extension to provide post deployment configuration and run automated tasks.
##-----------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "vm_insight_monitor_agent" {
  for_each                   = var.enabled ? { for extension in var.extensions : extension.extension_name => extension } : {}
  name                       = each.value.extension_name
  virtual_machine_id         = var.is_vm_windows ? azurerm_windows_virtual_machine.win_vm[0].id : azurerm_linux_virtual_machine.default[0].id
  publisher                  = each.value.extension_publisher
  type                       = each.value.extension_type
  type_handler_version       = each.value.extension_type_handler_version
  auto_upgrade_minor_version = lookup(each.value, "auto_upgrade_minor_version", null)
  automatic_upgrade_enabled  = lookup(each.value, "automatic_upgrade_enabled", null)
  settings                   = lookup(each.value, "settings", null)
  protected_settings         = lookup(each.value, "protected_settings", null)
  tags                       = module.labels.tags
}

##-----------------------------------------------------------------------------
## This resource allows you to manage a Diagnostic Setting for an Azure resource.
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "pip_gw" {
  count                          = var.enabled && var.diagnostic_setting_enable && var.public_ip_enabled ? var.machine_count : 0
  name                           = var.vm_addon_name == null ? format("%s-vm-pip-diag-log-%s", module.labels.id, count.index + 1) : format("%s-vm-pip-%s-diagnostic-log", module.labels.id, var.vm_addon_name)
  target_resource_id             = azurerm_public_ip.default[0].id
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  dynamic "metric" {
    for_each = var.metric_enabled ? ["AllMetrics"] : []
    content {
      category = metric.value
      enabled  = true
    }
  }
  dynamic "enabled_log" {
    for_each = var.pip_logs.enabled ? var.pip_logs.category != null ? var.pip_logs.category : var.pip_logs.category_group : []
    content {
      category       = var.pip_logs.category != null ? enabled_log.value : null
      category_group = var.pip_logs.category == null ? enabled_log.value : null
    }
  }
  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}

##-----------------------------------------------------------------------------
## This resource allows you to manage a Diaresourcegnostic Setting for an Azure resource.
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "nic_diagnostic" {
  count                          = var.enabled && var.diagnostic_setting_enable ? var.machine_count : 0
  name                           = var.vm_addon_name == null ? format("%s-vm-pe-nic-diag-log-%s", module.labels.id, count.index + 1) : format("%s-vm-pe-nic-%s-diagnostic-log-%", module.labels.id, var.vm_addon_name)
  target_resource_id             = azurerm_network_interface.default[0].id
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  dynamic "metric" {
    for_each = var.metric_enabled ? ["AllMetrics"] : []
    content {
      category = metric.value
      enabled  = true
    }
  }
  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}


resource "azurerm_recovery_services_vault" "example" {
  count                         = var.enabled && var.backup_enabled ? var.machine_count : 0
  name                          = var.vm_addon_name == null ? format("%s-vm-service-vault-%s", module.labels.id, count.index + 1) : format("vm-%s-service-vault-%s", module.labels.id, var.vm_addon_name)
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.vault_sku
  tags                          = module.labels.tags
  public_network_access_enabled = var.public_network_access_enabled
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_backup_policy_vm" "policy" {
  count               = var.enabled && var.backup_enabled ? var.machine_count : 0
  name                = var.vm_addon_name == null ? format("%s-policy-vm-%d", module.labels.id, count.index + 1) : format("%s-policy-vm-%d", module.labels.id, var.vm_addon_name)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.example[count.index].name
  policy_type         = var.backup_policy_type != null ? var.backup_policy_type : "V2"

  timezone = var.backup_policy_time_zone != null ? var.backup_policy_time_zone : "UTC"

  backup {
    frequency = var.backup_policy_frequency != null ? var.backup_policy_frequency : "Daily"
    time      = var.backup_policy_time != null ? var.backup_policy_time : "23:00"
  }

  dynamic "retention_daily" {
    for_each = var.backup_policy_retention["daily"].enabled ? [1] : []
    content {
      count = var.backup_policy_retention["daily"].count
    }
  }

  dynamic "retention_weekly" {
    for_each = var.backup_policy_retention["weekly"].enabled ? [1] : []
    content {
      count    = var.backup_policy_retention["weekly"].count
      weekdays = var.backup_policy_retention["weekly"].weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = var.backup_policy_retention["monthly"].enabled ? [1] : []
    content {
      count    = var.backup_policy_retention["monthly"].count
      weekdays = var.backup_policy_retention["monthly"].weekdays
      weeks    = var.backup_policy_retention["monthly"].weeks
    }
  }

}

resource "azurerm_backup_protected_vm" "example" {
  count               = var.enabled && var.backup_enabled ? var.machine_count : 0
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.example[count.index].name
  backup_policy_id    = azurerm_backup_policy_vm.policy[count.index].id
  source_vm_id        = var.is_vm_linux ? azurerm_linux_virtual_machine.default[count.index].id : azurerm_windows_virtual_machine.win_vm[count.index].id
}