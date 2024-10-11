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

variable "vpc_name" {
  type        = string
  default     = "network-group"
  description = "VPC net & subnet"
}

variable "user_name" {
  type = string
  default     = "ubuntu"
}

variable "vm_base" {
  type = map(any)
  default = {
    cores         = 2,
    memory        = 4,
    core_fraction = 20,
    image_family  = "ubuntu-2404-lts"
    image_id = "fd8btqg2mh540ftne9p4"
    disk_size     = 30
  }
}

variable "nat-instance-ip" {
  default = "192.168.10.254"
}

variable "nat-instance-image-id" {
  default = "fd80mrhj8fl2oe87o4e1"
}