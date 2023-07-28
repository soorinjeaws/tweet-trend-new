provider "aws" {
      region  = "us-east-1"
   }
resource "aws_instance" "demo-server" {
   ami= "ami-0f34c5ae932e6f0e4"
   instance_type = "t2.micro"
   key_name = "A.R-PROJECT"
   security_groups = [ "demo-sg" ]
   }

resource "aws_security_group" "demo-sg" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22 
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
