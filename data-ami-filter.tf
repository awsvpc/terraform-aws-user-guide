# Data resource to filter AMI
data "aws_ami" "filtered_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aminame[var.proc]}-${var.proc}-${var.version}-v*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


------------

variable "aminame" {
  description = "Map of AMI names"
  type        = map(string)
  default = {
    "x86"   = "amazon-eks-node-x86-1.28-v*"
    "arm64" = "amazon-eks-node-arm64-1.28-v*"
  }
}


--------------

# Define variables
variable "proc" {
  description = "Processor architecture (x86 or arm64)"
  type        = string
}

variable "version" {
  description = "AMI version"
  type        = string
}

variable "aminame" {
  description = "Map of AMI names"
  type        = map(string)
}

# Data resource to filter AMI
data "aws_ami" "filtered_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aminame[var.proc], var.version]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Example of usage
output "filtered_ami_id" {
  value = data.aws_ami.filtered_ami.id
}
