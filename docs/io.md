## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addtional\_capabilities\_enabled | Whether additional capabilities block is enabled. | `bool` | `false` | no |
| admin\_password | The password associated with the local administrator account.NOTE:- Optional for Linux Vm but REQUIRED for Windows VM | `string` | `null` | no |
| admin\_username | Specifies the name of the local administrator account.NOTE:- Optional for Linux Vm but REQUIRED for Windows VM | `string` | `""` | no |
| allocation\_method | Defines the allocation method for this IP address. Possible values are Static or Dynamic. | `string` | `"Static"` | no |
| allow\_extension\_operations | (Optional) Should Extension Operations be allowed on this Virtual Machine? Defaults to true. | `bool` | `true` | no |
| availability\_set\_enabled | Whether availability set is enabled. | `bool` | `false` | no |
| backup\_enabled | Added Backup Policy and Service Vault for the Virtual Machine | `bool` | `false` | no |
| backup\_policy | Value for Backup Policy ID | `string` | `null` | no |
| backup\_policy\_frequency | (Optional) Indicate the fequency to use for the backup policy | `string` | `"Daily"` | no |
| backup\_policy\_retention | n/a | <pre>map(object({<br>    enabled   = bool<br>    frequency = string<br>    count     = string<br>    weekdays  = list(string)<br>    weeks     = list(string)<br>  }))</pre> | <pre>{<br>  "daily": {<br>    "count": "7",<br>    "enabled": true,<br>    "frequency": "Daily",<br>    "weekdays": [],<br>    "weeks": []<br>  },<br>  "monthly": {<br>    "count": "3",<br>    "enabled": false,<br>    "frequency": "Monthly",<br>    "weekdays": [<br>      "Saturday"<br>    ],<br>    "weeks": [<br>      "Last"<br>    ]<br>  },<br>  "weekly": {<br>    "count": "4",<br>    "enabled": false,<br>    "frequency": "Weekly",<br>    "weekdays": [<br>      "Saturday"<br>    ],<br>    "weeks": []<br>  }<br>}</pre> | no |
| backup\_policy\_time | (Optional) Indicates the time for when to execute the backup policy | `string` | `"23:00"` | no |
| backup\_policy\_time\_zone | (Optional) Indicates the timezone that the policy will use | `string` | `"UTC"` | no |
| backup\_policy\_type | (Optional) Indicates which version type to use when creating the backup policy | `string` | `"V1"` | no |
| blob\_endpoint | The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files | `string` | `""` | no |
| boot\_diagnostics\_enabled | Whether boot diagnostics block is enabled. | `bool` | `false` | no |
| caching | Specifies the caching requirements for the OS Disk. Possible values include None, ReadOnly and ReadWrite. | `string` | `"ReadWrite"` | no |
| computer\_name | Name of the Windows Computer Name. | `string` | `null` | no |
| create | Used when creating the Resource Group. | `string` | `"60m"` | no |
| create\_option | Specifies how the azure managed Disk should be created. Possible values are Attach (managed disks only) and FromImage. | `string` | `"Empty"` | no |
| custom\_image\_id | Specifies the ID of the Custom Image which the Virtual Machine should be created from. | `string` | `""` | no |
| data\_disks | Managed Data Disks for azure virtual machine | <pre>list(object({<br>    name                 = string<br>    storage_account_type = string<br>    disk_size_gb         = number<br>  }))</pre> | `[]` | no |
| ddos\_protection\_mode | The DDoS protection mode of the public IP | `string` | `"VirtualNetworkInherited"` | no |
| dedicated\_host\_id | (Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with dedicated\_host\_group\_id. | `string` | `null` | no |
| delete | Used when deleting the Resource Group. | `string` | `"60m"` | no |
| diagnostic\_setting\_enable | n/a | `bool` | `false` | no |
| disable\_password\_authentication | Specifies whether password authentication should be disabled. | `bool` | `true` | no |
| disk\_size\_gb | Specifies the size of the OS Disk in gigabytes. | `number` | `30` | no |
| dns\_servers | List of IP addresses of DNS servers. | `list(string)` | `[]` | no |
| domain\_name\_label | Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. | `string` | `null` | no |
| enable\_accelerated\_networking | Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| enable\_automatic\_updates | (Optional) Specifies if Automatic Updates are Enabled for the Windows Virtual Machine. Changing this forces a new resource to be created. Defaults to true. | `bool` | `true` | no |
| enable\_disk\_encryption\_set | n/a | `bool` | `false` | no |
| enable\_encryption\_at\_host | Flag to control Disk Encryption at host level | `bool` | `true` | no |
| enable\_ip\_forwarding | Should IP Forwarding be enabled? Defaults to false. | `bool` | `false` | no |
| enable\_os\_disk\_write\_accelerator | Should Write Accelerator be Enabled for this OS Disk? This requires that the `storage_account_type` is set to `Premium_LRS` and that `caching` is set to `None`. | `bool` | `false` | no |
| enabled | Flag to control the module creation. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| eventhub\_authorization\_rule\_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | `string` | `null` | no |
| eventhub\_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. | `string` | `null` | no |
| extensions | List of extensions for Azure Virtual Machine | <pre>list(object({<br>    extension_publisher            = string<br>    extension_name                 = string<br>    extension_type                 = string<br>    extension_type_handler_version = string<br>    auto_upgrade_minor_version     = bool<br>    automatic_upgrade_enabled      = bool<br>    settings                       = optional(string, "{}") # Optional, defaults to empty JSON string<br>    protected_settings             = optional(string, "{}") # Optional, defaults to empty JSON string<br>  }))</pre> | `[]` | no |
| identity\_enabled | Whether identity block is enabled. | `bool` | `true` | no |
| identity\_ids | Specifies a list of user managed identity ids to be assigned to the VM. | `list(any)` | `[]` | no |
| idle\_timeout\_in\_minutes | Specifies the timeout for the TCP idle connection. The value can be set between 4 and 60 minutes. | `number` | `10` | no |
| image\_offer | Specifies the offer of the image used to create the virtual machine. | `string` | `""` | no |
| image\_publisher | Specifies the publisher of the image used to create the virtual machine. | `string` | `""` | no |
| image\_sku | Specifies the SKU of the image used to create the virtual machine. | `string` | `""` | no |
| image\_version | Specifies the version of the image used to create the virtual machine. | `string` | `"latest"` | no |
| internal\_dns\_name\_label | The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network. | `string` | `null` | no |
| ip\_version | The IP Version to use, IPv6 or IPv4. | `string` | `"IPv4"` | no |
| is\_vm\_linux | Create Linux Virtual Machine. | `bool` | `false` | no |
| is\_vm\_windows | Create Windows Virtual Machine. | `bool` | `false` | no |
| key\_size | Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key\_type is RSA or RSA-HSM. Changing this forces a new resource to be created. | `number` | `2048` | no |
| key\_type | Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM. Changing this forces a new resource to be created. | `string` | `"RSA"` | no |
| key\_vault\_id | n/a | `any` | `null` | no |
| key\_vault\_rbac\_auth\_enabled | Flag to state whether rbac authorization is used in key vault or access policy. | `bool` | `true` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| license\_type | Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows\_Client and Windows\_Server. | `string` | `"Windows_Client"` | no |
| linux\_patch\_mode | (Optional) Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are AutomaticByPlatform and ImageDefault. Defaults to ImageDefault | `string` | `"ImageDefault"` | no |
| location | Location where resource should be created. | `string` | `""` | no |
| log\_analytics\_destination\_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| log\_analytics\_workspace\_id | n/a | `string` | `null` | no |
| machine\_count | Number of Virtual Machines to create. | `number` | `1` | no |
| managed | Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic). Default is true. | `bool` | `true` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| metric\_enabled | Is this Diagnostic Metric enabled? Defaults to true. | `bool` | `true` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| network\_interface\_sg\_enabled | Whether network interface security group is enabled. | `bool` | `false` | no |
| network\_security\_group\_id | The ID of the Network Security Group which should be attached to the Network Interface. | `string` | `""` | no |
| os\_disk\_storage\_account\_type | The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard\_LRS, StandardSSD\_LRS and Premium\_LRS. | `string` | `"StandardSSD_LRS"` | no |
| patch\_assessment\_mode | (Optional) Specifies the mode of VM Guest Patching for the Virtual Machine. Possible values are AutomaticByPlatform or ImageDefault. Defaults to ImageDefault. | `string` | `"ImageDefault"` | no |
| pip\_logs | n/a | <pre>object({<br>    enabled        = bool<br>    category       = optional(list(string))<br>    category_group = optional(list(string))<br>  })</pre> | <pre>{<br>  "category_group": [<br>    "AllLogs"<br>  ],<br>  "enabled": true<br>}</pre> | no |
| plan\_enabled | Whether plan block is enabled. | `bool` | `false` | no |
| plan\_name | Specifies the name of the image from the marketplace. | `string` | `""` | no |
| plan\_product | Specifies the product of the image from the marketplace. | `string` | `""` | no |
| plan\_publisher | Specifies the publisher of the image. | `string` | `""` | no |
| platform\_fault\_domain\_count | Specifies the number of fault domains that are used. Defaults to 3. | `number` | `3` | no |
| platform\_update\_domain\_count | Specifies the number of update domains that are used. Defaults to 5. | `number` | `5` | no |
| primary | Is this the Primary IP Configuration? Must be true for the first ip\_configuration when multiple are specified. Defaults to false. | `bool` | `true` | no |
| private\_ip\_address\_allocation | The allocation method used for the Private IP Address. Possible values are Dynamic and Static. | `string` | `"Static"` | no |
| private\_ip\_address\_version | The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4. | `string` | `"IPv4"` | no |
| private\_ip\_addresses | The Static IP Address which should be used. | `list(any)` | `[]` | no |
| provision\_vm\_agent | Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to false. | `bool` | `true` | no |
| proximity\_placement\_group\_id | The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. | `string` | `null` | no |
| public\_ip\_enabled | Whether public IP is enabled. | `bool` | `false` | no |
| public\_ip\_prefix\_id | If specified then public IP address allocated will be provided from the public IP prefix resource. | `string` | `null` | no |
| public\_key | Name  (e.g. `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQ`). | `string` | `null` | no |
| public\_network\_access\_enabled | n/a | `bool` | `true` | no |
| read | Used when retrieving the Resource Group. | `string` | `"5m"` | no |
| repository | Terraform current module repo | `string` | `""` | no |
| resource\_group\_name | The name of the resource group in which to create the virtual network. | `string` | `""` | no |
| reverse\_fqdn | A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. | `string` | `""` | no |
| role\_definition\_name | The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role\_definition\_id. | `string` | `"Key Vault Crypto Service Encryption User"` | no |
| sku | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. | `string` | `"Basic"` | no |
| source\_image\_id | The ID of an Image which each Virtual Machine should be based on | `any` | `null` | no |
| storage\_account\_id | The ID of the Storage Account where logs should be sent. | `string` | `null` | no |
| storage\_image\_reference\_enabled | Whether storage image reference is enabled. | `bool` | `true` | no |
| subnet\_id | The ID of the Subnet where this Network Interface should be located in. | `list(any)` | `[]` | no |
| timezone | Specifies the time zone of the virtual machine. | `string` | `""` | no |
| ultra\_ssd\_enabled | Should Ultra SSD disk be enabled for this Virtual Machine?. | `bool` | `false` | no |
| update | Used when updating the Resource Group. | `string` | `"60m"` | no |
| user\_data | (Optional) A string of the desired User Data for the vm.(path/to/user-data.sh) | `string` | `null` | no |
| user\_object\_id | The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created. | <pre>map(object({<br>    role_definition_name = string<br>    principal_id         = string<br>  }))</pre> | `{}` | no |
| vault\_service | Value for Service Vault ID | `string` | `null` | no |
| vault\_sku | n/a | `string` | `"Standard"` | no |
| vm\_addon\_name | The name of the addon Virtual machine's name. | `string` | `null` | no |
| vm\_availability\_zone | (Optional) Specifies the Availability Zone in which this Virtual Machine should be located. Changing this forces a new Virtual Machine to be created. | `any` | `null` | no |
| vm\_identity\_type | The Managed Service Identity Type of this Virtual Machine. Possible values are SystemAssigned and UserAssigned. | `string` | `"SystemAssigned"` | no |
| vm\_size | Specifies the size of the Virtual Machine. | `string` | `""` | no |
| windows\_patch\_mode | Optional) Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS. | `string` | `"AutomaticByPlatform"` | no |
| write\_accelerator\_enabled | Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium\_LRS managed disks with no caching and M-Series VMs. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| availability\_set\_id | The ID of the Availability Set. |
| disk\_encryption\_set-id | n/a |
| extension\_id | The ID of the Virtual Machine Extension. |
| key\_id | Id of key that is to be used for encrypting |
| linux\_virtual\_machine\_id | The ID of the Linux Virtual Machine. |
| network\_interface\_id | The ID of the Network Interface. |
| network\_interface\_private\_ip\_addresses | The private IP addresses of the network interface. |
| network\_interface\_sg\_association\_id | The (Terraform specific) ID of the Association between the Network Interface and the Network Interface. |
| public\_ip\_address | The IP address value that was allocated. |
| public\_ip\_id | The Public IP ID. |
| service\_vault\_id | The Principal ID associated with this Managed Service Identity. |
| service\_vault\_tenant\_id | The Tenant ID associated with this Managed Service Identity. |
| tags | The tags associated to resources. |
| vm\_backup\_policy\_id | The ID of the VM Backup Policy. |
| windows\_virtual\_machine\_id | The ID of the Windows Virtual Machine. |

