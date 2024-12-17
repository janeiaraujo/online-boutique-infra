module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.26"
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_security_group_additional_rules = {
    ingress_ec2_tcp = {
      description                = "Access EKS from EC2 instance."
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      cidr_blocks              = ["0.0.0.0/0"] # Ajuste em produção
      # security_groups            = [var.ec2_sg_id]
      # source_cluster_security_group = true
    }
  }


  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    FinOps      = "cost-center:12345"
  }
}
