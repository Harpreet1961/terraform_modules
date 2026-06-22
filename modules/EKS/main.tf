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
  capacity_type = each.value.capacity_type
  instance_types = each.value.instance_types
  disk_size = each.value.disk_size != null ? each.value.disk_size : 20

  scaling_config {
    desired_size = each.value.desired_size != null ? each.value.desired_size : 2
    max_size     = each.value.max_size != null ? each.value.max_size : 3
    min_size     = each.value.min_size != null ? each.value.min_size : 1
    
}   
update_config {
  max_unavailable = 1
}
labels = {
  environment= each.value.environment
  nodegroup= each.value.nodegroup
}
tags = {
  Name        = "${each.value.cluster_name}-node-group"
  Environment = each.value.environment
}

}
data "tls_certificate" "eks_oidc" {
  for_each = {for k, v in var.tfc_eks_object : k => v if var.eks_enabled }
  url      = aws_eks_cluster.eks_cluster[each.key].identity[0].oidc[0].issuer
  
}
resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  for_each = {for k, v in var.tfc_eks_object : k => v if var.eks_enabled }
  url = aws_eks_cluster.eks_cluster[each.key].identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc[each.key].certificates[0].sha1_fingerprint]
  
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  for_each = {for k, v in var.tfc_eks_object : k => v if var.eks_enabled }
  name = "${each.value.cluster_name}-ebs-csi-driver-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc_provider[each.key].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.eks_cluster[each.key].identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
  
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  for_each = {for k, v in var.tfc_eks_object : k => v if var.eks_enabled }
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver_role[each.key].name
  
}

resource "aws_eks_addon" "eks_addon" {

  for_each = merge([
    for cluster_key, cluster_value in var.tfc_eks_object :
    {
      for addon in cluster_value.eks_addons :
      "${cluster_key}-${addon.addon_name}" => {

        cluster_key               = cluster_key
        addon_name                = addon.addon_name
        addon_version             = addon.addon_version
        resolve_conflicts         = addon.resolve_conflicts
      }
    }
  ]...)

  cluster_name = aws_eks_cluster.eks_cluster[
    each.value.cluster_key
  ].name

  addon_name    = each.value.addon_name
  addon_version = each.value.addon_version

  resolve_conflicts_on_create = each.value.resolve_conflicts
  resolve_conflicts_on_update = each.value.resolve_conflicts
  service_account_role_arn = each.value.addon_name =="aws-ebs-csi-driver" ? aws_iam_role.ebs_csi_driver_role[each.value.cluster_key].arn : null

  depends_on = [
    aws_eks_node_group.eks_node_group,
    aws_iam_role_policy_attachment.ebs_csi_driver_policy_attachment
  ]
}