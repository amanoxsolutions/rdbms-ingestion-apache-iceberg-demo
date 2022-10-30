
resource "aws_db_parameter_group" "aurora_cluster" {
  name        = "${var.naming_prefix}-aurora-db-postgres-parameter-group"
  family      = "aurora-postgresql14"
  description = "${var.naming_prefix}-aurora-db-postgres-parameter-group"
  tags        = var.tags
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster" {
  name        = "${var.naming_prefix}-aurora-postgres-cluster-parameter-group"
  family      = "aurora-postgresql14"
  description = "${var.naming_prefix}-aurora-postgres-cluster-parameter-group"

  parameter {
    name         = "rds.logical_replication"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wal_sender_timeout"
    value        = 0
    apply_method = "pending-reboot"
  }

  tags = var.tags
}

resource "aws_db_subnet_group" "aurora" {
  name        = "${var.naming_prefix}-db-subnet-group"
  description = "Database subnet group for ${var.naming_prefix}"
  subnet_ids  = module.vpc.public_subnets

  tags = var.tags
}

module "aurora_cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.0"

  name           = "${var.naming_prefix}-source-db"
  database_name  = "testdb"
  engine         = "aurora-postgresql"
  engine_version = "14.4"
  instance_class = "db.t4g.medium"
  instances = {
    1 = {}
  }
  storage_encrypted = true

  master_username = var.db_username
  master_password = var.db_password

  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = ["0.0.0.0/0"]
  publicly_accessible    = true

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.aurora_cluster.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster.id

  tags = var.tags
}