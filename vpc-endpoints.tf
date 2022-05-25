# 1.2 Endpoints

module "vpc-endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    # 1.2.3 S3
    s3 = {
      service            = "s3"
      subnet_ids         = module.vpc.private_subnets
      security_group_ids = [module.http_https_private_sgroup.security_group_id]
      tags               = { "Name" = "s3-vpc-endpoint" }
    }
    # 1.2.6 CW Logs
    logs = {
      service            = "logs"
      subnet_ids         = module.vpc.private_subnets
      security_group_ids = [module.eks.cluster_security_group_id]
      tags               = { "Name" = "logs-vpc-endpoint" }
    },
    # 1.2.4 EC2
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [module.eks.cluster_security_group_id]
      tags                = { "Name" = "ec2-vpc-endpoint" }
    },
    # 1.2.1 ECR API
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [module.eks.cluster_security_group_id]
      tags                = { "Name" = "ecr.api-vpc-endpoint" }
    },
    # 1.2.2 ECR Docker
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [module.eks.cluster_security_group_id]
      tags                = { "Name" = "ecr.dkr-vpc-endpoint" }
    },
    # 1.2.5 STS
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [module.eks.cluster_security_group_id]
      tags                = { "Name" = "sts-vpc-endpoint" }
    }
  }
}