resource "yandex_vpc_network" "main_network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main_network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private_route.id
}

# https://yandex.cloud/ru/docs/vpc/operations/static-route-create
resource "yandex_vpc_route_table" "private_route" {
  name = "private_route"
  network_id = yandex_vpc_network.main_network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = var.nat-instance-ip
  }
}

