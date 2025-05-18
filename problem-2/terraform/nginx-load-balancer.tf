#resource "aws_instance" "nginx-load-balancer" {
#  ami                         = data.aws_ami.ubuntu.id
#  instance_type               = var.instance-type
#  subnet_id                   = aws_subnet.public.id
#  vpc_security_group_ids      = [aws_security_group.nginx.id]
#  user_data_replace_on_change = true
#  user_data = templatefile("${path.module}/templates/nginx-load-balancer.sh", {
#    docker_registry = "${aws_instance.registry.private_ip}:5000"
#  })
#
#  # NOTE: for testing and debugging only
#  #key_name = aws_key_pair.debugging.id
#
#  tags = {
#    Name = "nginx-load-balancer"
#  }
#}
#
#output "nginx-load-balancer-public-ip-address" {
#  description = "The public IP address that you can access the NGINX load balancer with"
#  value       = aws_instance.nginx-load-balancer.public_ip
#}
