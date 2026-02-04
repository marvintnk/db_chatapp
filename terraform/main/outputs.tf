output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_b.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

output "alb_dns_name" {
  value       = aws_lb.chatapp.dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "application_url" {
  value       = "https://${aws_lb.chatapp.dns_name}"
  description = "Application URL (via ALB DNS)"
}


output "db_endpoint" {
  value     = aws_db_instance.mysql.address
  sensitive = true
}

output "db_port" {
  value = aws_db_instance.mysql.port
}

output "db_name" {
  value     = aws_db_instance.mysql.db_name
  sensitive = true
}

output "db_username" {
  value     = aws_db_instance.mysql.username
  sensitive = true
}