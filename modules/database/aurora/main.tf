terraform {
  backend "s3" {}
}

############################
# Subnet Group
############################
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

############################
# Security Group
############################
resource "aws_security_group" "aurora" {
  name   = "${var.name}-aurora-sg"
  vpc_id = var.vpc_id

  # TEMP: CIDR (replace with SG later)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# Aurora Cluster
############################
resource "aws_rds_cluster" "this" {
  cluster_identifier = var.name

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.0"

  database_name   = var.db_name
  master_username = var.db_username
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  backup_retention_period = 7
  storage_encrypted       = true

  skip_final_snapshot = true
}

############################
# Aurora Instance
############################
resource "aws_rds_cluster_instance" "this" {
  identifier         = "${var.name}-instance"
  cluster_identifier = aws_rds_cluster.this.id

  instance_class = "db.t3.medium"
  engine         = aws_rds_cluster.this.engine
}