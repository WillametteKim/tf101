# Terraform Module - Formwork for AWS ElastiCache (Redis), with tf101
AWS ElastiCache Redis를 붕어빵처럼 찍어낼 수 있는 테라폼 모듈입니다. 

## 사용 버전
- Terraform Provider Version == 4.38.0
- Default Redis version == 6.2 

## 제약 사항
- ElastiCache Replication Group 사용해 클러스터 생성 (Cluster Mode Disabled) 
  - 1개 샤드만 사용
  - 기본(Stg, Dev)은 RW 노드 1개이며,  Prod 환경일 경우 RO 레플리카 노드 추가
    > A multiple node Redis (cluster mode disabled) cluster has two types of endpoints.
    >
    > The primary endpoint always connects to the primary node in the cluster, even if the specific node in the primary role changes. Use the primary endpoint for all writes to the cluster.
    >
    > Use the Reader Endpoint to evenly split incoming connections to the endpoint between all read replicas. Use the individual Node Endpoints for read operations (In the API/CLI these are referred to as Read Endpoints).

| vars                       | required | example                      | default                                                     | strongly advised to use default                                                                                                                 |
|----------------------------|----------|------------------------------|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| environment                | Y        | prod                         |                                                             |                                                                                                                                                 |
| app_name                   | Y        | chaos-monkey                       |                                                             |                                                                                                                                                 |
| vpc_id                     | Y        | vpc-000x0                    |                                                             |                                                                                                                                                 |
| subnet_ids                 | Y        | [subnet-000x0, ..]           |                                                             |                                                                                                                                                 |
| sg_cidr_list               | Y        | ["10.0.80.0/24", ..]         |                                                             |                                                                                                                                                 |
| availability_zones         | N        | ["ap-northeast-2a", ..]      | [ " ap-northeast-2a " ,  " ap-northeast-2b " , " ap-northeast-2c "]              |                                                                                                                                                 |
| engine                     | N        | "redis"                      | "redis"                                                     | Y                                                                                                                                               |
| engine_version             | N        | "5.0.6"                      | "6.x"                                                       | Y                                                                                                                                               |
| port                       | N        | 6379                         | 6379                                                        | Y                                                                                                                                               |
| node_type                  | Y        | "cache.m4.large"             |                                                             |                                                                                                                                                 |
| num_cache_clusters         | N        | 3                            | 2 in prod, 1 in else                                        | Y, To use custom value, set override = true.                                                                                                    |
| multi_az_enabled           | N        | true                         | true in prod, false in else                                 | Y, if true, num_cache_clusters must be at least 2, and automatic_failover_enabled must also be true. To use custom value, set override = true.  |
| automatic_failover_enabled | N        | true                         | true in prod, false in else                                 | Y, To use custom value, set override = true.                                                                                                    |
| auto_minor_version_upgrade | N        | false                        | false                                                       | Y                                                                                                                                               |
| family                     | N        | "redis6.x"                   | "redis6.x"                                                  | Y                                                                                                                                               |
| create_snapshot            | N        | true                         | true                                                        |                                                                                                                                                 |
| snapshot_window            | N        | "18:00-19:00"                | "18:00-19:00" (UTC)                                         |                                                                                                                                                 |
| snapshot_retention_limit   | N        | 1                            | 1                                                           | if 0, snapshot will not be created.                                                                                                             |
| maintenance_window         | N        | ["sun:21:00-sun:22:00", ...] | Random time window (1-hour) between every 20:00-21:00 (UTC) | Y                                                                                                                                               |
| override                   | N        | true                         | false                                                       | Y. This value is required to be true to set custom number of cache nodes.                                                                       |
| tags                       | Y        |                              |                                                             |                                                                                                                                                 |
