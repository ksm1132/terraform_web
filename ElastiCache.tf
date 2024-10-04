resource "aws_elasticache_parameter_group" "example" {
  family     = "redis6.x"
  name       = "example"
  parameter {
    name  = "cluster-enabled"
    value = "no"
  }
}

resource "aws_elasticache_subnet_group" "example" {
  name       = "example"
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
}

resource "aws_elasticache_replication_group" "example" {
  description      = "Cluster Disabled"
  replication_group_id               = "example"
  engine = "redis"
  engine_version = "6.2"
  node_type = "cache.t3.medium"
  num_cache_clusters = 2
  snapshot_window = "09:10-10:10"
  snapshot_retention_limit = 7
  maintenance_window = "mon:10:40-mon:11:40"
  automatic_failover_enabled = true
  port = 6379
  apply_immediately = false
  security_group_ids = [module.redis_sg.security_group_id]
  parameter_group_name = aws_elasticache_parameter_group.example.name
  subnet_group_name = aws_elasticache_subnet_group.example.name
}