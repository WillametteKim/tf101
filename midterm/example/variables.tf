### Default Setting
variable "region" {}
variable "profile" {}
variable "environment" {}

### Redis Setting
variable "app_name" {}
variable "node_type" {}
variable "vpc_id" {}
variable "subnet_ids" {}

## Redis Tag Setting
variable "creation_method" {
  default = "terraform"
}

variable "num_cache_clusters" {}
variable "automatic_failover_enabled" {}
variable "multi_az_enabled" {}
