provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_default_vpc" "default" {
  force_destroy = true
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-0e9bfdb247cc8de84"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "willamette_keypair"

  user_data = <<-EOF
              #!/bin/bash
              apt-get install -y apache2 && sleep 5
              echo "Hello, T101 Study by Willamette" > /var/www/html/index.html
              service apache2 reload 
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "Single-WebSrv"
  }
}


resource "aws_security_group" "instance" {
  name       = var.security_group_name
  depends_on = [aws_default_vpc.default]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}


