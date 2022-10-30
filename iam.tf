#######  Glue Job IAM Role #####################################################################################
data "aws_iam_policy_document" "glue_job_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_job_role" {
  name               = "${var.naming_prefix}_glue_job_role"
  assume_role_policy = data.aws_iam_policy_document.glue_job_assume_role.json
}

data "aws_iam_policy_document" "glue_job_policy" {
  statement {
    actions = [
      "s3:*",
      "glue:*",
      "ecr:GetAuthorizationToken",
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "glue_job_policy" {
  name        = "${var.naming_prefix}-glue-job-policy"
  description = "Glue Job Policy"

  policy = data.aws_iam_policy_document.glue_job_policy.json
}

resource "aws_iam_role_policy_attachment" "glue_job_policy" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = aws_iam_policy.glue_job_policy.arn
}

data "aws_iam_policy" "ecr_access_policy" {
  name = "AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecr_access_policy" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = data.aws_iam_policy.ecr_access_policy.arn
}

#######  IAM Role for the EventBridge Rule to trigger the Glue Job ####################################################
data "aws_iam_policy_document" "glue_job_trigger_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_job_trigger_role" {
  name               = "${var.naming_prefix}_glue_job_trigger_role"
  assume_role_policy = data.aws_iam_policy_document.glue_job_trigger_assume_role.json
}

data "aws_iam_policy_document" "glue_job_trigger_policy" {
  statement {
    actions   = ["glue:notifyEvent"]
    resources = [aws_glue_workflow.rdbms_to_iceberg_workflow.arn]
  }
}

resource "aws_iam_policy" "glue_job_trigger_policy" {
  name        = "${var.naming_prefix}-glue-job-trigger-policy"
  description = "Glue Job Trigger Policy"

  policy = data.aws_iam_policy_document.glue_job_trigger_policy.json
}

resource "aws_iam_role_policy_attachment" "glue_job_trigger_policy" {
  role       = aws_iam_role.glue_job_trigger_role.name
  policy_arn = aws_iam_policy.glue_job_trigger_policy.arn
}