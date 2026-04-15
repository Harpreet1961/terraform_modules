variable "ec2_enabled" {
  description = "Flag to enable/disable EC2 creation"
  type        = bool
  default     = true
}

variable "tfc_ec2_object" {
    description = "EC2 Object for EC2 creation"
    type = map(object({
      instance_name   = string
      ami_id         = string
      instance_type   = string
      subnet_key      = string
      sg_key          = string
      environment       = string
    }))
    default = {}
  
}

variable "subnet_id" { 
    description = "Subnet ID map for EC2 creation"
    type = map(string)
    default = {}
  
}

variable "security_group_id" {
    description = "Security Group ID map for EC2 creation"
    type = map(string)
    default = {}


}