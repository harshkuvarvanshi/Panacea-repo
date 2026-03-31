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
    Name        = "${var.name}-subnet-group"
    Environment = var.environment
  }
}

############################
# Aurora Cluster
############################
resource "aws_rds_cluster" "this" {
  cluster_identifier = var.name

  engine         = var.engine
  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.db_username
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids   # 🔥 external SG module

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.backup_window

  storage_encrypted = true

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  skip_final_snapshot = var.skip_final_snapshot

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

############################
# Aurora Instances (multi)
############################
resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id

  instance_class = var.instance_class
  engine         = aws_rds_cluster.this.engine

  publicly_accessible = false

  tags = {
    Name        = "${var.name}-${count.index}"
    Environment = var.environment
  }
}