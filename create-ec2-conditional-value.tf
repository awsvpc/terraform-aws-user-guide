variable "build_env" {
  description = "Environment type (prod or dev)"
  type        = string
}

variable "proc" {
  description = "Processor architecture (X86 or ARM64)"
  type        = string
}

variable "ami_type" {
  description = "AMI type (GOLD or TEST)"
  type        = string
}

variable "vpc_subnets_sgs" {
  description = "Map of VPC, Subnet, and Security Group IDs based on build environment"
  type        = map
  default     = {
    prod = {
      vpc_id           = "prod_vpc_id"
      subnet_id        = "prod_subnet_id"
      security_group_id = "prod_sg_id"
    }
    dev = {
      vpc_id           = "dev_vpc_id"
      subnet_id        = "dev_subnet_id"
      security_group_id = "dev_sg_id"
    }
  }
}

resource "aws_instance" "example" {
  ami           = var.ami_type == "GOLD" ? "ami_gold_id" : "ami_test_id"
  instance_type = var.proc == "X86" ? "t3.large" : "t4g.large"
  subnet_id     = var.vpc_subnets_sgs[var.build_env].subnet_id
  vpc_security_group_ids = [var.vpc_subnets_sgs[var.build_env].security_group_id]
  tags = {
    "Name" = var.ami_type == "GOLD" ? "Amazon-${var.proc}-GOLD" : "Amazon-${var.proc}-TEST"
  }
}
