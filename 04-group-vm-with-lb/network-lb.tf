# https://yandex.cloud/ru/docs/network-load-balancer/tf-ref
# https://yandex.cloud/ru/docs/network-load-balancer/concepts/?from=int-console-help-center-or-nav
resource "yandex_lb_target_group" "vms-group" {
  name      = "vms-group"


  dynamic "target" {
    for_each = [for i in yandex_compute_instance.group-vms : {
      address   = i.network_interface.0.ip_address
      subnet_id = i.network_interface.0.subnet_id
    }]

    content {
      subnet_id = target.value.subnet_id
      address   = target.value.address
    }
  }
    depends_on = [yandex_compute_instance.group-vms]
}

resource "yandex_lb_network_load_balancer" "lb-network" {
  name = "loadbalancer"
  type = "external"

  listener {
    name        = "listener"
    port        = 80
    target_port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.vms-group.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
  depends_on = [yandex_lb_target_group.vms-group]
}
