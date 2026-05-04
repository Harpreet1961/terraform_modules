output "role_name" {
    description = "Name of the created IAM Role"
    value       = { for k, v in aws_iam_role.role : k => v.name }
  
}