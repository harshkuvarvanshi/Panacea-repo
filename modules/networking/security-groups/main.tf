# ================================
# SECURITY GROUP
# ================================

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  # 👉 VPC required (Person 1 se aayega later)

  tags = {
    Name       = var.name
    Deployment = "manual"
  }
}

# ================================
# INBOUND RULES
# ================================

resource "aws_security_group_rule" "ingress" {
  count = length(var.ingress_rules)

  type              = "ingress"
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol

  cidr_blocks              = lookup(var.ingress_rules[count.index], "cidr_blocks", null)
  source_security_group_id = lookup(var.ingress_rules[count.index], "sg_id", null)

  security_group_id = aws_security_group.this.id
}

# ================================
# OUTBOUND RULES
# ================================

resource "aws_security_group_rule" "egress" {
  count = length(var.egress_rules)

  type              = "egress"
  from_port         = var.egress_rules[count.index].from_port
  to_port           = var.egress_rules[count.index].to_port
  protocol          = var.egress_rules[count.index].protocol

  cidr_blocks = var.egress_rules[count.index].cidr_blocks

  security_group_id = aws_security_group.this.id
}