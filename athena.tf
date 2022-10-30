#######  Athena Workgroup #############################################################################################
resource "aws_athena_workgroup" "wg" {
  name = "${var.naming_prefix}-wg"

  configuration {
    enforce_workgroup_configuration = true
    engine_version {
      selected_engine_version = "Athena engine version 2"
    }
  }

  force_destroy = true
  tags          = var.tags
}

#######  Iceberg Data Table ###########################################################################################
resource "aws_athena_named_query" "iceberg_data_table" {
  name      = "create_iceberg_data_table"
  workgroup = aws_athena_workgroup.wg.name
  database  = aws_glue_catalog_database.catalog_database.name
  query     = <<EOF
CREATE TABLE ${aws_glue_catalog_database.catalog_database.name}.${local.iceberg_data_table_name}(
  id bigint,
  name string,
  type string,
  quantity bigint,
  price  float,
  ingested_at timestamp)
PARTITIONED BY (type, bucket(16,id))
LOCATION 's3://${module.iceberg_data_bucket.s3_bucket_id}/warehouse/'
TBLPROPERTIES (
  'table_type'='ICEBERG',
  'format'='parquet',
  'write_target_data_file_size_bytes'='536870912'
);
EOF
}