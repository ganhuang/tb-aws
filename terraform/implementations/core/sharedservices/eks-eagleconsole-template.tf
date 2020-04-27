# EKS cluster

module "aws_lz_eks_eagleconsole_cluster" {
  source = "./modules/eks"
  providers = {
    aws = aws.sharedservices-account
  }

  eks_cluster_name          = var.ec_eks_cluster_name
  eks_iam_role_name         = var.ec_eks_role_name
  subnets                   = module.vpc_shared_services.private_subnets

  node_group_name           = var.ec_eks_node_group_name
  node_group_role_name      = var.ec_eks_node_group_role_name
  node_group_subnets        = module.vpc_shared_services.private_subnets
  node_group_instance_types = var.ec_eks_node_group_instance_types
}
# END EKS cluster



/*
provider "random" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}
/*
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
//  host                   = data.aws_eks_cluster.cluster.endpoint
  host                   = module.eks.cluster_id.endpoint
//  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  cluster_ca_certificate = base64decode(module.eks.cluster_id.certificate_authority.0.data)
//  token                  = data.aws_eks_cluster_auth.cluster.token
  token                  = module.eks.cluster_id.token
  load_config_file       = false
  version                = "~> 1.11"
}

locals {
  cluster_name = "ec-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

/*
module "aws_eks_sg" {
  source      = "./modules/eks-2"

  providers = {
    aws = aws.sharedservices-account
  }

  eks_vpc_id = module.vpc.vpc_id
}


module "eks_vpc" {
  providers = {
    aws = aws.sharedservices-account
  }

  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = "eks-vpc"
  cidr                 = "10.99.16.0/22"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.99.16.0/24", "10.99.17.0/24"]
  public_subnets       = ["10.99.18.0/24", "10.99.19.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "worker_group_mgmt_one" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"
  
  providers = {
    aws = aws.sharedservices-account
  }
  name = "worker_group_mgmt_one"
  description = "worker_group_mgmt_one"
  vpc_id = module.eks_vpc.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = var.all_all_egress_rules

}

module "worker_group_mgmt_two" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"
  
  providers = {
    aws = aws.sharedservices-account
  }
  name = "worker_group_mgmt_two"
  description = "worker_group_mgmt_two"
  vpc_id = module.eks_vpc.vpc_id

  ingress_cidr_blocks = ["192.168.0.0/16"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = var.all_all_egress_rules

}

module "eks" {
  providers = {
    aws = aws.sharedservices-account
  }

  source        = "terraform-aws-modules/eks/aws"
  version       = "11.1.0"
  cluster_name  = local.cluster_name
  subnets       = module.eks_vpc.private_subnets

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.eks_vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      //additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      //additional_security_group_ids = var.sg_worker_group_mgmt_one_id
      additional_security_group_ids = module.worker_group_mgmt_one.this_security_group_id 
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      //additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      //additional_security_group_ids = var.sg_worker_group_mgmt_two_id
      additional_security_group_ids = module.worker_group_mgmt_two.this_security_group_id 
      asg_desired_capacity          = 1
    },
  ]

  //worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  //map_roles                            = var.map_roles
  //map_users                            = var.map_users
  //map_accounts                         = var.map_accounts
}
*/