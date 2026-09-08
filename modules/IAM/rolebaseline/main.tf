resource "aws_iam_role" "role" {
  for_each = { for k, v in var.tfc_iam_role_object : k => v if var.iam_enabled }
  name     = each.value.role_name
  assume_role_policy = var.iam_assume_role_policy[each.value.assume_role_policy_key]
  tags = {
    Name = each.value.role_name
  }
  
}