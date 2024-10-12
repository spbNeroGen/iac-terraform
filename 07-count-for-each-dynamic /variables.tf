###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}


variable "vpc_name" {
  type        = string
  default     = "main-network"
  description = "VPC network&subnet name"
}

variable "image_family" {
  description = "The family of the image to use for the boot disk"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "platform_id" {
  type        = string
  description = "Platform ID for VM"
  default     = "standard-v2"
}

//VMs - WEB
variable "vm_web_cores" {
  type        = number
  description = "Number of cores for VM web"
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  description = "Amount of memory for VM web"
  default     = 2
}

variable "vm_web_core_fraction" {
  type        = number
  description = "Core fraction for VM web"
  default     = 20
}

//VMs - storage
variable "vm_storage_cores" {
  type        = number
  description = "Number of cores for VM web"
  default     = 2
}

variable "vm_storage_memory" {
  type        = number
  description = "Amount of memory for VM web"
  default     = 2
}

variable "vm_storage_core_fraction" {
  type        = number
  description = "Core fraction for VM web"
  default     = 20
}

//VMs - DB
variable "each_vm" {
  description = "Specifications for each VM"
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    core_fraction = number
    disk_volume   = number
  }))
  default = [
    {
      vm_name       = "db-main",
      cpu           = 2,
      ram           = 2,
      core_fraction = 20,
      disk_volume   = 20
      
    },
    {
      vm_name       = "db-replica",
      cpu           = 2,
      ram           = 2,
      core_fraction = 20,
      disk_volume   = 20
      
    }
  ]
}