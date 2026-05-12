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

##### IAM Policy Variables #####

variable "tfc_iam_policy_object" {
  description = "IAM Policy Object for IAM Policy creation"
  type = map(object({
    policy_name     = string
    policy_document = string
    assume_role_policy_key = string
  }))
  default = {}
  
}

variable "iam_policy_enabled" {
  description = "Flag to enable/disable IAM Policy creation"
  type        = bool
  default     = true
  
}


#### role variables

variable "tfc_iam_role_object" {
    description = "IAM Role Object for IAM Role creation"
    type = map(object({
        role_name     = string
        assume_role_policy_key = string
    }))
    default = {} 
  
}

variable "iam_enabled" {
    description = "Flag to enable/disable IAM Role creation"
    type        = bool
    default     = true
  
}

variable "iam_assume_role_policy" {
    description = "Map of assume role policies for IAM Role creation"
    type        = map(any)
    default     = {}
  
}

##### EKS Variables #####
variable "tfc_eks_object" {
    description = "EKS Object for EKS Cluster creation"
    type = map(object({
        cluster_name = string
        kubernetes_version = string
        bootstrap_self_managed_addons = bool
        vpc_key = string
        role_key = string
        node_role_key = string
    }))
    default = {}
  
}

variable "eks_enabled" {
    description = "Flag to enable/disable EKS Cluster creation"
    type        = bool
    default     = true
  
}

variable "eks_role_arn" {
    description = "ARN of the IAM Role to be used by the EKS Cluster"
    type        = string
    default     = ""
  
}

variable "eks_subnet_ids" {
    description = "List of Subnet IDs for the EKS Cluster VPC configuration"
    type        = list(string)
    default     = []
  
}
