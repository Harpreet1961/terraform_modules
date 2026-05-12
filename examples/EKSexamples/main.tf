provider "aws" {
  region = "ap-south-1"

}

module "vpc_object" {
  source             = "../../modules/VPC"
  tfc_vpc_object     = var.tfc_vpc_object
  tfc_subnets_object = var.tfc_subnets_object
}

### IAM Module
module "iam_policy_object" {
  source              = "../../modules/IAM/policybaseline"
  tfc_iam_policy_object = var.tfc_iam_policy_object
  iam_policy_enabled  = var.iam_policy_enabled
}

module "iam_role_object" {
  source = "../../modules/IAM/rolebaseline"
  iam_assume_role_policy = var.iam_assume_role_policy
  tfc_iam_role_object = var.tfc_iam_role_object
  iam_enabled = var.iam_enabled
  
}

module "eks_object" {
    source = "../../modules/EKS"
    tfc_eks_object = var.tfc_eks_object
    eks_enabled = var.eks_enabled
    eks_role_arn = module.iam_role_object.role_arn 
    eks_subnet_ids = module.vpc_object.public_subnets_by_vpc
    depends_on = [module.vpc_object, module.iam_role_object]
  
}

locals {
  policy_by_assume_key = { for k, v in var.tfc_iam_policy_object : v.assume_role_policy_key => k }
}

resource "aws_iam_policy_attachment" "role_policy_attachment" {
  for_each = { for k, v in var.tfc_iam_role_object  : k => v if var.iam_policy_enabled }
  name =    "${each.value.role_name}-attachment"
  policy_arn = module.iam_policy_object.policy_arn[local.policy_by_assume_key[each.value.assume_role_policy_key]]
  roles = [module.iam_role_object.role_name[each.key]]
}

######EKS Cluster with IAM Role and Policy

resource "aws_eks_cluster" "example" {
  name = "example"

  access_config {
    authentication_mode = "API"
  }

 # role_arn = aws_iam_role.cluster.arn
  role_arn = module.iam_role_object.role_arn["eks_role"]
  version  = "1.31"

  vpc_config {
    subnet_ids = module.vpc_object.public_subnets_by_vpc["dev"]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  depends_on = [ module.vpc_object]
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# resource "aws_eks_access_entry" "admin" {
#   cluster_name  = aws_eks_cluster.example.name
#   principal_arn = "arn:aws:iam::511243596056:user/bgn55dy8n7d4x0ug"
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "admin" {
#   cluster_name  = aws_eks_cluster.example.name
#   principal_arn = aws_eks_access_entry.admin.principal_arn

#   policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

#   access_scope {
#     type = "cluster"
#   }
# }