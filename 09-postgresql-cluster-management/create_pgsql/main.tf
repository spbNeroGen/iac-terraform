terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}

variable "network_id" {
}

variable "cluster_name" {
  description = "Unique for the cloud name of a cluster"
}

variable "description" {
  type    = string
  default = null
}

variable "environment" {
  type        = string
  default     = "PRODUCTION"
  description = "PRODUCTION or PRESTABLE. Prestable gets updates before production environment"
}

variable "database_version" {
  type        = string
  default     = "16"
  description = "Version of PostgreSQL"
}

variable "resource_preset_id" {
  type        = string
  default     = "s2.small"
  description = "Id of a resource preset which means count of vCPUs and amount of RAM per host"
}

variable "disk_size" {
  type        = number
  default     = 100
  description = "Disk size in GiB"
}

variable "disk_type_id" {
  type        = string
  default     = "network-ssd"
  description = "Disk type: 'network-ssd', 'network-hdd', 'local-ssd'"
}

variable "labels" {
  default = {
    source = "terraform"
    env    = "stage"

  }
}

variable "users" {
  type = list(object(
    {
      name     = string
      password = string
    }
  ))
  default = [
    {
      name     = "user1"
      password = ""
    }
  ]
}

variable "user_permissions" {
  type = map(list(object(
    {
      database_name = string
    }
  )))
  default = {
    "user1" : [
      {
        database_name = "db1"
      }
    ]
  }
}

variable "databases" {
  type = list(object({
    name  = string
    owner = string
  }))
  default = [{
    name  = "db1"
    owner = "user1"
  }]
}

variable "hosts" {
  type = list(object({
    zone             = string
    subnet_id        = string
    assign_public_ip = bool
  }))
}

resource "random_password" "pwd" {
  length           = 18
  special          = true
  override_special = "_!%@"
}

resource "yandex_mdb_postgresql_cluster" "managed_postgresql" {
  name        = var.cluster_name
  network_id  = var.network_id
  description = var.description
  labels      = var.labels
  environment = var.environment

    config {
        version = var.database_version
        resources {
        resource_preset_id = var.resource_preset_id
        disk_size          = var.disk_size
        disk_type_id       = var.disk_type_id
        }
  }

  dynamic "host" {
    for_each = var.hosts
    content {
      zone             = host.value.zone
      subnet_id        = host.value.subnet_id
      assign_public_ip = host.value.assign_public_ip
    }
  }
}

resource "yandex_mdb_postgresql_user" "users" {
  for_each = { for user in var.users : user.name => user }

  cluster_id = yandex_mdb_postgresql_cluster.managed_postgresql.id
  name       = each.value.name
  password   = each.value.password == "" || each.value.password == null ? random_password.pwd.result : each.value.password
}

# ресурс для создания баз данных с зависимостью от пользователей
resource "yandex_mdb_postgresql_database" "databases" {
  for_each = { for db in var.databases : db.name => db }

  cluster_id = yandex_mdb_postgresql_cluster.managed_postgresql.id
  name       = each.value.name
  owner      = each.value.owner

  depends_on = [yandex_mdb_postgresql_user.users]
}
# Outputs for PGSql cluster
output "cluster_id" {
  description = "ID of the created PostgreSQL cluster"
  value       = yandex_mdb_postgresql_cluster.managed_postgresql.id
}

output "cluster_name" {
  description = "Name of the created PostgreSQL cluster"
  value       = yandex_mdb_postgresql_cluster.managed_postgresql.name
}

output "user_ids" {
  description = "List of created PostgreSQL user IDs"
  value       = [for user in yandex_mdb_postgresql_user.users : user.id]
}

output "database_ids" {
  description = "List of created PostgreSQL database IDs"
  value       = [for db in yandex_mdb_postgresql_database.databases : db.id]
}

output "user_passwords" {
  value = {
    for user in yandex_mdb_postgresql_user.users :
    user.name => user.password
  }
}