output "db_server" {
  value = module.aurora_cluster.cluster_endpoint
}

output "db_name" {
  value = module.aurora_cluster.cluster_database_name
}

output "db_port" {
  value = module.aurora_cluster.cluster_port
}