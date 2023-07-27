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
  subnet_id              = var.ec2_subnet

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

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = [ "0.0.0.0/0", ]
    },
  ]

  # egress
  egress = [
    {
      from_port        = 0
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      self             = false
      description      = ""
      cidr_blocks      = [ "0.0.0.0/0", ]
    }
  ]

  tags = var.tags
}