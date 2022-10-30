#######  Supporting Resources #########################################################################################
locals {
  raw_data_bucket_name       = "${var.naming_prefix}-${var.raw_data_bucket_name}-${random_string.naming_suffix.result}"
  iceberg_data_bucket_name   = "${var.naming_prefix}-${var.iceberg_data_bucket_name}-${random_string.naming_suffix.result}"
  glue_script_bucket_name    = "${var.naming_prefix}-glue-scripts-${random_string.naming_suffix.result}"
  athena_queries_bucket_name = "${var.naming_prefix}-athena-queries-${random_string.naming_suffix.result}"
}

#######  RAW Data S3 Bucket ##########################################################################################
data "aws_iam_policy_document" "raw_data_bucket" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${local.raw_data_bucket_name}",
      "arn:aws:s3:::${local.raw_data_bucket_name}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

module "raw_data_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.4.0"
  bucket  = local.raw_data_bucket_name
  acl     = "private"

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.raw_data_bucket.json

  tags = var.tags
}

resource "aws_s3_bucket_notification" "notify_new_dms_ingestion_data" {
  bucket      = module.raw_data_bucket.s3_bucket_id
  eventbridge = true
}

#######  Iceberg Data s3 Bucket #######################################################################################
data "aws_iam_policy_document" "iceberg_data_bucket" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${local.iceberg_data_bucket_name}",
      "arn:aws:s3:::${local.iceberg_data_bucket_name}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

module "iceberg_data_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.4.0"
  bucket  = local.iceberg_data_bucket_name
  acl     = "private"

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.iceberg_data_bucket.json

  tags = var.tags
}

#######  S3 Bucket Storing the Glue Job Scripts #######################################################################
data "aws_iam_policy_document" "glue_scripts" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${local.glue_script_bucket_name}",
      "arn:aws:s3:::${local.glue_script_bucket_name}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

module "glue_scripts" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.4.0"
  bucket  = local.glue_script_bucket_name
  acl     = "private"

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.glue_scripts.json

  tags = var.tags
}

