terraform {
  backend "s3" {
    bucket         = "terraform-modules-state-650251690412"
    key            = "eks-examples/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-modules-lock"
    encrypt        = true
  }
}