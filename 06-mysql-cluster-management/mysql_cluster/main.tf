terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

variable "cluster_name" {
  description = "Name of the MySQL cluster"
}

variable "network_id" {
  description = "ID of the network"
}

variable "ha_enabled" {
  description = "Enable high availability for the cluster"
  type        = bool
  default     = true
}

variable "zone_and_cidr_blocks" {
  description = "Map of zone and CIDR blocks"
  type        = map
  default     = {
    "zone1" = {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.1.0.0/24"]
    },
    "zone2" = {
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.2.0.0/24"]
    }
  }
}

resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = var.cluster_name
  environment         = "PRODUCTION"
  network_id          = var.network_id
  version             = "8.0"

  host {
    zone      = var.zone_and_cidr_blocks["zone1"]["zone"]
    subnet_id = yandex_vpc_subnet.subnet_a.id
  }

  dynamic "host" {
    for_each = var.ha_enabled ? ["zone2"] : []
    content {
      zone      = var.zone_and_cidr_blocks["zone2"]["zone"]
      subnet_id = yandex_vpc_subnet.subnet_b[0].id
    }
  }
  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }
}

resource "yandex_vpc_subnet" "subnet_a" {
  name            = "subnet-a"
  network_id      = var.network_id
  zone            = var.zone_and_cidr_blocks["zone1"]["zone"]
  v4_cidr_blocks  = var.zone_and_cidr_blocks["zone1"]["v4_cidr_blocks"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  count           = var.ha_enabled ? 1 : 0
  name            = "subnet-b"
  network_id      = var.network_id
  zone            = var.zone_and_cidr_blocks["zone2"]["zone"]
  v4_cidr_blocks  = var.zone_and_cidr_blocks["zone2"]["v4_cidr_blocks"]
}

output "cluster_id" {
  value = yandex_mdb_mysql_cluster.mysql_cluster.id
}

output "cluster_host_ips" {
  value = yandex_mdb_mysql_cluster.mysql_cluster.host[*].fqdn
}
