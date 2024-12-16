variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "password123"
}

variable "additional_tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}


