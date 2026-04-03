variable "tfc_vpc_object" {
    description = "VPC Object for VPC creation"
    type        = map(object({
        vpc_name = string
        cidr_block = string
        enable_dns_support = bool
    }))
    default     = {}
  
}

variable "tfc_subnets_object" {
    description = "Subnets Object for Subnet creation"
    type        = map(object({
        subnet_name = string
        cidr_block_subnet = string
        availability_zone = string
        map_public_ip_on_launch= bool
        cidr_block_subnet_private = string
        vpc_key = string
        subnet_type = string
        
    }))
    default     = {}
  
}