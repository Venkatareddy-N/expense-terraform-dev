#Creating mysql ec2-instance
module "mysql" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.expense.id
  name   = "${local.resource_name}-mysql"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.mysql_tags,
    {
      Name : "${local.resource_name}-mysql"
    }
  )
}
#Creating backend ec2-instance
module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.expense.id
  name   = "${local.resource_name}-backend"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.backend_tags,
    {
      Name : "${local.resource_name}-backend"
    }
  )
}
#Creating frontend ec2-instance
module "frontend" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.expense.id
  name   = "${local.resource_name}-frontend"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.frontend_tags,
    {
      Name : "${local.resource_name}-frontend"
    }
  )
}
#Creating ansible ec2-instance, and adding ansible playbooks
module "ansible" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.expense.id
  name   = "${local.resource_name}-ansible"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.ansible_sg_id]
  subnet_id              = local.public_subnet_id
  user_data              = file("expense.sh")    # ansible scripts to run at the time of creation.
  tags = merge(
    var.common_tags,
    var.ansible_tags,
    {
      Name : "${local.resource_name}-ansible"
    }
  )
}

#creating Route53 records 
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name = "mysql"
      type = "A"
      ttl  = 1
      records = [
        module.mysql.private_ip
      ]
      allow_overwrite = true
    },
    {
      name = "backend"
      type = "A"
      ttl  = 1
      records = [
        module.backend.private_ip
      ]
      allow_overwrite = true
    },
    {
      name = "frontend"
      type = "A"
      ttl  = 1
      records = [
        module.frontend.private_ip
      ]
      allow_overwrite = true
    },
    {
      name = ""
      type = "A"
      ttl  = 1
      records = [
        module.frontend.public_ip
      ]
      allow_overwrite = true
    }
  ]
}