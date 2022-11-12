# Default
region      = "ap-northeast-2"
profile     = "default"
environment = "staging"

# Redis
app_name   = "chaos-monkey"
node_type  = "cache.t2.medium"
vpc_id     = "vpc-0000x"
subnet_ids = ["10.0.80.0/16"]

num_cache_clusters         = 3
automatic_failover_enabled = true
multi_az_enabled           = true
