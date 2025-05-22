output "database_address" {
  value       = aws_db_instance.rds_database.address
  description = "Connect to the database at this endpoint"
}

output "database_port" {
  value       = aws_db_instance.rds_database.port
  description = "The port the database is listening on"
}

output "db_endpoint" {
  description = "The RDS endpoint"
  value       = aws_db_instance.rds_database.endpoint
}

output "db_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.rds_database.id
}
