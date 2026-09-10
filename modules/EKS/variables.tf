variable "tfc_eks_object" {
  description = "EKS Object for EKS Cluster creation"
  type = map(object({
    cluster_name                  = string
    kubernetes_version            = string
    bootstrap_self_managed_addons = bool
    vpc_key                       = string
    role_key                      = string
    node_role_key                 = string
    capacity_type                 = string
    instance_types                = list(string)
    disk_size                     = number
    desired_size                  = number
    max_size                      = number
    min_size                      = number
    environment                   = string
    nodegroup                     = string
    eks_addons = list(object({
      addon_name        = string
      addon_version     = string
      resolve_conflicts = string
    }))
  }))
  default = {}

}

variable "eks_enabled" {
  description = "Flag to enable/disable EKS Cluster creation"
  type        = bool
  default     = true

}

variable "eks_role_arn" {
  description = "Map of IAM Role ARNs keyed by role key for EKS Cluster creation"
  type        = map(string)
  default     = {}

}

variable "eks_subnet_ids" {
  description = "Map of subnet ID lists keyed by VPC key for EKS Cluster VPC configuration"
  type        = map(list(string))
  default     = {}

}
