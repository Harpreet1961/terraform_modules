provider "aws" {
  region = "ap-south-1"

}

module "iam_policy_object" {
    source = "../../modules/IAM/policybaseline"
    tfc_iam_policy_object = var.tfc_iam_policy_object
    iam_policy_enabled = var.iam_policy_enabled
  
}

module "iam_role_object" {
    source = "../../modules/IAM/rolebaseline"
    iam_assume_role_policy = var.iam_assume_role_policy
    tfc_iam_role_object = var.tfc_iam_role_object
    iam_enabled = var.iam_enabled
  
}

# resource "aws_iam_policy_attachment" "policy_attachment" {
#   for_each = { for k, v in var.tfc_iam_policy_object : k => v if var.iam_policy_enabled }
#   name       = "${each.value.policy_name}-attachment"
#   policy_arn = module.iam_policy_object.policy_arn[each.value.assume_role_policy_key]
#   roles      = module.iam_role_object.role_name[each.value.assume_role_policy_key]
  
# }
# resource "aws_iam_policy_attachment" "role_policy" {
#  name= "s3_read_only_policy_attachment"
#  policy_arn = module.iam_policy_object.policy_arn["s3_read_only_policy"]
#  roles = [module.iam_role_object.role_name["s3_role"]]  
# }

resource "aws_iam_policy_attachment" "role_policy_attachment" {
  for_each = { for k, v in var.tfc_iam_role_object  : k => v if var.iam_policy_enabled }
  name =    "${each.value.role_name}-attachment"
  policy_arn = module.iam_policy_object.policy_arn[each.value.assume_role_policy_key]
  roles = [module.iam_role_object.role_name["s3_role"]]
}

resource "aws_iam_instance_profile" "instance_profile" {
  for_each = { for k, v in var.tfc_iam_role_object : k => v if var.iam_enabled }
  name = "${each.value.role_name}-instance-profile"
  role = module.iam_role_object.role_name[each.key]
  
}