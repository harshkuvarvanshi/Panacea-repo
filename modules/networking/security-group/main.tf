terraform {
  backend "s3" {}
}

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  # Supports both CIDR-based and SG-to-SG ingress rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description

      # Use SG-to-SG if source_security_group_id is set, else CIDR
      security_groups = lookup(ingress.value, "source_security_group_id", null) != null ? [ingress.value.source_security_group_id] : []
      cidr_blocks     = lookup(ingress.value, "source_security_group_id", null) != null ? [] : lookup(ingress.value, "cidr_blocks", [])
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name = var.name
  }
}
