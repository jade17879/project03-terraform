resource "aws_security_group" "web" {
  name        = "${var.name}-web-sg"
  description = "HTTP access and restricted SSH"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    description = "HTTP web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ssh_cidr == "" ? [] : [var.ssh_cidr]

    content {
      description = "Restricted SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    description = "Outbound traffic for package installation"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-web-sg"
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "web" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  iam_instance_profile = var.instance_profile_name
  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx
    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
      <head><title>Project 03</title></head>
      <body>
        <h1>Project-03: Terraform Deployment Successful!</h1>
        <p>Provisioned automatically using AWS and GitHub Actions.</p>
      </body>
    </html>
    HTML
    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = {
    Name = "${var.name}-web-server"
  }
}

resource "aws_eip" "web" {
  domain   = "vpc"
  instance = aws_instance.web.id

  tags = {
    Name = "${var.name}-web-eip"
  }
}