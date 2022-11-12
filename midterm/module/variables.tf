### DEFAULT
variable "environment" {}
variable "app_name" {}

### NETWORK - VPC
variable "vpc_id" {}
data "aws_vpc" "selected" {
  id = var.vpc_id
}

### NETWORK - SUBNET GROUP
variable "subnet_ids" {}

### NETWORK - SECURITY GROUP
variable "sg_cidr_list" {}

### REDIS
variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
}
variable "engine" {
  default = "redis"
}
variable "engine_version" {
  default = "6.x"
}
variable "port" {
  default = 6379
}
variable "node_type" {}
variable "num_cache_clusters" {
  default = 2
}
variable "multi_az_enabled" { # if true, num_cache_clusters must be at least 2.
  default = true              # if true, automatic_failover_enabled must also be enabled.
}
variable "automatic_failover_enabled" {
  default = true
}
variable "auto_minor_version_upgrade" {
  default = false
}

### REDIS - PARAMETER GROUP
variable "family" {
  default = "redis6.x"
}

### REDIS MAINTENANCE CONF
variable "create_snapshot" {
  default = true
}
variable "snapshot_window" {
  default = "18:00-19:00" # UTC Time, 03:00-04:00(KST)
}
variable "snapshot_retention_limit" {
  default = 1 # AWS provides storage space for one snapshot free of charge for each active ElastiCache for Redis cluster.
}
variable "maintenance_window" {
  default = ""
}
variable "random_maintenance_window" {
  type = list(string)
  default = [
    "sun:20:00-sun:21:00", # UTC Time, 05:00-06:00(KST)
    "mon:20:00-sun:21:00",
    "the:20:00-sun:21:00",
    "wed:20:00-sun:21:00",
    "thu:20:00-sun:21:00",
  ]
}

variable "override" {
  default = false
}

variable "tags" {
  default = {}
}
