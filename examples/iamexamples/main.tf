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
    tfc_iam_object = var.tfc_iam_object
    iam_enabled = var.iam_enabled
  
}