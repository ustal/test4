# 2 RDS
module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "postgre-test"
  # 2.2 Create RDS Postgres DB
  engine               = "postgres"
  engine_version       = "14.1"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t3.micro"

  allocated_storage     = 10
  max_allocated_storage = 20

  db_name  = "db_name"
  username = "db_user"
  port     = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
}