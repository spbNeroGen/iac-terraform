## **10-dns-management**

- Управление DNS-записями с использованием `Yandex Cloud DNS`.
  - Создание одной или нескольких DNS зон с помощью ресурса `yandex_dns_zone`.
  - Cоздание DNS записей для зоны с использованием ресурса `yandex_dns_recordset`, позволяет управлять записями типа A, CNAME и другими.
  - Поддержка указания TTL (времени жизни) для каждой записи.
  - Включение поддержки приватных сетей через параметр `private_network_id`, что позволяет создавать приватные DNS зоны.

Пример **DNS-записей**:
```hcl
recordset = [
  {
    name = "www.example.com."
    type = "A"
    ttl  = 300
    data = ["192.0.2.1"]
  },
  {
    name = "api.example.com."
    type = "CNAME"
    ttl  = 300
    data = ["www.example.com."]
  },
  {
    name = "mail.example.com."
    type = "A"
    ttl  = 3600
    data = ["192.0.2.2"]
  },
  {
    name = "example.com."
    type = "MX"
    ttl  = 3600
    data = ["10 mail.example.com."]
  },
  {
    name = "example.com."
    type = "TXT"
    ttl  = 3600
    data = ["v=spf1 include:_spf.example.com ~all"]
  },
  {
    name = "ftp.example.com."
    type = "CNAME"
    ttl  = 300
    data = ["www.example.com."]
  },
  {
    name = "mail.example.com."
    type = "MX"
    ttl  = 3600
    data = ["20 mailbackup.example.com."]
  },
  {
    name = "example.com."
    type = "AAAA"
    ttl  = 300
    data = ["2001:db8::1"]
  },
  {
    name = "sub.example.com."
    type = "A"
    ttl  = 300
    data = ["192.0.2.3"]
  },
  {
    name = "example.com."
    type = "SRV"
    ttl  = 3600
    data = ["10 5 5060 sipserver.example.com."]
  }
]
```