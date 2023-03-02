provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.0"

  name        = "app-test-vm"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

module "vnet" {
  source  = "clouddrove/vnet/azure"
  version = "1.0.0"

  name                = "app"
  environment         = "test"
  label_order         = ["name", "environment"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
  enable_ddos_pp      = false
}

module "subnet" {
  source  = "clouddrove/subnet/azure"
  version = "1.0.1"

  name                 = "app"
  environment          = "test"
  label_order          = ["name", "environment"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet.vnet_name)

  #subnet
  default_name_subnet = true
  subnet_names        = ["subnet1", "subnet2"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]

  # route_table
  enable_route_table = false
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

module "security_group" {
  source  = "clouddrove/network-security-group/azure"
  version = "1.0.0"
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
      name                       = "ssh"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
  }]

}

# module "key_vault" {
#   source = "clouddrove/key-vault/azure"
#   depends_on = [
#     module.resource_group
#   ]
#   name                        = "app13-test13"
#   environment                 = "test"
#   label_order                 = ["name", "environment", ]
#   resource_group_name         = module.resource_group.resource_group_name
#   purge_protection_enabled    = true
#   enabled_for_disk_encryption = true
#   sku_name                    = "standard"
#   subnet_id                   = module.subnet.default_subnet_id[0]
#   virtual_network_id          = module.vnet.vnet_id[0]
#   #private endpoint
#   enable_private_endpoint = true
#   ##RBAC
#   enable_rbac_authorization = true
#   principal_id              = ["c2#################3"]
#   role_definition_name      = ["Key Vault Administrator"]
# }


module "virtual-machine" {
  source = "../../"

  ## Tags
  name        = "app"
  environment = "test"
  label_order = ["environment", "name"]

  ## Common
  is_vm_linux                     = true
  enabled                         = true
  machine_count                   = 1
  resource_group_name             = module.resource_group.resource_group_name
  location                        = module.resource_group.resource_group_location
  disable_password_authentication = true

  ## Network Interface
  subnet_id                     = module.subnet.default_subnet_id
  private_ip_address_version    = "IPv4"
  private_ip_address_allocation = "Static"
  primary                       = true
  private_ip_addresses          = ["10.0.1.4"]
  #nsg
  network_interface_sg_enabled = true
  network_security_group_id    = module.security_group.id

  ## Availability Set
  availability_set_enabled     = true
  platform_update_domain_count = 7
  platform_fault_domain_count  = 3

  ## Public IP
  public_ip_enabled = true
  sku               = "Basic"
  allocation_method = "Static"
  ip_version        = "IPv4"


  ## Virtual Machine

  vm_size        = "Standard_B1s"
  public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiGNZewuQKwr9XZPfnejPxafa1XcrvZBIkk1lwsfbITHlOSvSkB9xLsCwbMaPDxYsFi43DlcCQPrYSUiwRktphmiKfYWKAxSarlNiY74NNo7RpIN3znLK5fWD5hB6VRol5x0Et0QmT5RoGvOCVx88ZCl/87V/IqHFbtIYvhVc6bpqOURB2KOjysYz+ZkHM38tw9d+0L8NC9qxw603T4Q8HFPG9BFrlAsg4J5NUeypy66dyb6mVqGSXQHewhvpthxzX9GYC7n24YRvGhq/0o067BX2dkAoiO4G+bIphk6o5cLN8jXrYOkfo26BseGd9TQuQX05c8huMfVoL9X+2+4Xb dev" # Enter valid public key here
  admin_username = "ubuntu"
  # admin_password                = "P@ssw0rd!123!" # It is compulsory when disable_password_authentication = false
  caching      = "ReadWrite"
  disk_size_gb = 30

  disk_encryption_set_id          = module.virtual-machine.disk_encryption_set-id
  storage_image_reference_enabled = true
  image_publisher                 = "Canonical"
  image_offer                     = "0001-com-ubuntu-server-focal"
  image_sku                       = "20_04-lts"
  image_version                   = "latest"


  enable_disk_encryption_set = false
  # key_vault_id               = module.key_vault.id
  key_vault_key_id           = module.virtual-machine.key_id
  enable_encryption_at_host  = false

  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 100
      storage_account_type = "StandardSSD_LRS"
    }
    # ,{
    #   name                 = "disk2"
    #   disk_size_gb         = 200
    #   storage_account_type = "Standard_LRS"
    # }
  ]

  # Extension

  is_extension_enabled = true
  extension_publisher = "Microsoft.Azure.Extensions"
  extension_type = "CustomScript"
  extension_type_handler = "2.0"
  settings = <<SETTINGS
  {
        "commandToExecute": "hostname && uptime"
  }
  SETTINGS

## protected_settings = <<PROTECTED_SETTINGS
          # map values here
# PROTECTED_SETTINGS

}
