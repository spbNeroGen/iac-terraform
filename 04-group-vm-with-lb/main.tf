data "yandex_compute_image" "ubuntu-2204" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "network-group" {
  name = "network-group"
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-group.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_compute_instance" "group-vms" {
  name        = "vm-${count.index}"
  platform_id = "standard-v2"
  count       = var.count_vm

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
        subnet_id = yandex_vpc_subnet.subnet-a.id
        nat       = true
    }
    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
        user-data = <<EOF
#cloud-config
runcmd:
  - apt-get update
  - apt-get install -y nginx

# Автоматический запуск nginx
  - systemctl start nginx
  - systemctl enable nginx

# Создаем тестовый HTML-файл для nginx
write_files:
  - path: /var/www/html/index.html
    content: |
      <html>
      <head><title>Welcome to Your Cloud Server</title></head>
      <body>
      <h1>Success! Your cloud-init setup works!</h1>
      <p>VM Name: vm-${count.index}</p>
      </body>
      </html>
EOF
    }
 depends_on = [yandex_vpc_subnet.subnet-a]
}
