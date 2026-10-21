output "vpc_id" {
  description = "Created VPC ID"
  value       = module.networking.vpc_id
}

output "ec2_instance_id" {
  description = "Web server EC2 instance ID"
  value       = module.compute.instance_id
}

output "elastic_ip" {
  description = "Web server Elastic IP"
  value       = module.compute.elastic_ip
}

output "application_url" {
  description = "Web server URL"
  value       = "http://${module.compute.elastic_ip}"
}

output "s3_bucket_name" {
  description = "Application S3 bucket name"
  value       = aws_s3_bucket.application.bucket
}

output "security_group_id" {
  description = "Web server security group"
  value       = module.compute.security_group_id
}

output "public_subnet_ids" {
  description = "Created public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "iam_role_name" {
  description = "EC2 IAM role name"
  value       = aws_iam_role.ec2.name
}