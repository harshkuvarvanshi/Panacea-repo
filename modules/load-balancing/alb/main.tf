resource "aws_lb" "this" {
  name               = var.name
  internal           = false  # ✅ Internet-facing ALB
  load_balancer_type = "application"

  subnets = var.subnets
  # 🔴 CHANGE HERE
  # 👉 Ye PUBLIC subnets hone chahiye (panacea-public-a, panacea-public-b)
  # 👉 Private subnet mat dena

  security_groups = var.security_groups
  # 🔴 CHANGE HERE
  # 👉 Should allow:
  # Inbound: 80 → 0.0.0.0/0

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

# ✅ Target Group (DFB EC2)
resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = 8000   # ✅ EC2 port
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = var.vpc_id
  # 🔴 CHANGE HERE
  # 👉 Replace with dependency.vpc.outputs.vpc_id

  health_check {
    path                = "/health"   # ✅ As per requirement
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = var.target_group_name
  }
}

# ✅ Attach EC2 (DFB)
resource "aws_lb_target_group_attachment" "this" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.this.arn

  target_id = var.instance_ids[count.index]
  # 🔴 CHANGE HERE
  # 👉 DFB EC2 instance IDs
  # 👉 Replace with dependency.ec2.outputs.instance_ids

  port = 8000
}

# ✅ Listener (HTTP 80)
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}