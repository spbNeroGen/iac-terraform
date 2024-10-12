data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_vpc_network" "main-network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "main-network-subnet" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = var.default_cidr
}
