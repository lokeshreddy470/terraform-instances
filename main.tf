resource "aws_instance" "general-i" {
  instance_type ="${var.general_instance_type}"
  count = "${var.general_instance_count}"
  ami = "${var.ami}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.general-sg.id}"]
  
}

resource "aws_security_group" "general-sg" {
  description = "Security group for general instances"
  name = "general-sg"
  vpc_id = "${var.vpc_id}"
  
  egress { 
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress { 
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "general" {
  vpc = true
} 

resource "aws_eip_association" "general" {
  instance_id = "${aws_instance.general-i.id}"
  allocation_id = "${aws_eip.general.id}"
}
