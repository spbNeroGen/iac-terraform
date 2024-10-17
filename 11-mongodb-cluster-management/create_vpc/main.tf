terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}
variable "network_name" {
  default = "default"
}

variable "subnets" {
  type = map(object({
    zone           = string
    v4_cidr_blocks = list(string)
  }))
}

resource "yandex_vpc_network" "vpc_network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet" {
  count = length(keys(var.subnets))

  name           = keys(var.subnets)[count.index]
  zone           = lookup(var.subnets, keys(var.subnets)[count.index]).zone
  v4_cidr_blocks = lookup(var.subnets, keys(var.subnets)[count.index]).v4_cidr_blocks
  network_id     = yandex_vpc_network.vpc_network.id
}

resource "yandex_vpc_security_group" "security_group" {
  name       = "${var.network_name}-sg"
  network_id = yandex_vpc_network.vpc_network.id

  ingress {
    description    = "MongoDB"
    port           = 27018
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Outputs
output "vpc_network_id" {
  value = yandex_vpc_network.vpc_network.id
}

output "subnet_ids_by_zones" {
  value = {
    for instance in yandex_vpc_subnet.subnet :
    instance.zone => instance.id
  }
}


output "security_group_id" {
  value = yandex_vpc_security_group.security_group.id
}