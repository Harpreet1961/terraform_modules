variable "tfc_iam_policy_object" {
  description = "IAM Policy Object for IAM Policy creation"
  type = map(object({
    policy_name     = string
    policy_document = any
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