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