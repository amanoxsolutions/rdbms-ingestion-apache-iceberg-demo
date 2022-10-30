locals {
  catalog_database_name   = replace("${var.naming_prefix}_db_${random_string.naming_suffix.result}", "-", "_")
  raw_data_table_name     = replace("${var.naming_prefix}_raw_data_table_${random_string.naming_suffix.result}", "-", "_")
  iceberg_data_table_name = replace("${var.naming_prefix}_iceberg_data_table_${random_string.naming_suffix.result}", "-", "_")
}

resource "aws_glue_catalog_database" "catalog_database" {
  name = local.catalog_database_name
}

#######  Raw Data Table ###########################################################################################
resource "aws_glue_catalog_table" "raw_data_table" {
  name          = local.raw_data_table_name
  database_name = aws_glue_catalog_database.catalog_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL         = "TRUE"
    "classification" = "parquet"
  }

  storage_descriptor {
    location      = "s3://${module.raw_data_bucket.s3_bucket_id}/${var.dms_bucket_folder_name}/public/products"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "op"
      type = "string"
    }

    columns {
      name = "ingested_at"
      type = "string"
    }

    columns {
      name = "id"
      type = "bigint"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "type"
      type = "string"
    }

    columns {
      name = "quantity"
      type = "bigint"
    }

    columns {
      name = "price"
      type = "decimal(10,2)"
    }
  }
}

#######  Glue Job #################################################################################################
data "aws_glue_connection" "apache_iceberg_connection" {
  id = "${data.aws_caller_identity.current.account_id}:${var.apache_iceberg_glue_connector_name}"
}

resource "aws_glue_job" "glue_job" {
  name         = "${var.naming_prefix}-glue-job-${random_string.naming_suffix.result}"
  role_arn     = aws_iam_role.glue_job_role.arn
  max_capacity = 2
  max_retries  = 1
  glue_version = "3.0"

  command {
    script_location = "s3://${module.glue_scripts.s3_bucket_id}/glue-script.py"
  }

  connections = [var.apache_iceberg_glue_connector_name]

  default_arguments = {
    "--job-language"                  = "python"
    "--job-bookmark-option"           = "job-bookmark-enable"
    "--iceberg_job_catalog_warehouse" = "s3://${module.iceberg_data_bucket.s3_bucket_id}/warehouse"
  }

  depends_on = [
    aws_glue_catalog_table.raw_data_table,
    aws_athena_named_query.iceberg_data_table
  ]
}

resource "aws_s3_object" "glue_job_script" {
  bucket = module.glue_scripts.s3_bucket_id
  key    = "glue-script.py"
  content = templatefile("./assets/glue-scripts/glue-script.py.tmpl",
    {
      glue_database_name     = local.catalog_database_name
      glue_input_table_name  = local.raw_data_table_name
      glue_output_table_name = local.iceberg_data_table_name
    }
  )
}

#######  Trigger the Glue Job When files are delivered by DMS in the S3 RAW bucket ####################################
resource "aws_glue_workflow" "rdbms_to_iceberg_workflow" {
  name = "${var.naming_prefix}-glue-dms-ingestion-workflow"
}

resource "aws_glue_trigger" "glue_job_trigger" {
  name          = "${var.naming_prefix}-glue-job-trigger"
  description   = "Glue trigger which is listening on S3 PutObject events in the S3 RAW bucket"
  type          = "EVENT"
  workflow_name = aws_glue_workflow.rdbms_to_iceberg_workflow.name

  actions {
    job_name = aws_glue_job.glue_job.name
  }

  event_batching_condition {
    batch_size   = 1
    batch_window = 300
  }
}

resource "aws_cloudwatch_event_rule" "glue_job_trigger" {
  name        = "${var.naming_prefix}-glue-job-trigger-rule"
  description = "Trigger the AWS Glue Job to process the new files delivered by DMS in the S3 RAW bucket"

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name" :["${module.raw_data_bucket.s3_bucket_id}"]
    },
    "object": {
      "key": [{"prefix": "dms/"}]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "glue_job_trigger" {
  target_id = aws_glue_job.glue_job.id
  rule      = aws_cloudwatch_event_rule.glue_job_trigger.name
  arn       = aws_glue_workflow.rdbms_to_iceberg_workflow.arn
  role_arn  = aws_iam_role.glue_job_trigger_role.arn
}