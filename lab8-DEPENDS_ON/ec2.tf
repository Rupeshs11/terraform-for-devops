# key pair login 

resource "aws_key_pair" "knox-key" {
  key_name = "tera-key.pem"
  public_key = file("tera-key.pem.pub")

}

# vpc and SG

resource "aws_default_vpc" "default" {

}
resource "aws_security_group" "my-sg" {
    name = "terraform-sg"
    description = "this is just a demo"
    vpc_id = aws_default_vpc.default.id # interpolation
  
  # inbound rules
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # outbound rules
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# ec2-instance

resource "aws_instance" "my-ec2" {
  depends_on = [ aws_security_group.my-sg ]
  key_name =  aws_key_pair.knox-key.key_name
  security_groups = [aws_security_group.my-sg.name]
  instance_type = each.value
  ami = var.ec2_ami_id # amazon-linux
  user_data = file("install_nginx.sh")
  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = "gp3"
  }
  tags= {
    Name =each.key
  }
}