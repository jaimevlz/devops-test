provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "pythonApp" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = "jenkins_key"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo git clone https://github.com/jaimevlz/devops-test.git",
      "sudo curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo docker --version",
      "sudo cd devops-test/python-deploy/terraform/",
      "sudo docker build -t pythonApp",
      "sudo docker run -d -p 5000:5000 pythonApp",    
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("jenkins_key.pem")
  }

  tags = {
    "Name"      = "pythonApp"
    "Terraform" = "true"
  }
}
