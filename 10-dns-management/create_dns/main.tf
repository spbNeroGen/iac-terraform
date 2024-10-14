terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}

resource "yandex_dns_zone" "main" {
  folder_id        = var.folder_id
  name             = var.name
  description      = var.description
  zone             = var.zone
  labels           = var.labels
  public           = var.public
  private_networks = var.private_network_id != "" ? [var.private_network_id] : []
}

resource "yandex_dns_recordset" "main" {
  count = length(var.recordset)

  zone_id = yandex_dns_zone.main.id
  name    = lookup(var.recordset[count.index], "name")
  type    = lookup(var.recordset[count.index], "type")
  ttl     = lookup(var.recordset[count.index], "ttl")
  data    = lookup(var.recordset[count.index], "data")
}

variable "folder_id" {
  type        = string
  description = "Yandex.Cloud folder ID"
}

variable "zone" {
  type        = string
  description = "The DNS name of this zone"
}

variable "name" {
  type        = string
  description = "User assigned name of the DNS zone"
}

variable "description" {
  type        = string
  description = "Description of the DNS zone"
}

variable "public" {
  type        = bool
  description = "Public"
  default     = false
}

variable "labels" {
  type        = map(any)
  default     = {}
  description = "A set of key/value label pairs to assign to the DNS zone"
}

variable "private_network_id" {
  type        = string
  description = "Private network ID (leave empty if not using private networks)"
}

variable "recordset" {
  description = "List of DNS Recordset"
  type = list(object({
    name = string
    type = string
    ttl  = number
    data = list(string)
  }))
  default = []
}

# Outputs
output "dns_zone_id" {
  value = yandex_dns_zone.main.id
}

output "dns_zone_name" {
  value = yandex_dns_zone.main.zone
}

output "recordset_ids" {
  value = [for record in yandex_dns_recordset.main : record.id]
}
