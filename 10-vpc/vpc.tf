module "vpc" {
  source                = "git::https://github.com/venkatswan/terraform-aws-vpc.git?ref=main"
  project_name          = var.project_name #these variable values given in variable.tf file you can give directly also project_name = "expense"
  environment           = var.environment
  common_tags           = var.common_tags
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
}