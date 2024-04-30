provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {
  state = "available" 
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.0.4"

  cluster_name    = "my-cluster"
  cluster_version = "1.24"

  vpc_id = aws_vpc.main.id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 2

      instance_types = ["t3.small"]
    }
  }

  # Enable ALB ingress
  cluster_endpoint_public_access = true

  # Kubernetes ingress
  cluster_create_endpoint_private_access_sg_rule = true
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_us_west_2a" {
  vpc_id            = aws_vpc.main.id 
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

# ALB ingress controller
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "ingress_controller" {
  source  = "iplabs/alb-ingress-controller/kubernetes"
  version = "2.3.2"

  cluster_name    = data.aws_eks_cluster.cluster.name
  cluster_identity_oidc_issuer = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  aws_region = "us-west-2"
}
