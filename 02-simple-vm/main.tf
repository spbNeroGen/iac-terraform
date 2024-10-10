data "yandex_compute_image" "ubuntu-2204" {
  family = "ubuntu-2204-lts"
}

data "yandex_vpc_network" "default" {
    name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-a" {
    name = "default-ru-central1-a"
}

resource "yandex_compute_instance" "simple-vm" {
  name        = "simple-vm"
  platform_id = "standard-v2"

    resources {
        cores  = 2
        memory = 4
        core_fraction = 20
    }

    boot_disk {
        initialize_params {
            size     = 30
            type     = "network-hdd"
            image_id = data.yandex_compute_image.ubuntu-2204.id
        }
    }

    network_interface {
        subnet_id = data.yandex_vpc_subnet.default-ru-central1-a.id
        nat       = true
    }

    metadata = {
         ssh-keys = "nerogen:${file("~/.ssh/id_ed25519.pub")}"
    }
}