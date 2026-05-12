output "endpoint" {
   value = {
    for k, v in aws_eks_cluster.eks_cluster : k => v.endpoint
   }
   description = "The endpoint of the EKS cluster created by the module"
}