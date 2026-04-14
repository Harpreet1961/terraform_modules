variable "vpc_enabled" {
  description = "Enable VPC creation"
  type        = bool
  default     = true

}

variable "igw_enabled" {
  description = "Enable Internet Gateway creation"
  type        = bool
  default     = true

}
variable "nat_enabled" {
  description = "Enable NAT Gateway creation"
  type        = bool
  default     = true

}

variable "tfc_vpc_object" {
  description = "VPC Object for VPC creation"
  type = map(object({
    vpc_name           = string
    cidr_block         = string
    enable_dns_support = bool
  }))
  default = {}

}

variable "tfc_subnets_object" {
  description = "Subnets Object for Subnet creation"
  type = map(object({
    subnet_name               = string
    cidr_block_subnet         = string
    availability_zone         = string
    map_public_ip_on_launch   = bool
    cidr_block_subnet_private = string
    vpc_key                   = string
    subnet_type               = string

  }))
  default = {}

}



##### Security Group Variables #####

variable "sg_enabled" {
  description = "Enable Security Group creation"
  type        = bool
  default     = true

}

variable "tfc_sg_object" {
  description = "Security Group Object for Security Group creation"
  type = map(object({
    sg_name     = string
    description = string
    vpc_key     = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
  default = {}

}

variable "vpc_id" {
  description = "VPC ID map for Security Group creation"
  type        = map(string)
  default     = {}

}

###### EC2 Variables ######
variable "ec2_enabled" {
  description = "Flag to enable/disable EC2 creation"
  type        = bool
  default     = true
}

variable "tfc_ec2_object" {
  description = "EC2 Object for EC2 creation"
  type = map(object({
    instance_name = string
    ami_id        = string
    instance_type = string
    subnet_key    = string
    sg_key        = string
  }))
  default = {}

}

variable "subnet_id" {
  description = "Subnet ID map for EC2 creation"
  type        = map(string)
  default     = {}

}

variable "security_group_id" {
  description = "Security Group ID map for EC2 creation"
  type        = map(string)
  default     = {}


}