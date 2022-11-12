resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-${var.app_name}-redis-subnet"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment}-${var.app_name}-redis-subnet"
    }
  )
}
