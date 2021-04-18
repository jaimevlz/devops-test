provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22, 5000]
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic Python App 1"
  description = "Allow Ports"

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

resource "aws_instance" "pythonApp_1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = "jenkins_key"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections",
      "echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections",
      "sudo apt-get -y install iptables-persistent",
      "sudo ufw allow 5000",
      "sudo apt-get install software-properties-common",
      "sudo apt-get -y install python3-pip build-essential python3-dev",
      ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("jenkins_key.pem")
  }

  tags = {
    "Name"      = "pythonApp_1"
    "Terraform" = "true"
  }
}
