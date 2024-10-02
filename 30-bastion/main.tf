module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.expense_server.id
  name   = local.resource_name

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.bastion_tags,
    {
      Name : local.resource_name
    }
  )
}