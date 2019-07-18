resource "aws_instance" "general-i" {
  instance_type ="${var.general_instance_type}"
  count = "${var.general_instance_count}"
  ami = "${var.general_ami}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.general-sg.id}"]
  subnet_id = "${var.subnet}"
  
  root_block_device {
    delete_on_termination = false
    volume_size = "${var.general_volume_size}"
  }
}

resource "aws_security_group" "general-sg" {
  description = "Security group for general instances"
  name = "general-sg"
  vpc_id = "${var.vpc_id}"
  
  engress { 
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
  lifecycle {
    prevent_destroy = true
  }
} 

resource "aws_eip_association" "general" {
  instance_id = "${aws_instance.general-i.id}"
  allocation_id = "${aws_eip.general-i.id}"
}

resource "aws_route53_record" "general-route" {
  count = "${var.general_instance_count}"
  zone_id = "${var.zone.id}"
  name = "general_route"
  type = "A"
  records = ["${element(aws_instance.general.*.private_ip, count.index)}"]
}

