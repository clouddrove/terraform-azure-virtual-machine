provider "azurerm" {
  features {}
  subscription_id = "01111111111110-11-11-11-11"
}

provider "azurerm" {
  features {}
  alias           = "peer"
  subscription_id = "01111111111110-11-11-11-11"

}

data "azurerm_client_config" "current_client_config" {}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.2"
  name        = "vm-windows-1"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Canada Central"
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
  source  = "clouddrove/network-security-group/azure"
  version = "1.0.4"
  ## Tags
  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
  ## Security Group
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  subnet_ids              = module.subnet.default_subnet_id
  ##Security Group rule for Custom port.
  inbound_rules = [
    {
      name                       = "rdp"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "3389"
      description                = "allow rdp port"
    },
    {
      name                       = "http"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "443"
      description                = "allow https port"
    }
  ]

}

##-----------------------------------------------------------------------------
## windows virtual-machine module call.
##-----------------------------------------------------------------------------
module "virtual-machine" {
  source              = "../../"
  name                = "app"
  environment         = "test"
  is_vm_windows       = true
  enabled             = true
  machine_count       = 1
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  disk_size_gb        = 128
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
  computer_name   = "app-win-comp"
  vm_size         = "Standard_B1s"
  admin_username  = "azureadmin"
  admin_password  = "Password@123"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2019-datacenter"
  image_version   = "latest"
  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 128
      storage_account_type = "StandardSSD_LRS"
    }
  ]

  # Extension
  extensions = [{
    extension_publisher            = "Microsoft.Azure.ActiveDirectory"
    extension_name                 = "AADLogin"
    extension_type                 = "AADLoginForWindows"
    extension_type_handler_version = "1.0"
    auto_upgrade_minor_version     = true
    automatic_upgrade_enabled      = false
  }]
  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = ""
}
