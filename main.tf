provider "aws" {
  region = "sa-east-1"
}

locals {
  date = "${formatdate("hhmmss", timestamp())}"
}

resource "aws_instance" "web" {
  #ami                     = data.aws_ami.ubuntu.id
  for_each = var.lista_subnet
  ami = "ami-07983613af1a3ef44"
  instance_type           = "t2.micro"
  key_name = "ortaleb-chave-nova"
  associate_public_ip_address = true
  subnet_id               = aws_subnet.subnets[each.key].id # vincula a subnet direto e gera o IP automático
  vpc_security_group_ids  = [
    "${aws_security_group.allow_ssh_terraform.id}",
  ]
    root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "ortaleb-ec2-${each.value["az"]}-${local.date}"
    Owner = "ortaleb"
  }
}

resource "aws_instance" "web4" {
  #ami                     = data.aws_ami.ubuntu.id
  ami = "ami-07983613af1a3ef44"
  instance_type           = "t2.micro"
  key_name = "ortaleb-chave-nova"
  associate_public_ip_address = false
  subnet_id              = aws_subnet.tf-ortaleb-privnet-1c.id # vincula a subnet direto e gera o IP automático
  vpc_security_group_ids  = [
    "${aws_security_group.allow_ssh_terraform.id}",
  ]
    root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "ortaleb-ec2-priv-1c-${local.date}"
    Owner = "ortaleb"
  }
}








output "output_public" {
  value = [ 
    for key, item in aws_instance.web:
     "IP Privado: ${item.private_ip}\n IP Publico: ${item.public_ip}\n DNS Publico: ${item.public_dns}\n ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${item.public_ip}" 
  ]
  description = "Mostra o DNS da maquina criada"
}
output "private" {
  value = [
    "ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${aws_instance.web4.private_ip}"
  ]
  description = "Mostra o DNS da maquina criada"
}