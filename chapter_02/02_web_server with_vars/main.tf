provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"

  user_data                   = <<-EOF
  #!/bin/bash
  echo "Hello World!" > index.html
  nohup busybox httpd -f -p "${var.server_port}" &
  EOF
  user_data_replace_on_change = true

  tags = {
    Name = "HelloWorld-v7"
  }
}

resource "aws_security_group" "test_sg" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value       = aws_instance.test_instance.public_ip
  description = "The public IP address of the web server"
}