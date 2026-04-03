provider "aws" {
    region = "us-east-1"
  
}

module "vpc_object" {   
    source = "./modules"
    tfc_vpc_object = var.tfc_vpc_object
    tfc_subnets_object = var.tfc_subnets_object
    
  
}

