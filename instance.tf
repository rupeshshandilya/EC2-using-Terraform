#Creating SSH-key
resource "aws_key_pair" "EnterKeyPairName" {
  key_name   = "EnterKeyPairName"
  #Place Rsa public key and private key same file 
  public_key = file("${path.module}/rsa.pub")
}


#creating security group
resource "aws_security_group" "YourSecurityGroupName" {
  name        = "YourSecurityGroupName"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = [22, 80] #Enter Ports for inbound rule
    iterator = port

    content {
      description      = "TLS from VPC"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    #Enter Ports
    from_port        = 0
    to_port          = 0 
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# EC2 instance
resource "aws_instance" "web" {
  ami                    = "Enter Image ID"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.YourKeyPairName.key_name
  vpc_security_group_ids = ["${aws_security_group.YourSecurityGroupName.id}"]
  tags = {
    Name = "webServer"
  }
}
