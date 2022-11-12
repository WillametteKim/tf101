locals {
  num_cache_clusters         = var.override == true ? var.num_cache_clusters : (var.environment == "prod" ? var.num_cache_clusters : 1)
  automatic_failover_enabled = var.override == true ? var.automatic_failover_enabled : (var.environment == "prod" ? var.automatic_failover_enabled : false)
  multi_az_enabled           = var.override == true ? var.multi_az_enabled : (var.environment == "prod" ? var.multi_az_enabled : false)
}

resource "random_shuffle" "maintenance_window" {
  input        = var.random_maintenance_window
  result_count = 1
}

resource "random_shuffle" "availability_zones" {
  input        = var.availability_zones
  result_count = local.num_cache_clusters
}

resource "aws_elasticache_replication_group" "redis_replication" {
  depends_on = [
    aws_security_group.this,
    aws_elasticache_subnet_group.this,
    aws_elasticache_parameter_group.this,
  ]

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  # Redis Setting
  preferred_cache_cluster_azs = var.availability_zones == "" ? random_shuffle.availability_zones.result : var.availability_zones
  engine                      = var.engine
  engine_version              = var.engine_version
  port                        = var.port
  node_type                   = var.node_type
  num_cache_clusters          = local.num_cache_clusters
  multi_az_enabled            = local.multi_az_enabled
  automatic_failover_enabled  = local.automatic_failover_enabled
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  replication_group_id        = "${var.environment}-${var.app_name}-redis"
  description                 = "${var.app_name} by terraform"
  parameter_group_name        = aws_elasticache_parameter_group.this.name

  snapshot_window          = var.create_snapshot ? var.snapshot_window : null
  snapshot_retention_limit = var.create_snapshot ? var.snapshot_retention_limit : 0
  maintenance_window       = var.maintenance_window == "" ? join("", random_shuffle.maintenance_window.result) : var.maintenance_window

  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment}-${var.app_name}-redis"
    }
  )

  lifecycle {
    ignore_changes = [engine_version]
  }
}
