variable "aws_profile_name" {
  description = "The name of your AWS CLI profile"
  type        = string
}

variable "naming_prefix" {
  description = "The prefix to use for all resources in this environment"
  type        = string
  default     = "iceberg-poc"
}

variable "raw_data_bucket_name" {
  description = "The name of the S3 bucket where the raw data is stored"
  type        = string
  default     = "raw-data-bucket"
}

variable "iceberg_data_bucket_name" {
  description = "The name of the S3 bucket where the curated data is stored"
  type        = string
  default     = "iceberg-data-bucket"
}

variable "tags" {
  description = "List of tags' key-values applied to all resources"
  type        = map(string)
  default = {
    "Environment" = "dev"
    "Project"     = "iceberg"
  }
}

variable "apache_iceberg_glue_connector_name" {
  description = "The name of the Apache Iceberg Glue connector"
  type        = string
  default     = "Apache Iceberg Connector for Glue 3.0"
}

variable "apache_iceberg_glue_connection_name" {
  description = "The name of the Apache Iceberg Glue connection"
  type        = string
  default     = "iceberg-poc-glue-connector"
}

variable "db_username" {
  description = "The username to use for the database"
  type        = string
  default     = "iceberg"
}

variable "db_password" {
  description = "The password to use for the database"
  type        = string
}

variable "dms_bucket_folder_name" {
  description = "The name of the DMS folder in the DMS task destination S3 bucket"
  type        = string
  default     = "dms"
}