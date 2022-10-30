################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${var.naming_prefix}-vpc"
  cidr = "10.10.0.0/21"

  enable_dns_support   = true
  enable_dns_hostnames = true

  azs = [
    "${data.aws_region.current.name}a",
    "${data.aws_region.current.name}b"
  ]
  public_subnets  = ["10.10.0.0/24", "10.10.1.0/24"]
  private_subnets = ["10.10.2.0/24", "10.10.3.0/24"]

  enable_nat_gateway = false # Disabled NAT to be able to run this example quicker

  tags = var.tags
}

