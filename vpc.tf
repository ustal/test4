# 1.1 Create new VPC with following topology
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${var.env-name}-vpc"
  cidr = "10.0.0.0/16"

  azs = ["${local.region}a", "${local.region}b"]
  # 1.1.3 2 public subnets 
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  # 1.1.1 2 private subnets (EKS)
  private_subnets = ["10.0.2.0/24", "10.0.3.0/24"] // be aware merging cidr block for nacl rds (database_inbound_acl_rules, database_outbound_acl_rules)
  # 1.1.2 2 privae subnets (RDS)
  database_subnets = ["10.0.4.0/24", "10.0.5.0/24"]

  # 1.1.5 NAT Gateway
  # 1.3 All traffic from Private subnet to Internet route thru NAT Gateway
  enable_nat_gateway     = true  // false
  single_nat_gateway     = false // false
  one_nat_gateway_per_az = false // false
  # 1.1.4 Internet Gateway
  create_igw = true // true

  create_database_subnet_group       = true // true
  create_database_subnet_route_table = true // false
  enable_dns_hostnames               = true
  enable_dns_support                 = true

  database_dedicated_network_acl = true
  database_inbound_acl_rules = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_block  = "10.0.2.0/23"
  }]
  database_outbound_acl_rules = [{
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = "10.0.2.0/23"
  }]

  igw_tags = {
    "Name" = "${var.env-name}-vpc-igw"
  }
  database_acl_tags = {
    "Name" = "${var.env-name}-vpc-db-nacl"
  }
}
