resource "aws_elasticache_parameter_group" "this" {
  name        = "${var.environment}-${var.app_name}-redis"
  family      = var.family
  description = "Default parameter group for ${var.family}"

  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment}-${var.app_name}-redis"
    }
  )
}
