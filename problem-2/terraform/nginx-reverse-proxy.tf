#resource "aws_security_group" "nginx" {
#  vpc_id = aws_vpc.vpc.id
#}
#
#resource "aws_security_group_rule" "nginx-ingress-http" {
#  type              = "ingress"
#  security_group_id = aws_security_group.nginx.id
#
#  from_port   = 80
#  to_port     = 80
#  protocol    = "tcp"
#  cidr_blocks = [var.my-public-ip]
#}
#
#resource "aws_security_group_rule" "nginx-ingress-ssh" {
#  type              = "ingress"
#  security_group_id = aws_security_group.nginx.id
#
#  from_port   = 22
#  to_port     = 22
#  protocol    = "tcp"
#  cidr_blocks = [var.my-public-ip]
#}
#
#resource "aws_security_group_rule" "nginx-egress-registry" {
#  type              = "egress"
#  security_group_id = aws_security_group.nginx.id
#
#  from_port                = 5000
#  to_port                  = 5000
#  protocol                 = "tcp"
#  source_security_group_id = aws_security_group.registry.id
#}
#
#resource "aws_security_group_rule" "nginx-egress-http" {
#  type              = "egress"
#  security_group_id = aws_security_group.nginx.id
#
#  from_port   = 80
#  to_port     = 80
#  protocol    = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#}
#
#resource "aws_security_group_rule" "nginx-egress-https" {
#  type              = "egress"
#  security_group_id = aws_security_group.nginx.id
#
#  from_port   = 443
#  to_port     = 443
#  protocol    = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#}
#
#resource "aws_security_group_rule" "registry-ingress-nginx" {
#  type              = "ingress"
#  security_group_id = aws_security_group.registry.id
#
#  from_port                = 5000
#  to_port                  = 5000
#  protocol                 = "tcp"
#  source_security_group_id = aws_security_group.nginx.id
#}
#
#resource "aws_instance" "nginx-reverse-proxy" {
#  ami                         = data.aws_ami.ubuntu.id
#  instance_type               = var.instance-type
#  subnet_id                   = aws_subnet.public.id
#  vpc_security_group_ids      = [aws_security_group.nginx.id]
#  user_data_replace_on_change = true
#  user_data = templatefile("${path.module}/templates/nginx-reverse-proxy.sh", {
#    docker_registry = "${aws_instance.registry.private_ip}:5000"
#  })
#
#  # NOTE: for testing and debugging only
#  #key_name = aws_key_pair.debugging.id
#
#  tags = {
#    Name = "nginx-reverse-proxy"
#  }
#}
#
#output "nginx-reverse-proxy-public-ip-address" {
#  description = "The public IP address that you can access the NGINX reverse proxy with"
#  value       = aws_instance.nginx-reverse-proxy.public_ip
#}
