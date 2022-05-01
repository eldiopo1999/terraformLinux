#resource "aws_key_pair" "mykey" {
#key_name = "test"
#public_key = "${file("${var.key_path}")}"
#}

resource "aws_instance" "example" {
  ami                         = lookup(var.AMIS, var.AWS_REGION)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  network_interface {
    network_interface_id = aws_network_interface.networ_interface.id
    device_index         = 0
  }
  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  #key_name = "${aws_key_pair.mykey.key_name}"
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script/.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install mysql-client-5.7 -y",
      "sudo chmod +x /tmp/db-init.sh",
      "sudo /tmp/db-init.sh"
    ]
  }

  tags = {
    Name = "EC2 Instance"
  }
  #connection {
  #   user = "${var.INSTANCE_USERNAME}"
  #  private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  #}
}

resource "aws_ebs_volume" "EBS_Volume" {
  availability_zone = "us-east-1a"
  #volume_type = "gp2"
  size = 10
  tags = {
    Name = "EBS_Volume"
  }
}

resource "aws_volume_attachment" "EBS_Volume_Attachement" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.EBS_Volume.id
  instance_id = aws_instance.example.id
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "SR_Private"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "SR_Public"
  }
}

resource "aws_network_interface" "networ_interface" {
  subnet_id   = aws_subnet.private_subnet.id
  private_ips = ["192.168.1.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet_Gateway"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Route_Public"
  }
}

