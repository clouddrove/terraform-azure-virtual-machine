provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.0"

  name        = "app-vm"
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

module "key_vault" {
  source = "clouddrove/key-vault/azure"
  depends_on = [
    module.resource_group
  ]
  name                        = "app"
  environment                 = "test"
  label_order                 = ["name", "environment", ]
  resource_group_name         = module.resource_group.resource_group_name
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true
  sku_name                    = "standard"
  subnet_id                   = module.subnet.default_subnet_id[0]
  virtual_network_id          = module.vnet.vnet_id[0]
  #private endpoint
  enable_private_endpoint = true
  ##RBAC
  enable_rbac_authorization = true
  principal_id              = ["c2f1e13d-XXXXXXXXXXXXXc99470c43"]
  role_definition_name      = ["Key Vault Administrator"]
}


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
  public_key     = "ssh-rsa AAAAB3vjLH685+lPLPRuOY3w3OJ3j+dfBbw1A5NqbvGTFlJ6Dh4/229ggycTUfujXlPdc3EyuRQ1nR85vrYmTpnPEetAq2eekxS9+c1pwqoFjWt9VCDV5iSPLCIZ+EegQwAdidYi1QusEXaQ4C+31ZAm3YfgYmHEvApS52pAyNM2vqgqI+Iepig781Rma10sfaNGspMERNc5SU28rqFdogeZmpAxUlEu4kZh1DOw+Q4DnREV4eL4ydSLtnj36GFIdGN8TwG5wOPyARjGzthEAVZquz8bN7fTp61zODfpNfwshhPMRmL19kLHk95rdKgDIRtcy/NNebJtM8ZgTulakyundEPQDQoM1GGrg1EWMbM6aHNDEL6vUbZa0TLCwus2JrMIBqS7yg76uE3gvrOu5KEQnWZBWr0eWWygwBTZL2f1hGQKQVy7M+9Upl44WgziiS/3JSo0GS5m9CWcbqbKCcnlMgOMkP2VyXQW1h+/FagwMa1E2B32uZpTJAkzmX3sPREHDXOjA6HbAXTF1t4HMsuLbcEWiHjnOFKfCll5EFwQeJ6iZcpKaSrQcZWQ7sHEXL1NcSyw== chopra13arhit@gmail.com" # Enter valid public key here
  admin_username = "ubuntu"
  # admin_password                = "P@ssw0rd!123!" # It is compulsory when disable_password_authentication = false
  caching                         = "ReadWrite"
  disk_size_gb                    = 30
  os_type                         = "Linux"
  disk_encryption_set_id          = module.virtual-machine.disk_encryption_set-id
  storage_image_reference_enabled = true
  image_publisher                 = "Canonical"
  image_offer                     = "0001-com-ubuntu-server-focal"
  image_sku                       = "20_04-lts"
  image_version                   = "latest"


  enable_disk_encryption_set = true
  key_vault_id               = module.key_vault.id
  key_vault_key_id           = module.virtual-machine.key_id
  enable_encryption_at_host  = true

  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 100
      storage_account_type = "StandardSSD_LRS"
    },
    {
      name                 = "disk2"
      disk_size_gb         = 200
      storage_account_type = "Standard_LRS"
    }
  ]

}
