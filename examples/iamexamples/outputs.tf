output "policy_id" {  
    value = module.iam_policy_object.policy_id
    description = "The ID of the IAM policy created in the policybaseline module."
}

output "policy_json" {
    value = module.iam_policy_object.policy_json
    description = "The JSON document of the IAM policy created in the policybaseline module."
  
}

output "policy_arn" {
    value = module.iam_policy_object.policy_arn
    description = "The ARN of the IAM policy created in the policybaseline module."
  
}

output "role_name" {
    value = module.iam_role_object.role_name
    description = "The name of the IAM role created in the rolebaseline module."
  
}