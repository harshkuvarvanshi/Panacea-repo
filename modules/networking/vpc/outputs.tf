output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = values(aws_subnet.public)[*].id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.this.cidr_block  
}

output "private_subnet_ids" {
  value = values(aws_subnet.private)[*].id
}