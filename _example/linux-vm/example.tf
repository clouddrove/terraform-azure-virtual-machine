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
  version              = "1.1.0"
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
  source              = "clouddrove/key-vault/azure"
  version             = "1.1.0"
  name                = "hello55"
  environment         = "test"
  label_order         = ["name", "environment", ]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  admin_objects_ids   = [data.azurerm_client_config.current_client_config.object_id]
  subnet_id           = module.subnet.default_subnet_id[0]
  virtual_network_id  = module.vnet.vnet_id
  #private endpoint
  enable_private_endpoint = false
  ##RBAC
  enable_rbac_authorization = true
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["0.0.0.0/0"]
  }
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
  public_ip_enabled = true
  ## Virtual Machine
  vm_size         = "Standard_B1s"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/e5bluEqTbb3qtuoKh1qEXMP4bk6QtqPrbhg7bMYQjJChmzvuA/aqA8gkQ48lweoFZMd7yr/ylhBPXvpYQ450INW6CNksatr4+z+EXHzyJ3MBTLSWlFc+ut6ji6Fglgkk3fe4sJw2fPZlf3FWFkomLJ3dIOIHyHQO6IaL9ZP22TRSPegSceNC30XF4xz1nHYiqNlZVq/COMHDtammwq8VnitkP6lRbokeJ1HlNBaJygUHlzYKrg8nguxGph3rlG9g+2+xAYf/qHQ/8k14xUMac7JBORnv+HAI+YHYCRYlQVXg635Bnj83jWmDK5Wed98O9ORARv70UN8Bj46247cdkeXXOAslUW19RQj0BA+QYRRvsXfLqlNX/Wq9V5yp66wO4QZV/2wvmoUwSELz6fn+qQvdBbs8IN9K7oJz2nl43Dth0vLnn8IrG7V2PfgW1g4WHjK5/GJXfyZXEYiM5Aye4W8V24g0AnunjIldBTnpofT6q4ki9bXx6en9EeBYB6E="
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
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = module.log-analytics.workspace_id ## when diagnostic_setting_enable enable,  add log analytics workspace id

  #vm With User Data
  user_data = file("user-data.sh")
}