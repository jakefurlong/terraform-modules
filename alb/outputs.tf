output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = aws_lb.terraform_alb.dns_name
}

output "aws_target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_alb_target_group.terraform_tg.arn
}