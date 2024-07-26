provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current_client_config" {}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.2"
  name        = "vm"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Norway East"
}

##-----------------------------------------------------------------------------
## vnet module call
##-----------------------------------------------------------------------------
module "vnet" {
  source              = "clouddrove/vnet/azure"
  version             = "1.0.4"
  name                = "app"
  environment         = "test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##-----------------------------------------------------------------------------
## subnet module call
##-----------------------------------------------------------------------------
module "subnet" {
  source               = "clouddrove/subnet/azure"
  version              = "1.2.1"
  name                 = "app"
  environment          = "test"
  label_order          = ["name", "environment"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  #subnet
  subnet_names    = ["subnet1"]
  subnet_prefixes = ["10.0.1.0/24"]
  # route_table
  enable_route_table = true
  route_table_name   = "default_subnet"
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

##-----------------------------------------------------------------------------
## security-group module call.
##-----------------------------------------------------------------------------
module "security_group" {
  source                  = "clouddrove/network-security-group/azure"
  version                 = "1.0.4"
  name                    = "app"
  environment             = "test"
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  subnet_ids              = module.subnet.default_subnet_id
  inbound_rules = [
    {
      name                       = "ssh"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    }
  ]

}

##-----------------------------------------------------------------------------
## key-vault module call for disc encryption of virtual machine with cmk.
#-----------------------------------------------------------------------------
module "key_vault" {
  source  = "clouddrove/key-vault/azure"
  version = "1.1.0"

  name                        = "vae59d6058"
  environment                 = "test"
  label_order                 = ["name", "environment", ]
  resource_group_name         = module.resource_group.resource_group_name
  location                    = module.resource_group.resource_group_location
  admin_objects_ids           = [data.azurerm_client_config.current_client_config.object_id]
  virtual_network_id          = module.vnet.vnet_id
  subnet_id                   = module.subnet.default_subnet_id[0]
  enable_rbac_authorization   = true
  enabled_for_disk_encryption = false
  #private endpoint
  enable_private_endpoint = false
  network_acls            = null
  ########Following to be uncommnented only when using DNS Zone from different subscription along with existing DNS zone.

  # diff_sub                                      = true
  # alias                                         = ""
  # alias_sub                                     = ""

  #########Following to be uncommmented when using DNS zone from different resource group or different subscription.
  # existing_private_dns_zone                     = ""
  # existing_private_dns_zone_resource_group_name = ""

  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = module.log-analytics.workspace_id ## when diagnostic_setting_enable enable,  add log analytics workspace id
}

##-----------------------------------------------------------------------------
## log-analytics module call for diagnosis setting 
#-----------------------------------------------------------------------------
module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "1.0.1"
  name                             = "app"
  environment                      = "test"
  label_order                      = ["name", "environment"]
  create_log_analytics_workspace   = true
  log_analytics_workspace_sku      = "PerGB2018"
  resource_group_name              = module.resource_group.resource_group_name
  log_analytics_workspace_location = module.resource_group.resource_group_location
}

##-----------------------------------------------------------------------------
## linux virtual-machine module call.
##-----------------------------------------------------------------------------
module "virtual-machine" {
  source              = "../../"
  depends_on          = [module.key_vault]
  name                = "app"
  environment         = "test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  is_vm_linux         = true
  user_object_id = {
    "user1" = {
      role_definition_name = "Virtual Machine Administrator Login"
      principal_id         = data.azurerm_client_config.current_client_config.object_id
    },
  }
  ## Network Interface
  subnet_id            = module.subnet.default_subnet_id
  private_ip_addresses = ["10.0.1.4"]
  #nsg
  network_interface_sg_enabled = true
  network_security_group_id    = module.security_group.id
  ## Public IP
  public_ip_enabled = false
  ## Virtual Machine
  vm_size         = "Standard_B1s"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbysTkkLhdRS5Zs5aZyGMqaDdoI98KpkOkM/jBpDsRiN/q8omnhgfbYGORj4MRbQhBMWmDxQPzB9vVOJ2oZTtLJonlxLZvkhW0s6KSEn3W5yCNuceDwr/01mjjTquVXCd9lDeBDstuZnx61PCAjzsuQQ3S9rDbIogZayZGcshnRN6qWNm7NNBb6MigMzsbE4QiJbtVNfjL8zbAKV3GlnO9HJ76FKfMdh8Qo9DALOrFyl7YSjOlUOUDyANuntaa9vPKB5qgSvraXcuBYg/zlrLmP/IyFmPiVfyJKK89vBTUskOP+e53gxs0q0W7W2xbQrbkcc7n4ivTDGi6VRRnf0tka3FP5GoRoHpz4WBgLUM2tATYl0TynusQO6mNGr5meS90A7RU18C6WVB56ggmFA10xL4ZHS+Xi0PrgHEgtEPP2qhqF/5IiakBVFOguVNX4BOoSAHpSXNAphpRdL19AfCarwL2Mue7lMz03KmiWFnC8K60Ma1XB7Do4GD/c/oUR4c="
  admin_username  = "ubuntu"
  caching         = "ReadWrite"
  disk_size_gb    = 30
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"

  enable_disk_encryption_set = true
  key_vault_id               = module.key_vault.id
  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 60
      storage_account_type = "StandardSSD_LRS"
    }
  ]
  # Extension
  extensions = [{
    extension_publisher            = "Microsoft.Azure.ActiveDirectory"
    extension_name                 = "AADLogin"
    extension_type                 = "AADSSHLoginForLinux"
    extension_type_handler_version = "1.0"
    auto_upgrade_minor_version     = true
    automatic_upgrade_enabled      = false
  }]

  #### enable diagnostic setting
  diagnostic_setting_enable  = true
  log_analytics_workspace_id = module.log-analytics.workspace_id ## when diagnostic_setting_enable enable,  add log analytics workspace id
}
