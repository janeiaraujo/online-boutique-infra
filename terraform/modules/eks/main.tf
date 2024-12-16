module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.26"
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets


  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    FinOps      = "cost-center:12345"
  }
}
