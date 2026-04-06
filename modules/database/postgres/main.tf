terraform {
  backend "s3" {}
}

############################
# DB Subnet Group
############################
resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for ${var.name} PostgreSQL RDS"

  tags = {
    Name        = "${var.name}-subnet-group"
    Environment = var.environment
  }
}

############################
# Parameter Group
############################
resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-pg15"
  family      = "postgres15"
  description = "Custom parameter group for ${var.name}"

  # Log all connections and disconnections
  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  # Log queries slower than 1 second
  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  # Enable query stats collection
  parameter {
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements"
    apply_method = "pending-reboot"
  }

  tags = {
    Name        = "${var.name}-pg15"
    Environment = var.environment
  }
}

############################
# Enhanced Monitoring Role
############################
data "aws_iam_policy_document" "rds_monitoring_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_monitoring" {
  name               = "${var.name}-rds-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_assume.json

  tags = {
    Name        = "${var.name}-rds-monitoring-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

############################
# RDS PostgreSQL (Multi-AZ)
############################
resource "aws_db_instance" "this" {
  identifier     = var.name
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  # ── Storage ──────────────────────────────────
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = var.kms_key_id

  # ── Credentials ──────────────────────────────
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # ── Network ──────────────────────────────────
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = false

  # ── High Availability ────────────────────────
  multi_az = true

  # ── Parameter Group ──────────────────────────
  parameter_group_name = aws_db_parameter_group.this.name

  # ── Backups ──────────────────────────────────
  backup_retention_period  = var.backup_retention_period
  backup_window            = "02:00-03:00"
  maintenance_window       = "mon:04:00-mon:05:00"
  delete_automated_backups = false
  copy_tags_to_snapshot    = true

  # ── Final Snapshot ───────────────────────────
  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.name}-final-snapshot"

  # ── Monitoring ───────────────────────────────
  monitoring_interval                   = 60
  monitoring_role_arn                   = aws_iam_role.rds_monitoring.arn
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  # ── Protection ───────────────────────────────
  deletion_protection        = var.deletion_protection
  auto_minor_version_upgrade = true

  tags = {
    Name        = var.name
    Environment = var.environment
  }

  #lifecycle {
   # prevent_destroy = true
    #ignore_changes  = [password] # managed via Secrets Manager
  #}
}

############################
# Secrets Manager — DB Creds
############################
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.name}/db-credentials"
  recovery_window_in_days = 0 # ← force immediate deletion
  force_overwrite_replica_secret = true  # ← overwrite if exists

  tags = {
    Name        = "${var.name}-db-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    dbname   = var.db_name
    engine   = "postgres"
  })
}
