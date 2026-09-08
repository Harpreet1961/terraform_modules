resource "aws_iam_policy" "policy" {
  for_each = { for k, v in var.tfc_iam_policy_object : k => v if var.iam_policy_enabled }
  name     = each.value.policy_name
  path     = "/"
  policy   = each.value.policy_document
  tags = {
    Name = each.value.policy_name
  }
  
}

