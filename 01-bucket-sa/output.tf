output "access_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  description = "Access_key for SA"
}

output "secret_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  description = "Secret_key for SA"
  sensitive = true
}