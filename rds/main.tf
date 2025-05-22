resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.db_identifier_prefix}-subnet-group"
  subnet_ids = local.effective_subnet_ids

  tags = {
    Name = "${var.db_identifier_prefix}-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.db_identifier_prefix}-rds-sg"
  description = "Allow inbound MySQL access"
  vpc_id      = local.effective_vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.rds_sg_ingress
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier_prefix}-rds-sg"
  }
}

resource "aws_db_instance" "rds_database" {
  identifier_prefix   = var.db_identifier_prefix
  engine              = var.db_engine
  allocated_storage   = var.db_allocated_storage
  instance_class      = var.db_instance_class
  skip_final_snapshot = var.db_skip_final_snapshot
  db_name             = var.database_name
  username            = var.db_username
  password            = var.db_password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  publicly_accessible = false
}


