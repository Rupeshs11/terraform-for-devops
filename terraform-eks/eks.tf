module "eks" {

  # used for importing the module template
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # important for cluster info (control plane)
  name                    = local.name
  kubernetes_version = "1.29"
  endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # addons
  addons = {
    vpc-cni = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    core-dns = {
      most_recent = true
    }
  }

  # control plane network
  control_plane_subnet_ids = module.vpc.intra_subnets

  # managing nodes in the cluster
  eks_managed_node_groups = {
    knox-cluster-ng = {
      instance_types = ["t2.small"]

      min_size       = 2
      max_size       = 3
      desired_size   = 2

      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}
