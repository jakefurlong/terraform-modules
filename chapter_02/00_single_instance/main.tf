provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld-v1"
  }
}