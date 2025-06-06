#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "repository" {
  type        = string
  default     = ""
  description = "Terraform current module repo"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the module creation."
}

variable "machine_count" {
  type        = number
  default     = 1
  description = "Number of Virtual Machines to create."
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  default     = ""
  description = "Location where resource should be created."
}

variable "create" {
  type        = string
  default     = "60m"
  description = "Used when creating the Resource Group."
}

variable "update" {
  type        = string
  default     = "60m"
  description = "Used when updating the Resource Group."
}

variable "read" {
  type        = string
  default     = "5m"
  description = "Used when retrieving the Resource Group."
}

variable "delete" {
  type        = string
  default     = "60m"
  description = "Used when deleting the Resource Group."
}

variable "vm_addon_name" {
  type        = string
  default     = null
  description = "The name of the addon Virtual machine's name."
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "List of IP addresses of DNS servers."
}

variable "enable_ip_forwarding" {
  type        = bool
  default     = false
  description = "Should IP Forwarding be enabled? Defaults to false."
}

variable "enable_accelerated_networking" {
  type        = bool
  default     = false
  description = "Should Accelerated Networking be enabled? Defaults to false."
}

variable "internal_dns_name_label" {
  type        = string
  default     = null
  description = "The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network."
}

variable "subnet_id" {
  type        = list(any)
  default     = []
  description = "The ID of the Subnet where this Network Interface should be located in."
}

variable "private_ip_address_version" {
  type        = string
  default     = "IPv4"
  description = "The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4."
}

variable "private_ip_address_allocation" {
  type        = string
  default     = "Static"
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
}

variable "primary" {
  type        = bool
  default     = true
  description = "Is this the Primary IP Configuration? Must be true for the first ip_configuration when multiple are specified. Defaults to false."
}

variable "private_ip_addresses" {
  type        = list(any)
  default     = []
  description = "The Static IP Address which should be used."
}

variable "availability_set_enabled" {
  type        = bool
  default     = false
  description = "Whether availability set is enabled."
}

variable "platform_update_domain_count" {
  type        = number
  default     = 5
  description = "Specifies the number of update domains that are used. Defaults to 5."
}

variable "platform_fault_domain_count" {
  type        = number
  default     = 3
  description = "Specifies the number of fault domains that are used. Defaults to 3."
}

variable "proximity_placement_group_id" {
  type        = string
  default     = null
  description = "The ID of the Proximity Placement Group to which this Virtual Machine should be assigned."
}

variable "managed" {
  type        = bool
  default     = true
  description = "Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic). Default is true."
}

variable "public_ip_enabled" {
  type        = bool
  default     = false
  description = "Whether public IP is enabled."
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
}

variable "allocation_method" {
  type        = string
  default     = "Static"
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
}

variable "ip_version" {
  type        = string
  default     = "IPv4"
  description = "The IP Version to use, IPv6 or IPv4."
}

variable "idle_timeout_in_minutes" {
  type        = number
  default     = 10
  description = "Specifies the timeout for the TCP idle connection. The value can be set between 4 and 60 minutes."
}

variable "domain_name_label" {
  type        = string
  default     = null
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "reverse_fqdn" {
  type        = string
  default     = ""
  description = "A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
}

variable "public_ip_prefix_id" {
  type        = string
  default     = null
  description = "If specified then public IP address allocated will be provided from the public IP prefix resource."
}

variable "boot_diagnostics_enabled" {
  type        = bool
  default     = false
  description = "Whether boot diagnostics block is enabled."
}


variable "identity_enabled" {
  type        = bool
  default     = true
  description = "Whether identity block is enabled."
}

variable "vm_size" {
  type        = string
  default     = ""
  description = "Specifies the size of the Virtual Machine."
}

variable "enable_os_disk_write_accelerator" {
  type        = bool
  default     = false
  description = "Should Write Accelerator be Enabled for this OS Disk? This requires that the `storage_account_type` is set to `Premium_LRS` and that `caching` is set to `None`."
}

variable "license_type" {
  type        = string
  default     = "Windows_Client"
  description = "Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows_Client and Windows_Server."
}

variable "disable_password_authentication" {
  type        = bool
  default     = true
  description = "Specifies whether password authentication should be disabled."
}

variable "provision_vm_agent" {
  type        = bool
  default     = true
  description = "Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to false."
}

variable "os_disk_storage_account_type" {
  type        = string
  default     = "StandardSSD_LRS"
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
}

variable "timezone" {
  type        = string
  default     = ""
  description = "Specifies the time zone of the virtual machine."
}

variable "addtional_capabilities_enabled" {
  type        = bool
  default     = false
  description = "Whether additional capabilities block is enabled."
}

variable "ultra_ssd_enabled" {
  type        = bool
  default     = false
  description = "Should Ultra SSD disk be enabled for this Virtual Machine?."
}

variable "vm_identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "The Managed Service Identity Type of this Virtual Machine. Possible values are SystemAssigned and UserAssigned."
}

variable "identity_ids" {
  type        = list(any)
  default     = []
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
}

variable "admin_username" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Specifies the name of the local administrator account.NOTE:- Optional for Linux Vm but REQUIRED for Windows VM"
}

variable "source_image_id" {
  type        = any
  default     = null
  description = "The ID of an Image which each Virtual Machine should be based on"
}

variable "admin_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "The password associated with the local administrator account.NOTE:- Optional for Linux Vm but REQUIRED for Windows VM"
}

variable "is_vm_windows" {
  type        = bool
  default     = false
  description = "Create Windows Virtual Machine."
}

variable "is_vm_linux" {
  type        = bool
  default     = false
  description = "Create Linux Virtual Machine."
}

variable "plan_enabled" {
  type        = bool
  default     = false
  description = "Whether plan block is enabled."
}

variable "plan_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the image from the marketplace."
}

variable "plan_publisher" {
  type        = string
  default     = ""
  description = "Specifies the publisher of the image."
}

variable "plan_product" {
  type        = string
  default     = ""
  description = "Specifies the product of the image from the marketplace."
}

variable "create_option" {
  type        = string
  default     = "Empty"
  description = "Specifies how the azure managed Disk should be created. Possible values are Attach (managed disks only) and FromImage."
}

variable "caching" {
  type        = string
  default     = "ReadWrite"
  description = "Specifies the caching requirements for the OS Disk. Possible values include None, ReadOnly and ReadWrite."
}

variable "computer_name" {
  type        = string
  default     = null
  description = "Name of the Windows Computer Name."
}

variable "disk_size_gb" {
  type        = number
  default     = 30
  description = "Specifies the size of the OS Disk in gigabytes."
}

variable "write_accelerator_enabled" {
  type        = bool
  default     = false
  description = "Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS managed disks with no caching and M-Series VMs. Defaults to false."
}

variable "storage_image_reference_enabled" {
  type        = bool
  default     = true
  description = "Whether storage image reference is enabled."
}

variable "custom_image_id" {
  type        = string
  default     = ""
  description = "Specifies the ID of the Custom Image which the Virtual Machine should be created from."
}

variable "image_publisher" {
  type        = string
  default     = ""
  description = "Specifies the publisher of the image used to create the virtual machine."
}

variable "image_offer" {
  type        = string
  default     = ""
  description = "Specifies the offer of the image used to create the virtual machine."
}

variable "image_sku" {
  type        = string
  default     = ""
  description = "Specifies the SKU of the image used to create the virtual machine."
}

variable "image_version" {
  type        = string
  default     = "latest"
  description = "Specifies the version of the image used to create the virtual machine."
}

variable "network_interface_sg_enabled" {
  type        = bool
  default     = false
  description = "Whether network interface security group is enabled."
}

variable "network_security_group_id" {
  type        = string
  default     = ""
  description = "The ID of the Network Security Group which should be attached to the Network Interface."
}

variable "blob_endpoint" {
  type        = string
  default     = ""
  description = "The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files"
}

variable "ddos_protection_mode" {
  type        = string
  default     = "VirtualNetworkInherited"
  description = "The DDoS protection mode of the public IP"
}

variable "public_key" {
  type        = string
  default     = null
  description = "Name  (e.g. `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQ`)."
  sensitive   = true
}

variable "vm_availability_zone" {
  type        = any
  default     = null
  description = "(Optional) Specifies the Availability Zone in which this Virtual Machine should be located. Changing this forces a new Virtual Machine to be created."
}

variable "enable_disk_encryption_set" {
  type    = bool
  default = false
}

variable "key_vault_id" {
  type    = any
  default = null
}

variable "enable_encryption_at_host" {
  type        = bool
  default     = true
  description = "Flag to control Disk Encryption at host level"
}

variable "data_disks" {
  type = list(object({
    name                 = string
    storage_account_type = string
    disk_size_gb         = number
  }))
  default     = []
  description = "Managed Data Disks for azure virtual machine"
}

variable "key_vault_rbac_auth_enabled" {
  type        = bool
  default     = true
  description = "Flag to state whether rbac authorization is used in key vault or access policy."
}

variable "extensions" {
  type = list(object({
    extension_publisher            = string
    extension_name                 = string
    extension_type                 = string
    extension_type_handler_version = string
    auto_upgrade_minor_version     = bool
    automatic_upgrade_enabled      = bool
    settings                       = optional(string, "{}") # Optional, defaults to empty JSON string
    protected_settings             = optional(string, "{}") # Optional, defaults to empty JSON string
  }))

  default     = []
  description = "List of extensions for Azure Virtual Machine"
}


variable "log_analytics_destination_type" {
  type        = string
  default     = "AzureDiagnostics"
  description = "Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
}

variable "metric_enabled" {
  type        = bool
  default     = true
  description = "Is this Diagnostic Metric enabled? Defaults to true."
}

variable "pip_logs" {
  type = object({
    enabled        = bool
    category       = optional(list(string))
    category_group = optional(list(string))
  })

  default = {
    enabled        = true
    category_group = ["AllLogs"]
  }
}

variable "diagnostic_setting_enable" {
  type    = bool
  default = false
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the Storage Account where logs should be sent."
}

variable "eventhub_name" {
  type        = string
  default     = null
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent."
}

variable "eventhub_authorization_rule_id" {
  type        = string
  default     = null
  description = "Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
}

variable "dedicated_host_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with dedicated_host_group_id."
}

variable "enable_automatic_updates" {
  type        = bool
  default     = true
  description = "(Optional) Specifies if Automatic Updates are Enabled for the Windows Virtual Machine. Changing this forces a new resource to be created. Defaults to true."
}

variable "windows_patch_mode" {
  type        = string
  default     = "AutomaticByPlatform"
  description = "Optional) Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS. "
}

variable "linux_patch_mode" {
  type        = string
  default     = "ImageDefault"
  description = "(Optional) Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are AutomaticByPlatform and ImageDefault. Defaults to ImageDefault"
}

variable "patch_assessment_mode" {
  type        = string
  default     = "ImageDefault"
  description = "(Optional) Specifies the mode of VM Guest Patching for the Virtual Machine. Possible values are AutomaticByPlatform or ImageDefault. Defaults to ImageDefault."
}

variable "allow_extension_operations" {
  type        = bool
  default     = true
  description = "(Optional) Should Extension Operations be allowed on this Virtual Machine? Defaults to true."
}

variable "role_definition_name" {
  type        = string
  default     = "Key Vault Crypto Service Encryption User"
  description = "The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role_definition_id."
}

variable "key_type" {
  type        = string
  default     = "RSA"
  description = "Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM. Changing this forces a new resource to be created."
}

variable "key_size" {
  type        = number
  default     = 2048
  description = " Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key_type is RSA or RSA-HSM. Changing this forces a new resource to be created."
}

variable "user_object_id" {
  type = map(object({
    role_definition_name = string
    principal_id         = string
  }))
  default     = {}
  description = "The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created."
}
variable "user_data" {
  type        = string
  default     = null // Adjust this path accordingly
  description = "(Optional) A string of the desired User Data for the vm.(path/to/user-data.sh)"
}

variable "public_network_access_enabled" {
  default = true
  type    = bool
}

variable "vault_sku" {
  default = "Standard"
  type    = string
}


variable "backup_policy_time" {
  description = "(Optional) Indicates the time for when to execute the backup policy"
  default     = "23:00"
  type        = string
}

variable "backup_policy_time_zone" {
  description = "(Optional) Indicates the timezone that the policy will use"
  default     = "UTC"
  type        = string
}

variable "backup_policy_frequency" {
  description = "(Optional) Indicate the fequency to use for the backup policy"
  default     = "Daily"
  type        = string

  validation {
    condition     = contains(["Daily", "Weekly", "Hourly"], var.backup_policy_frequency)
    error_message = "The value must be set to one of the following: Daily, Weekly, Hourly"
  }

}

variable "backup_policy_type" {
  description = "(Optional) Indicates which version type to use when creating the backup policy"
  default     = "V1"
  type        = string

  validation {
    condition     = contains(["V1", "V2"], var.backup_policy_type)
    error_message = "The value must be set to one of the following: V1, V2"
  }
}


variable "backup_enabled" {
  description = "Added Backup Policy and Service Vault for the Virtual Machine"
  type        = bool
  default     = false
}


variable "backup_policy_retention" {
  type = map(object({
    enabled   = bool
    frequency = string
    count     = string
    weekdays  = list(string)
    weeks     = list(string)
  }))
  default = {
    daily = {
      enabled   = true
      frequency = "Daily"
      count     = "7"
      weekdays  = []
      weeks     = []
    },
    weekly = {
      enabled   = false
      frequency = "Weekly"
      count     = "4"
      weekdays  = ["Saturday"]
      weeks     = []
    },
    monthly = {
      enabled   = false
      frequency = "Monthly"
      count     = "3"
      weekdays  = ["Saturday"]
      weeks     = ["Last"]
    }
  }
}

variable "vault_service" {
  default     = null
  type        = string
  description = "Value for Service Vault ID"
}

variable "backup_policy" {
  default     = null
  type        = string
  description = "Value for Backup Policy ID"

}