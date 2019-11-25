
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("${var.PATH_TO_PUBLIC_KEY}")
}

resource "aws_instance" "webserver" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mykey.key_name
  tags = {
    Name = "JenkinsServer"
  }
}

resource "aws_security_group" "jenkins-securitygroup" {
  name        = "jenkins-securitygroup"
  description = "security group that allows ssh and all egress traffic"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "jenkins-securitygroup"
  }
}


resource "aws_eip" "ip" {
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.INSTANCE_USERNAME
    private_key = file("${var.PATH_TO_PRIVATE_KEY}")
  }

  instance = aws_instance.webserver.id

  provisioner "file" {
    source      = "jenkinsfile.sh"
    destination = "/tmp/jenkinsfile.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkinsfile.sh",
      "sudo /tmp/jenkinsfile.sh"
    ]
  }

}

output "instance_ip_addr" {
  value = aws_instance.webserver.public_ip
}
