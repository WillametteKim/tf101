module "redis" {
  source = "git::git@github.com:WillametteKim/tf101.git//midterm/module"

  app_name     = var.app_name
  environment  = var.environment
  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
  node_type    = var.node_type
  sg_cidr_list = var.subnet_ids

  override                   = true
  num_cache_clusters         = 3
  automatic_failover_enabled = true
  multi_az_enabled           = true

  # Tag
  tags = {
    app_name        = "${var.app_name}"
    environment     = "${var.environment}"
    creation_method = "${var.creation_method}"
  }
}

output "redis_primary_endpoint_address" {
  value = module.redis.primary_endpoint_address
}

output "redis_reader_endpoint_address" {
  value = module.redis.reader_endpoint_address
}
