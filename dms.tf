resource "aws_security_group" "dms" {
  name        = "${var.naming_prefix}-dms-nsg"
  description = "NSG for DMS instance"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    #security_groups = [ module.aurora_cluster.security_group_id ]
  }

  tags = var.tags
}

resource "aws_iam_role" "dms" {
  name        = "${var.naming_prefix}-dms-s3-role"
  description = "Role used to migrate data to S3 via DMS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DMSAssume"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dms.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "${var.naming_prefix}-write-to-s3-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "DMSWriteToS3"
          Action = [
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:PutObjectTagging"
          ]
          Effect   = "Allow"
          Resource = "${module.raw_data_bucket.s3_bucket_arn}/*"
        },
        {
          Sid      = "DMSList"
          Action   = ["s3:ListBucket"]
          Effect   = "Allow"
          Resource = module.raw_data_bucket.s3_bucket_arn
        },
      ]
    })
  }

  tags = var.tags
}


module "dms" {
  source  = "terraform-aws-modules/dms/aws"
  version = "~> 1.6"

  # Subnet group
  repl_subnet_group_name        = "${var.naming_prefix}-replication-sg"
  repl_subnet_group_description = "${var.naming_prefix} DMS Replication Subnet group"
  repl_subnet_group_subnet_ids  = module.vpc.public_subnets

  # Instance
  repl_instance_allocated_storage            = 64
  repl_instance_auto_minor_version_upgrade   = true
  repl_instance_allow_major_version_upgrade  = true
  repl_instance_apply_immediately            = true
  repl_instance_engine_version               = "3.4.7"
  repl_instance_multi_az                     = false
  repl_instance_preferred_maintenance_window = "sun:10:30-sun:14:30"
  repl_instance_publicly_accessible          = true
  repl_instance_class                        = "dms.t3.small"
  repl_instance_id                           = "${var.naming_prefix}-dms-instance"
  repl_instance_vpc_security_group_ids       = [aws_security_group.dms.id]

  endpoints = {
    source = {
      database_name               = module.aurora_cluster.cluster_database_name
      endpoint_id                 = "${var.naming_prefix}-source"
      endpoint_type               = "source"
      engine_name                 = "aurora-postgresql"
      extra_connection_attributes = "heartbeatFrequency=1;pluginName=test_decoding"
      username                    = var.db_username
      password                    = var.db_password
      port                        = module.aurora_cluster.cluster_port
      server_name                 = module.aurora_cluster.cluster_endpoint
      ssl_mode                    = "require"
      tags                        = { EndpointType = "source" }
    }

    destination = {
      endpoint_id   = "${var.naming_prefix}-destination"
      endpoint_type = "target"
      engine_name   = "s3"
      ssl_mode      = "none"
      tags          = { EndpointType = "destination" }
      s3_settings = {
        bucket_name             = module.raw_data_bucket.s3_bucket_id
        bucket_folder           = var.dms_bucket_folder_name
        data_format             = "parquet"
        encryption_mode         = "SSE_S3"
        service_access_role_arn = aws_iam_role.dms.arn
        timestamp_column_name   = "ingested_at"
      }
    }

  }

  replication_tasks = {
    testdb_cdc = {
      replication_task_id       = "${var.naming_prefix}-cdc"
      migration_type            = "cdc"
      replication_task_settings = file("./assets/dms/task-settings.json")
      table_mappings            = file("./assets/dms/table-mappings.json")
      source_endpoint_key       = "source"
      target_endpoint_key       = "destination"
      tags                      = { Task = "PostgreSQL-to-S3" }
    }
  }

  tags = var.tags
}