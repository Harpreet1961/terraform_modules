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