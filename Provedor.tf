provider "aws" {
  region = var.aws_region
  access_key = "AKI..."
  secret_key = "7TR..."
}
resource "aws_key_pair" "ssh" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  provisioner "remote-exec" {
   inline = [
     "sudo apt-get update -y",
     "sudo apt-get install -y httpd",
     "sudo systemctl start httpd"
   ]
}
 provisioner "file" {
  source      = "home/virtualização/aws-vm/index.html"
  destination = "etc/virt"
}

  key_name      = aws_key_pair.ssh.key_name
  tags = {
    Name = "Terraform-Web-Instance"
  }
}
 
terraform {
  backend "s3" {
    bucket = "bucket-da-atividade"
    key    = "terraform.tfstate"
    region = "us-east-2"
    access_key = "AKI..."
    secret_key = "7TR..."
  }
}
