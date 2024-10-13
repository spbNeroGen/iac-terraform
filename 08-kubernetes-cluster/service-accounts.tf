resource "yandex_iam_service_account" "sa-cluster" {
  name        = "sa-cluster"
  description = "K8S regional service account"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.sa-cluster.id}"
  depends_on = [
    yandex_iam_service_account.sa-cluster
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-cluster.id}"
  depends_on = [
    yandex_iam_service_account.sa-cluster
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vm-editor-role" {
  folder_id = var.folder_id
  role = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-cluster.id}",
  ]
  depends_on = [
    yandex_iam_service_account.sa-cluster
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-cluster.id}"
  depends_on = [
    yandex_iam_service_account.sa-cluster
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-pusher" {
  folder_id = var.folder_id
  role = "container-registry.images.pusher"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-cluster.id}",
  ]

  depends_on = [
    yandex_iam_service_account.sa-cluster
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa-cluster.id}"
  depends_on = [
    yandex_iam_service_account.sa-cluster
  ]
}

resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
  depends_on = [
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
}