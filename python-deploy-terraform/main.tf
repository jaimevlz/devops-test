provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic Python App"
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
      "sudo cp -r devops-test/python-deploy-terraform/ /home/ubuntu",
      "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
      "sudo apt-get update",
      "sudo apt-get -y install postgresql postgresql-contrib",
      "sudo -u postgres createuser --superuser ubuntu",
      "sudo -u ubuntu createdb books_store",
      "sudo apt-get install software-properties-common",
      "sudo apt-get -y install python3-pip build-essential python3-dev",
      "pip3 install virtualenv",
      "cd python-deploy-terraform/",
      "virtualenv env",
      "source env/bin/activate",
      "export APP_SETTINGS=\"config.DevelopmentConfig\"",
      "export DATABASE_URL=\"postgresql:///books_store\"",
      "pip3 install -r requirements.txt",
      "python3 manage.py db init",
      "python3 manage.py db migrate",
      "python3 manage.py db upgrade",
      "gunicorn --bind 0.0.0.0:5000 run:app",
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
