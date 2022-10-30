# Terraform Documentation
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.34.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.34.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora_cluster"></a> [aurora\_cluster](#module\_aurora\_cluster) | terraform-aws-modules/rds-aurora/aws | 7.6.0 |
| <a name="module_dms"></a> [dms](#module\_dms) | terraform-aws-modules/dms/aws | ~> 1.6 |
| <a name="module_glue_scripts"></a> [glue\_scripts](#module\_glue\_scripts) | terraform-aws-modules/s3-bucket/aws | ~> 3.4.0 |
| <a name="module_iceberg_data_bucket"></a> [iceberg\_data\_bucket](#module\_iceberg\_data\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.4.0 |
| <a name="module_raw_data_bucket"></a> [raw\_data\_bucket](#module\_raw\_data\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_athena_named_query.iceberg_data_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_workgroup.wg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) | resource |
| [aws_cloudwatch_event_rule.glue_job_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.glue_job_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_db_parameter_group.aurora_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_glue_catalog_database.catalog_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_catalog_table.raw_data_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_glue_job.glue_job](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job) | resource |
| [aws_glue_trigger.glue_job_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_trigger) | resource |
| [aws_glue_workflow.rdbms_to_iceberg_workflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_workflow) | resource |
| [aws_iam_policy.glue_job_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.glue_job_trigger_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.dms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.glue_job_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.glue_job_trigger_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.glue_job_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.glue_job_trigger_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_rds_cluster_parameter_group.aurora_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_s3_bucket_notification.notify_new_dms_ingestion_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_object.glue_job_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_security_group.dms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_string.naming_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_glue_connection.apache_iceberg_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/glue_connection) | data source |
| [aws_iam_policy.ecr_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.glue_job_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.glue_job_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.glue_job_trigger_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.glue_job_trigger_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.glue_scripts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.iceberg_data_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.raw_data_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apache_iceberg_glue_connection_name"></a> [apache\_iceberg\_glue\_connection\_name](#input\_apache\_iceberg\_glue\_connection\_name) | The name of the Apache Iceberg Glue connection | `string` | `"iceberg-poc-glue-connector"` | no |
| <a name="input_apache_iceberg_glue_connector_name"></a> [apache\_iceberg\_glue\_connector\_name](#input\_apache\_iceberg\_glue\_connector\_name) | The name of the Apache Iceberg Glue connector | `string` | `"Apache Iceberg Connector for Glue 3.0"` | no |
| <a name="input_aws_profile_name"></a> [aws\_profile\_name](#input\_aws\_profile\_name) | The name of your AWS CLI profile | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The password to use for the database | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | The username to use for the database | `string` | `"iceberg"` | no |
| <a name="input_dms_bucket_folder_name"></a> [dms\_bucket\_folder\_name](#input\_dms\_bucket\_folder\_name) | The name of the DMS folder in the DMS task destination S3 bucket | `string` | `"dms"` | no |
| <a name="input_iceberg_data_bucket_name"></a> [iceberg\_data\_bucket\_name](#input\_iceberg\_data\_bucket\_name) | The name of the S3 bucket where the curated data is stored | `string` | `"iceberg-data-bucket"` | no |
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | The prefix to use for all resources in this environment | `string` | `"iceberg-poc"` | no |
| <a name="input_raw_data_bucket_name"></a> [raw\_data\_bucket\_name](#input\_raw\_data\_bucket\_name) | The name of the S3 bucket where the raw data is stored | `string` | `"raw-data-bucket"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags' key-values applied to all resources | `map(string)` | <pre>{<br>  "Environment": "dev",<br>  "Project": "iceberg"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | n/a |
| <a name="output_db_port"></a> [db\_port](#output\_db\_port) | n/a |
| <a name="output_db_server"></a> [db\_server](#output\_db\_server) | n/a |
<!-- END_TF_DOCS -->