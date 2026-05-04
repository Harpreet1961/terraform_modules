output "policy_id" {  
  value = {
    for k, v in aws_iam_policy.policy : k => v.id
  }
  description = "IAM Policy ID created by the module"
  
}

output "policy_json" {
  value = {
    for k, v in aws_iam_policy.policy : k => v.policy
  }
  description = "IAM Policy JSON document created by the module"
  
}

output "policy_arn" {
  value = {
    for k, v in aws_iam_policy.policy : k => v.arn
  }
  description = "IAM Policy ARN created by the module"
  
}