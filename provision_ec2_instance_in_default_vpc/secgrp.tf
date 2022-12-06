resource "aws_security_group" "web-sg" {
  name = "web-secgrp"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # To restrict access should set to your public IP
    cidr_blocks = ["112.134.21.88/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # To restrict access should set to your public IP
    cidr_blocks = ["112.134.21.88/32"]
  }

  egress {
        from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
