data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "naming_suffix" {
  length  = 8
  special = false
  upper   = false
}