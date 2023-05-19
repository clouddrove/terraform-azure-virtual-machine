## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}





#Module      : labels
#Description : Terraform module to create consistent naming for multiple names.
module "labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}



#Module      : NETWORK INTERFACE
#Description : Terraform resource to create a network interface for virtual machine.
resource "azurerm_network_interface" "default" {
  count                         = var.enabled ? var.machine_count : 0
  name                          = format("%s-network-interface-%s", module.labels.id, count.index + 1)
  resource_group_name           = var.resource_group_name
  location                      = var.location
  dns_servers                   = var.dns_servers
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking
  internal_dns_name_label       = var.internal_dns_name_label
  tags                          = module.labels.tags

  ip_configuration {
    name                          = format("%s-ip-configuration-%s", module.labels.id, count.index + 1)
    subnet_id                     = var.private_ip_address_version == "IPv4" ? element(var.subnet_id, count.index) : ""
    private_ip_address_version    = var.private_ip_address_version
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = var.public_ip_enabled ? element(azurerm_public_ip.default.*.id, count.index) : null
    primary                       = var.primary
    private_ip_address            = var.private_ip_address_allocation == "Static" ? element(var.private_ip_addresses, count.index) : null
  }

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : AVAILABILITY SET
#Description : Terraform resource to create a availability set for virtual machine.
resource "azurerm_availability_set" "default" {
  count                        = var.enabled && var.availability_set_enabled ? 1 : 0
  name                         = format("%s-availability-set", module.labels.id)
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

#Module      : PUBLIC IP
#Description : Terraform resource to create a public IP for network interface.
resource "azurerm_public_ip" "default" {
  count                   = var.enabled && var.public_ip_enabled ? var.machine_count : 0
  name                    = format("%s-public-ip-%s", module.labels.id, count.index + 1)
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku                     = var.sku
  allocation_method       = var.sku == "Standard" ? "Static" : var.allocation_method
  ip_version              = var.ip_version
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  domain_name_label       = var.domain_name_label
  reverse_fqdn            = var.reverse_fqdn
  public_ip_prefix_id     = var.public_ip_prefix_id
  zones                   = var.zones
  ddos_protection_mode    = var.ddos_protection_mode
  tags                    = module.labels.tags

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}


#Module      : LINUX VIRTUAL MACHINE
#Description : Terraform resource to create a linux virtual machine.
resource "azurerm_linux_virtual_machine" "default" {
  depends_on = [
    azurerm_role_assignment.azurerm_disk_encryption_set_key_vault_access
  ]
  count                           = var.is_vm_linux ? var.machine_count : 0
  name                            = format("%s-virtual-machine-%s", module.labels.id, count.index + 1)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.disable_password_authentication == false && var.admin_password == null ? "" : var.admin_password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids           = [element(azurerm_network_interface.default.*.id, count.index)]
  source_image_id                 = var.source_image_id != null ? var.source_image_id : null
  availability_set_id             = join("", azurerm_availability_set.default.*.id)
  proximity_placement_group_id    = var.proximity_placement_group_id
  encryption_at_host_enabled      = var.enable_encryption_at_host
  patch_assessment_mode           = "AutomaticByPlatform"
  patch_mode                      = "AutomaticByPlatform"
  provision_vm_agent              = true


  zone = var.vm_availability_zone
  tags = module.labels.tags





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
    name                      = format("%s-storage-os-disk", module.labels.id)
    storage_account_type      = var.os_disk_storage_account_type
    caching                   = var.caching
    disk_encryption_set_id    = var.enable_disk_encryption_set ? var.disk_encryption_set_id : null
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
}




#Module      : Windows VIRTUAL MACHINE
#Description : Terraform resource to create a windows virtual machine.
resource "azurerm_virtual_machine" "win_vm" {
  count                 = var.is_vm_windows ? var.machine_count : 0
  name                  = format("%s-win-virtual-machine-%s", module.labels.id, count.index + 1)
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [element(azurerm_network_interface.default.*.id, count.index)]
  vm_size               = var.vm_size

  availability_set_id              = join("", azurerm_availability_set.default.*.id)
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  primary_network_interface_id     = element(azurerm_network_interface.default.*.id, count.index)
  proximity_placement_group_id     = var.proximity_placement_group_id
  zones                            = var.zones
  tags                             = module.labels.tags

  os_profile_windows_config {
    provision_vm_agent = true
  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled ? [1] : []

    content {
      enabled     = var.boot_diagnostics_enabled
      storage_uri = var.blob_endpoint
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
      type         = var.vm_type
      identity_ids = var.identity_ids
    }
  }

  storage_os_disk {
    create_option = var.create_option
    # storage_account_type      = var.os_disk_storage_account_type
    caching = var.caching
    # disk_encryption_set_id    = var.disk_encryption_set_id
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.enable_os_disk_write_accelerator
    name                      = format("%s-wis-storage-data-disk", module.labels.id)
  }

  dynamic "storage_image_reference" {
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
}


#Module      : VIRTUAL MACHINE NETWORK SECURITY GROUP ASSOCIATION
#Description : Terraform resource to create a virtual machine.
resource "azurerm_network_interface_security_group_association" "default" {
  count                     = var.enabled && var.network_interface_sg_enabled ? var.machine_count : 0
  network_interface_id      = azurerm_network_interface.default[count.index].id
  network_security_group_id = var.network_security_group_id
}

#Module      : VIRTUAL MACHINE DISK ENCRYPTION SET

resource "azurerm_disk_encryption_set" "example" {
  count               = var.enable_disk_encryption_set ? 1 : 0
  name                = "des"
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = var.enable_disk_encryption_set ? join("", azurerm_key_vault_key.example.*.id) : null

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "azurerm_disk_encryption_set_key_vault_access" {
  count                = var.enable_disk_encryption_set ? 1 : 0
  scope                = var.key_vault_id //azurerm_key_vault.example.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.example.*.identity.0.principal_id[0]
}

resource "azurerm_key_vault_key" "example" {
  count        = var.enabled && var.enable_disk_encryption_set ? 1 : 0
  name         = format("vm-%s-vault-key", module.labels.id)
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_access_policy" "main" {
  count = var.enabled && var.enable_disk_encryption_set && var.key_vault_rbac_auth_enabled == false ? 1 : 0

  key_vault_id = var.key_vault_id

  tenant_id = azurerm_disk_encryption_set.example[0].identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.example[0].identity.0.principal_id
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

#Data Disks
resource "azurerm_managed_disk" "data_disk" {
  depends_on = [
    azurerm_role_assignment.azurerm_disk_encryption_set_key_vault_access
  ]
  for_each = { for it, data_disk in var.data_disks : data_disk.name => {
    it : it,
    data_disk : data_disk,
    }
  }


  name                   = each.value.data_disk.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  storage_account_type   = lookup(each.value.data_disk, "storage_account_type", "StandardSSD_LRS")
  create_option          = "Empty"
  disk_size_gb           = each.value.data_disk.disk_size_gb
  disk_encryption_set_id = var.enable_disk_encryption_set ? var.disk_encryption_set_id : null

}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  for_each = { for it, data_disk in var.data_disks : data_disk.name => {
    it : it,
    data_disk : data_disk,
    }
  }
  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = var.is_vm_windows ? azurerm_virtual_machine.win_vm[0].id : azurerm_linux_virtual_machine.default[0].id
  lun                = each.value.it
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "vm_insight_monitor_agent" {
  count                      = var.is_extension_enabled == true ? 1 : 0
  name                       = format("%s-vm-extension", module.labels.id)
  virtual_machine_id         = var.is_vm_linux != true ? azurerm_virtual_machine.win_vm[0].id : azurerm_linux_virtual_machine.default[0].id
  publisher                  = var.extension_publisher
  type                       = var.extension_type
  type_handler_version       = var.extension_type_handler
  auto_upgrade_minor_version = var.auto_upgrade_minor_version

  settings = var.settings
  # <<SETTINGS
  #   {
  #     ${var.settings}
  #   }
  # SETTINGS

  protected_settings = var.protected_settings

}



