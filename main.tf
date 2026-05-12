provider "aws" {
  region = "ap-south-1"

}


module "vpc_object" {
  source             = "./modules/VPC"
  tfc_vpc_object     = var.tfc_vpc_object
  tfc_subnets_object = var.tfc_subnets_object


}

module "sg_object" {
  source        = "./modules/security_group"
  tfc_sg_object = var.tfc_sg_object
  sg_enabled    = var.sg_enabled
  vpc_id        = module.vpc_object.vpc_id

  depends_on = [module.vpc_object]
}

module "ec2_object" {
  source            = "./modules/ec2baseline"
  tfc_ec2_object    = var.tfc_ec2_object
  ec2_enabled       = var.ec2_enabled
  subnet_id         = module.vpc_object.subnet_id
  security_group_id = module.sg_object.sg_id
  ebs_enabled = var.ebs_enabled  
  depends_on = [module.vpc_object, module.sg_object]

}
# resource "aws_security_group_rule" "ec2_to_rds" {
#   for_each = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled && var.rds_enabled }
#   type              = "ingress"
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   security_group_id = module.sg_object.sg_id[each.value.sg_key]
#   source_security_group_id =  module.sg_object.sg_id[each.value.sg_key]
# }
resource "aws_security_group_rule" "ec2_to_rds" {
  type = "egress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = module.sg_object.sg_id["sg_prod"]
  source_security_group_id = module.sg_object.sg_id["ec2_rds_sg"]
  
}

resource "aws_security_group_rule" "rds" {
  for_each = {for k , v in var.tfc_rds_object : k => v if var.rds_enabled }
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.sg_object.sg_id[each.value.sg_key]
  source_security_group_id = module.sg_object.sg_id[each.value.allowed_sg_key]
} 

output "security_group_rule_ec2_to_rds" {
  value= aws_security_group_rule.ec2_to_rds.id
  description = "Security Group Rule for EC2 to RDS communication"
  
}
output "security_group_rule_rds" {
  value = { for k, v in aws_security_group_rule.rds : k => v.id }
  description = "Security Group Rule for RDS ingress communication"
  
}

module "rds_object" {
    source                = "./modules/RDS"
    tfc_rds_object        = var.tfc_rds_object
    rds_enabled           = var.rds_enabled
    private_subnet_ids    = module.vpc_object.private_subnets_by_vpc
    security_group_id     = module.sg_object.sg_id
    
    depends_on = [module.vpc_object, module.sg_object]
  
}

# ######EKS Cluster with IAM Role and Policy

# resource "aws_eks_cluster" "example" {
#   name = "example"

#   access_config {
#     authentication_mode = "API"
#   }

#   role_arn = aws_iam_role.cluster.arn
#   version  = "1.31"

#   vpc_config {
#     subnet_ids = module.vpc_object.public_subnets_by_vpc["dev"]
#   }

#   # Ensure that IAM Role permissions are created before and deleted
#   # after EKS Cluster handling. Otherwise, EKS will not be able to
#   # properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
#   ]
# }

# resource "aws_iam_role" "cluster" {
#   name = "eks-cluster-example"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
#   depends_on = [ module.vpc_object,module.ec2_object ]
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.cluster.name
# }