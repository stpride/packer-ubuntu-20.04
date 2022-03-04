
variable "ami_name" {
  type    = string
  default = "ubuntu-20.04-base"
}

variable "aws_access_key" {
  type    = string
  default = env("AWS_ACCESS_KEY_ID")
}

variable "aws_secret_key" {
  type    = string
  default = env("AWS_SECRET_ACCESS_KEY")
}

variable "aws_ami_accounts" {
  type    = string
  default = env("AWS_AMI_ACCOUNTS")
}

variable "aws_owner" {
  type    = string
  default = env("AWS_OWNER")
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_source_ami" {
  type    = string
  default = "ami-04505e74c0741db8d"
}

variable "aws_vpc_id" {
  type    = string
  default = "vpc-0081138e24ed47a0e"
}

variable "aws_subnet_id" {
  type    = string
  default = "subnet-09e013df6022091c8"
}

variable "aws_security_group_id" {
  type    = string
  default = "sg-0829ee2165780c58a"
}

variable "aws_tag_name" {
  type    = string
  default = "Ubuntu 20.04 Base AMI"
}

variable "aws_tag_description" {
  type    = string
  default = "Base Ubuntu 20.04 image with Python3, Ansible, and AWS CLI installed"
}

variable "aws_ssh_username" {
  type    = string
  default = "ubuntu"
}


source "amazon-ebs" "ami" {
  ami_name                    = "${var.ami_name}_${formatdate("YYYYMMDD-hhmmss",timestamp())}"
  ami_description             = var.aws_tag_description
  ami_users                   = split(",", var.aws_ami_accounts)
  ami_virtualization_type     = "hvm"
  source_ami                  = var.aws_source_ami
  ssh_pty                     = true
  ssh_timeout                 = "15m"
  ssh_username                = var.aws_ssh_username
  communicator                = "ssh"
  instance_type               = "t2.micro"
  secret_key                  = var.aws_secret_key
  access_key                  = var.aws_access_key
  region                      = var.aws_region
  vpc_id                      = var.aws_vpc_id
  subnet_id                   = var.aws_subnet_id
  security_group_id           = var.aws_security_group_id
  associate_public_ip_address = false

  tags = {
    Name         = var.aws_tag_name
    Provisioner  = "Packer"
  }
  run_tags = {
    Name         = var.aws_tag_name
    Provisioner  = "Packer"
  }
  run_volume_tags = {
    Name         = var.aws_tag_name
    Provisioner  = "Packer"
  }
}

build {
  sources = [ "source.amazon-ebs.ami" ]

  provisioner "ansible" {
    ansible_env_vars = [
      "ANSIBLE_STDOUT_CALLBACK=debug",
      "ANSIBLE_LOAD_CALLBACK_PLUGINS=1",
      "ANSIBLE_CONFIG=./cm/ansible/ansible.cfg",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s'",
      "ANSIBLE_NOCOLOR=True"
    ]
    extra_arguments  = [ "-v", "-e ansible_python_interpreter=/usr/bin/python3" ]
    playbook_file    = "./cm/ansible/playbook.yml"
    user             = "ubuntu"
    use_proxy        = false
  }

}
