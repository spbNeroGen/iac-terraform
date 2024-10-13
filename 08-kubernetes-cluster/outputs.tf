output "cluster-config" {
  value = <<COMMAND
    # Get the k8s config :)
    yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.kuber-cluster.id} --external --force
  COMMAND
}