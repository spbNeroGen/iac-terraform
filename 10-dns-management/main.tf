variable "private_network_id" {
  description = "Private network ID (leave empty if not using private networks)"
  type        = string
  default     = "" # можно указать ID сети
}

module "dns_management" {
  source           = "./create_dns"
  folder_id       = var.folder_id
  name            = "example-dns-zone"
  description     = "DNS Zone for example project"
  zone            = "example.com."
  labels          = { env = "stage" }
  private_network_id = var.private_network_id
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
}