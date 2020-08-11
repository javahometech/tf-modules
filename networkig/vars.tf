variable "stack_region" {
  default     = "ap-south-1"
  description = "Choose region for your vpc"
  type        = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Choose cidr for your vpc"
  type        = string
}

variable "vpc_tenancy" {
  default     = "default"
  description = "Choose tenancy for your vpc"
  type        = string
}

variable "nat_amis" {
  description = "Choose NAT ami"
  type        = map
  default = {
    ap-south-1     = "ami-00b3aa8a93dd09c13"
    ap-southeast-2 = "ami-00c1445796bc0a29f"
  }
}
