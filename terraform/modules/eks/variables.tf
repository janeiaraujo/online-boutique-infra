variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of nodes"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of nodes"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of nodes"
  type        = number
}

variable "node_instance_type" {
  description = "Instance type for the worker nodes"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
