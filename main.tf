data "aws_availability_zones" "available" {}

################################################################################
# EC2 Module
################################################################################

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.2.0"

  name = "${var.project_name}-testbox"
  ami                    = var.ami_id

  instance_type          = var.instance_type
  key_name               = var.ssh_hey
  monitoring             = false
  vpc_security_group_ids = [module.base_sg.security_group_id]
  subnet_id              = element(var.private_subnets, 0)

  tags = var.tags
}

################################################################################
# SG Module
################################################################################

module "base_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.project_name}-db-sg"
  description = "Base EC2 security group"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = var.tags
}