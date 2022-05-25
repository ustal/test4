# 2.1 Create special RDS Security Group and close all traffic to RDS private subnet except port 5432 (RDS Port)
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "sq"
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = "10.0.2.0/23"
      ingress_with_source_security_group_id = module.http_https_private_sgroup.security_group_id
    },
  ]
}


module "http_https_private_sgroup" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "private-http-https-sg"
  description = "HTTP, HTTPs SG"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = concat(module.vpc.public_subnets_cidr_blocks, module.vpc.private_subnets_cidr_blocks)
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
}

module "http_https_public_sgroup" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "http-https-sg"
  description = "HTTP, HTTPs SG"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
}
