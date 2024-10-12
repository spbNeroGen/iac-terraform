locals {
  storage_instances = yandex_compute_instance.vm_storage[*]
}

resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = [for w in yandex_compute_instance.vm-web : {
      name = w.name,
      id = w.id,
      nat_ip_address = try(w.network_interface[0].nat_ip_address, "")
    }],
    dbservers = [for d in yandex_compute_instance.vm-db : {
      name = d.name,
      id = d.id,
      nat_ip_address = try(d.network_interface[0].nat_ip_address, "")
    }],
    storages = [for s in local.storage_instances : {
      name = s.name,
      id = s.id,
      nat_ip_address = try(s.network_interface[0].nat_ip_address, "")
    }]

  })
  filename = "${abspath(path.module)}/inventory.ini"
}