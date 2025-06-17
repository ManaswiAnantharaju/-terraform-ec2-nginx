provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "project_key" {
  key_name   = "project-1-key"
  public_key = file("~/.ssh/project-1-key.pub")
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (Ohio)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.project_key.key_name

  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "app-server-dev"
  }
}
