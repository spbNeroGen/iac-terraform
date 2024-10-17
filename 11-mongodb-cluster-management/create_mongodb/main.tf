terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}

variable "cluster_name" {
  type = string
}

variable "network_id" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "security_group_ids" {
  type = list(string)
}

variable "environment" {
  type    = string
  default = "PRODUCTION"
}

variable "hosts" {
  type = list(object({
    zone_id   = string
    subnet_id = string
    type      = string
  }))
}

variable "databases" {
  type = list(object({
    name = string
  }))
}

variable "users" {
  type = list(object({
    name     = string
    password = string
  }))
}

resource "yandex_mdb_mongodb_cluster" "mongodb" {
  name                = var.cluster_name
  network_id          = var.network_id
  security_group_ids  = var.security_group_ids
  deletion_protection = false
  environment         = var.environment
  
  timeouts {
    create = "1h30m" # Полтора часа
    update = "2h"    # 2 часа
  }

  cluster_config {
    version = var.cluster_version
  }

  resources_mongod {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  resources_mongoinfra {
    resource_preset_id = "c3-c2-m4"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  dynamic "host" {
    for_each = var.hosts
    content {
      zone_id   = host.value.zone_id
      subnet_id = host.value.subnet_id
      type      = host.value.type
    }
  }
}

resource "yandex_mdb_mongodb_database" "db" {
  for_each   = { for db in var.databases : db.name => db } 
  cluster_id = yandex_mdb_mongodb_cluster.mongodb.id
  name       = each.key  
}

resource "yandex_mdb_mongodb_user" "user" {
  for_each   = { for user in var.users : user.name => user }  
  cluster_id = yandex_mdb_mongodb_cluster.mongodb.id
  name       = each.key 
  password   = each.value.password 

  permission {
    database_name = var.databases[0].name
  }

  depends_on = [
    yandex_mdb_mongodb_database.db
  ]
}
