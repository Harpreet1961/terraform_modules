resource "aws_eks_cluster" "eks_cluster" {
for_each = {for k, v in var.tfc_eks_object : k => v if var.eks_enabled }
  name     = each.value.cluster_name
  role_arn = var.eks_role_arn[each.value.role_key]
  version  = each.value.kubernetes_version
  bootstrap_self_managed_addons = each.value.bootstrap_self_managed_addons
  
  vpc_config {
    subnet_ids = var.eks_subnet_ids[each.value.vpc_key]
  }
  
}

resource "aws_eks_node_group" "eks_node_group" {
  for_each = {for k, v in var.tfc_eks_object : k => v if var.eks_enabled }
  cluster_name    = aws_eks_cluster.eks_cluster[each.key].name
  node_group_name = "${each.value.cluster_name}-node-group"
  node_role_arn   = var.eks_role_arn[each.value.node_role_key]
  subnet_ids      = var.eks_subnet_ids[each.value.vpc_key]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1    
  
}   

}