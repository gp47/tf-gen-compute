variable "project_name" {
  type        = string
  description = "The Project Name."
}

variable "ami_id" {
  type        = string
  description = "The EC2 AMI id."
}

variable "instance_type" {
  type        = string
  description = "The EC2 Instance Type."
  default = "t2.micro"
}

variable "ssh_hey" {
  type        = string
  description = "The ssh key name."
}

variable "tags" {
  type        = map(string)
  description = "Tags assigned to the created resources"
  default     = {}
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR Block."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnets"
}