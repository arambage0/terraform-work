terraform {

  required_providers {
    aws = {
    source  = "hashicorp/aws"

    version = "~> 3.27"

    }
  }


  required_version = ">= 0.14.9"

}

resource "aws_instance" "webserver" {
  #Ubuntu
  #ami = "ami-02045ebddb047018b"
  #Amazon Linux 2
  ami = "ami-0f62d9254ca98e1aa"

  instance_type = var.instance_type
  # key-pair is created manually in aws console and configured here.
  key_name = "ap-southeast-1-key"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
    delete_on_termination = false

}

user_data = <<EOF
 #!/bin/bash
 sudo yum install httpd -y
 sudo systemctl start httpd
 cd /var/www/html
 sudo echo "<h1>This is our test website deployed using Terraform.</h1>" > index.html
 EOF

  tags = {
    Name = "TestWebServerEC2Instance"
  }
}

output "IPAddress" {
  value = "${aws_instance.webserver.public_ip}"
}
