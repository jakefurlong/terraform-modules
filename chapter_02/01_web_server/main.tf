provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"

  user_data                   = <<-EOF
  #!/bin/bash
  echo "Hello World!" > index.html
  nohup busybox httpd -f -p 8080 &
  EOF
  user_data_replace_on_change = true

  tags = {
    Name = "HelloWorld-v6"
  }
}

resource "aws_security_group" "test_sg" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}