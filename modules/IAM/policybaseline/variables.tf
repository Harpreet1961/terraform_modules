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