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

variable "ami_ids" {
  description = "Map of AMI IDs based on ami_type and proc"
  type        = map
  default     = {
    GOLD = {
      X86   = "ami_gold_x86_id"
      ARM64 = "ami_gold_arm64_id"
    }
    TEST = {
      X86   = "ami_test_x86_id"
      ARM64 = "ami_test_arm64_id"
    }
  }
}

variable "instance_types" {
  description = "Map of instance types based on proc"
  type        = map
  default     = {
    X86   = "t3.large"
    ARM64 = "t4g.large"
  }
}

resource "aws_instance" "example" {
  ami           = var.ami_ids[var.ami_type][var.proc]
  instance_type = var.instance_types[var.proc]
  subnet_id     = var.vpc_subnets_sgs[var.build_env].subnet_id
  vpc_security_group_ids = [var.vpc_subnets_sgs[var.build_env].security_group_id]
  tags = {
    "Name" = "Amazon-${var.proc}-${var.ami_type}"
  }
}
