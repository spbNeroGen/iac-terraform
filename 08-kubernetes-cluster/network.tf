resource "yandex_vpc_network" "main-network" {
  name = "network-internal"
}

resource "yandex_vpc_subnet" "internal-a" {
  name           = "internal-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["10.1.0.0/16"]
}

resource "yandex_vpc_subnet" "internal-b" {
  name           = "internal-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}

resource "yandex_vpc_subnet" "internal-d" {
  name           = "internal-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["10.3.0.0/16"]
}