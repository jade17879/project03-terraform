locals {
  name = "project03-${var.environment}"
}

module "networking" {
  source       = "./modules/networking"
  name         = local.name
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.public_subnet_cidrs
}

resource "aws_iam_role" "ec2" {
  name = "${local.name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${local.name}-instance-profile"
  role = aws_iam_role.ec2.name
}

module "compute" {
  source                = "./modules/compute"
  name                  = local.name
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = module.networking.public_subnet_ids[0]
  ssh_cidr              = var.allowed_ssh_cidr
  instance_profile_name = aws_iam_instance_profile.ec2.name
}

resource "aws_s3_bucket" "application" {
  bucket_prefix = "${local.name}-app-"

  tags = {
    Name        = "${local.name}-app-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "application" {
  bucket = aws_s3_bucket.application.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "application" {
  bucket = aws_s3_bucket.application.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "application" {
  bucket = aws_s3_bucket.application.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}