variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "db_identifier_prefix" {
  description = "Identifier prefix for database"
  type        = string
}

variable "db_engine" {
  description = "Type of database engine"
  type        = string
}

variable "db_allocated_storage" {
  description = "Amount of allocated storage for RDS database"
  type        = number
}

variable "db_instance_class" {
  description = "Instance class for RDS database"
  type        = string
}

variable "db_skip_final_snapshot" {
  description = "Boolean to tell whether to skip final RDS DB snapshot"
  type        = bool
}

variable "database_name" {
  description = "Name of the RDS database"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}

variable "rds_sg_ingress" {
  description = "CIDR block allowed to RDS DB"
  type        = list(string)
  default     = ["172.0.0.0/8"]
}