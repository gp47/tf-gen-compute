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
  vpc_security_group_ids = [module.base_sg.security_group_id, var.rds_sg]
  subnet_id              = element(var.private_subnets, 0)

  enable_volume_tags = false

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 10
      tags = {
        Name = "${var.project_name}-testbox-rv"
      }
    },
  ]

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

  ingress_cidr_blocks = [var.ibase_sg_cb]
  ingress_rules       = ["http-80-tcp", "all-icmp", "ssh"]
  egress_rules        = ["all-all"]

  tags = var.tags
}