resource "yandex_iam_service_account" "sa-for-bucket" {
    name      = "sa-for-bucket"
}

resource "yandex_resourcemanager_folder_iam_member" "bucket-admin" {
    folder_id  = var.folder_id
    role       = "storage.admin"
    member     = "serviceAccount:${yandex_iam_service_account.sa-for-bucket.id}"
    depends_on = [yandex_iam_service_account.sa-for-bucket]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa-for-bucket.id
    description        = "static access key for bucket"
    depends_on         = [yandex_iam_service_account.sa-for-bucket]
}

resource "yandex_storage_bucket" "tf-nerogen-bucket" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket     = "tf-nerogen-bucket"
    max_size   = 2097152 //2Mb
    versioning {
        enabled = true
    }
    depends_on = [yandex_iam_service_account.sa-for-bucket]
}
