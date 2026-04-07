# ==========================================
# APPLICATION LOAD BALANCER (ALB)
# ==========================================
terraform {
  backend "s3" {}
}


resource "aws_lb" "this" {
  name               = var.name
  internal           = false  # Internet-facing ALB
  load_balancer_type = "application"

  # Public subnets (must be public for internet access)
  subnets = var.subnets

  # Security group allowing HTTP (80) from internet
  security_groups = var.security_groups

  #access_logs {
 #bucket  = var.logs_bucket_name
  #prefix  = "alb"
 # enabled = true
#}

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}


# ==========================================
# TARGET GROUP (DFB EC2 Backend)
# ==========================================
resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = 8000
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = var.vpc_id

  # Health check for backend
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}


# ==========================================
# ATTACH EC2 INSTANCES TO TARGET GROUP
# ==========================================
resource "aws_lb_target_group_attachment" "this" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.instance_ids[count.index]
  port             = 8000
}

# ==========================================
# LISTENER (HTTP 80)
# ==========================================
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}