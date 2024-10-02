#this file is creating all security groups and allow ports
#creating mysql security group just group
module "mysql_sg" {
  source       = "git::https://github.com/venkatswan/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "mysql"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.mysql_sg_tags
}
#creating backend security group
module "backend_sg" {
  source       = "git::https://github.com/venkatswan/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "backend"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.backend_sg_tags
}
#creating frontend security group
module "frontend_sg" {
  source       = "git::https://github.com/venkatswan/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "frontend"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.frontend_sg_tags
}
#creating bastion security group
module "bastion_sg" {
  source       = "git::https://github.com/venkatswan/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "bastion"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.bastion_sg_tags
}
#creating ansible security group
module "ansible_sg" {
  source       = "git::https://github.com/venkatswan/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "ansible"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.ansible_sg_tags
}

# MySQL allowing connection on 3306 from the instances attached to Backend Security group
# in mysql security group we are adding a ingress rule 
resource "aws_security_group_rule" "mysql_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.id # in inbound added backend_sg to allow backend to connect mysql, in manual will give CIDR
  security_group_id        = module.mysql_sg.id   # where to add -> here it is added in mysql security group
}

# Backend allowing connection on 8080 from the instances attached to Frontend Security group
# in backend security group we are adding a ingress rule 
resource "aws_security_group_rule" "backend_frontend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id        = module.backend_sg.id
}

# Frontend allowing connection on 80 from the instances attached to Frontend Security group
# in frontend security group we are adding a ingress rule public need to access fronten [0.0.0.0/0]
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]         # adding CIDR value in ingress rule
  security_group_id = module.frontend_sg.id # adding cidr value in frontend sg
}

# MySQL allowing connection on 22 from the bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.mysql_sg.id
}
# Backend allowing connection on 22 from the bastion
resource "aws_security_group_rule" "backend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.backend_sg.id
}
# Frontend allowing connection on 22 from the bastion
resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.frontend_sg.id
}
# mysql allowing connection on 22 from the ansible
resource "aws_security_group_rule" "mysql_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.mysql_sg.id
}
# backend allowing connection on 22 from the ansible
resource "aws_security_group_rule" "backend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.backend_sg.id
}
# frontend allowing connection on 22 from the ansible
resource "aws_security_group_rule" "frontend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.frontend_sg.id
}

# Ansible Server allowing connection on 22 from the public
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.id
}

# Bastion Server allowing connection on 22 from the public
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.id
}