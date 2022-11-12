# Ta-da! Here are all the outputs supported by Terraform.
output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.redis_replication.configuration_endpoint_address
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis_replication.primary_endpoint_address
}

output "reader_endpoint_address" {
  value = aws_elasticache_replication_group.redis_replication.reader_endpoint_address
}

output "arn" {
  value = aws_elasticache_replication_group.redis_replication.arn
}

output "engine_version_actual" {
  value = aws_elasticache_replication_group.redis_replication.engine_version_actual
}

output "cluster_enabled" {
  value = aws_elasticache_replication_group.redis_replication.cluster_enabled
}

output "id" {
  value = aws_elasticache_replication_group.redis_replication.id
}

output "member_clusters" {
  value = aws_elasticache_replication_group.redis_replication.member_clusters
}

output "tags_all" {
  value = aws_elasticache_replication_group.redis_replication.tags_all
}
