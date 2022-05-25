# 3 EKS
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "test-eks"
  cluster_version = "1.22"

  //cluster_endpoint_private_access = true
  //cluster_endpoint_public_access  = true

  cluster_addons = {
    # 3.4 Create Addon coredns
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    # 3.3 Create Addon kube-proxy
    kube-proxy = {}
    # 3.5 Create Addon vpc-cni
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    # 3.1 Node group disk size 10g
    disk_size      = 10
    # 3.2 Node group instance type t3a.medium
    instance_types = [var.node_instance_type]
  }

  # 3.6 Define autoscaling config for node group min size 1, max size 2, desired size 1
  eks_managed_node_groups = {
    group-1 = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      # 3.2 Node group instance type t3a.medium
      instance_types = [var.node_instance_type]
    }
  }
}
