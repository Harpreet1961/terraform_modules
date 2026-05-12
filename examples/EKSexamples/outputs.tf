

output "subnet_id" {
  value       = module.vpc_object.subnet_id
  description = "Subnet IDs created by the module"

}

output "private_subnet_ids" {
  value       = module.vpc_object.private_subnet_ids
  description = "Private Subnet IDs created by the module"

}

output "public_subnet_ids" {
  value       = module.vpc_object.public_subnet_ids
  description = "Public Subnet IDs created by the module"
  
}

output "subnet_name" {
  value       = module.vpc_object.subnet_name
  description = "Subnet Names created by the module"

}
output "private_subnet_name" {
  value       = module.vpc_object.private_subnet_name
  description = "Private Subnet Names created by the module"
}

output "private_subnets_by_vpc" {
  value       = module.vpc_object.private_subnets_by_vpc
  description = "Private subnet IDs grouped by VPC created by the module"

}


output "public_subnets_by_vpc" {
  value       = module.vpc_object.public_subnets_by_vpc
    description = "Public subnet IDs grouped by VPC created by the module"  
}


##### IAM Outputs

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

output "role_arn" {
    value = module.iam_role_object.role_arn
    description = "The ARN of the IAM role created in the rolebaseline module."
  
}