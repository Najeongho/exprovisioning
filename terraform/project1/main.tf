#####################################################################
##
##      Created 1/21/19 by admin. for project1
##
#####################################################################

## REFERENCE {"aws_network":{"type": "aws_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
  version = "~> 1.8"
}


data "aws_subnet" "subnet" {
  id = "${var.subnet_subnet_id}"
}

data "aws_security_group" "group_name" {
  name = "${var.group_name}"
  vpc_id = "${var.group_name_vpc_id}"
}

resource "aws_instance" "aws_instance" {
  ami = "${var.aws_instance_ami}"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "${var.aws_instance_aws_instance_type}"
  availability_zone = "${var.availability_zone}"
  subnet_id  = "${data.aws_subnet.subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.group_name.id}"]
  connection {
    type = "ssh"
    user = "${var.aws_instance_connection_user}"
    private_key = "${var.aws_instance_connection_private_key}"
    host = "${var.aws_instance_connection_host}"
  }
  provisioner "local-exec" {
      command = "apt install -y python python-pip"
  }
  tags {
    Name = "${var.aws_instance_name}"
  }
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

resource "aws_key_pair" "auth" {
    key_name = "${var.aws_key_pair_name}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "aws_ebs_volume" "volume_name" {
    availability_zone = "${var.availability_zone}"
    size              = "${var.volume_name_volume_size}"
}

resource "aws_volume_attachment" "aws_instance_volume_name_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.volume_name.id}"
  instance_id = "${aws_instance.aws_instance.id}"
}

resource "aws_elb" "load_balancer" {
  name               = "load_balancer-elb"
  availability_zones = ["${var.load_balancer_availability_zones}"]
  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags {
    Name = "load_balancer-elb"
  }
}

resource "aws_elb_attachment" "aws_instance_load_balancer_balancer_attachment" {
  elb      = "${aws_elb.load_balancer.id}"
  instance = "${aws_instance.aws_instance.id}"
}

resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_eip_association" "aws_instance_elastic_ip_eip_association" {

  instance_id   = "${aws_instance.aws_instance.id}"
  allocation_id = "${aws_eip.elastic_ip.id}"
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "3.5.0"
  ip_address_type  =  "ipv4"
  log_location_prefix  =  ""
  enable_deletion_protection  =  false
  target_groups_count  =  0
  tags  =  {}
  logging_enabled  =  true
  load_balancer_delete_timeout  =  "10m"
  load_balancer_name  =  ""
  security_groups  =  ""
  subnets  =  ""
  extra_ssl_certs  =  []
  listener_ssl_policy_default  =  "ELBSecurityPolicy-2016-08"
  http_tcp_listeners  =  []
  enable_http2  =  true
  vpc_id  =  ""
  target_groups_defaults  =  {}
  enable_cross_zone_load_balancing  =  false
  load_balancer_create_timeout  =  "10m"
  http_tcp_listeners_count  =  0
  log_bucket_name  =  ""
  load_balancer_update_timeout  =  "10m"
  load_balancer_is_internal  =  false
  idle_timeout  =  60
  https_listeners_count  =  0
  https_listeners  =  []
  extra_ssl_certs_count  =  0
  target_groups  =  []
}

module "vpn_gateway" {
  source = "terraform-aws-modules/vpn-gateway/aws"
  version = "1.6.1"
  tunnel2_inside_cidr  =  ""
  vpc_subnet_route_table_count  =  0
  tunnel1_preshared_key  =  ""
  tunnel1_inside_cidr  =  ""
  vpn_connection_static_routes_destinations  =  []
  vpc_id  =  ""
  customer_gateway_id  =  ""
  tunnel2_preshared_key  =  ""
  vpn_connection_static_routes_only  =  false
  create_vpn_connection  =  true
  create_vpn_gateway_attachment  =  true
  tags  =  {}
  vpc_subnet_route_table_ids  =  []
  vpn_gateway_id  =  ""
}