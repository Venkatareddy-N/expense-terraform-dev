#in data block we retrived vpc_id, here we are declaring variable to use it
locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}