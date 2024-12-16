module "vpc" {
  source = "./modules/vpc"

  name          = "online-boutique-vpc"
  cidr_block    = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  environment   = var.environment
  additional_tags = var.additional_tags
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "online-boutique-eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  desired_capacity = 2
  max_capacity     = 5
  min_capacity     = 1
  node_instance_type = "t3.medium"
  environment       = var.environment
}


module "s3_backend" {
  source = "./modules/s3_backend"

  bucket_name    = "terraform-state-online-boutique"
  dynamodb_table = "terraform-locks"
  environment    = var.environment
  additional_tags = var.additional_tags
}

module "rds" {
  source                = "./modules/rds"
  db_name               = "online_boutique"
  db_identifier         = "online-boutique-db"
  db_username           = "masteruser"   # Nome válido para o usuário
  db_password           = var.db_password
  allocated_storage     = 20
  instance_class        = "db.t3.micro"
  engine                = "postgres"
  engine_version        = "17.2"
  backup_retention_period = 7
  multi_az              = false
  security_group_ids    = [module.vpc.rds_security_group_id]
  subnet_group_name     = "rds-subnet-group"
  subnet_ids            = module.vpc.private_subnets
  environment           = var.environment
  additional_tags       = var.additional_tags
}

