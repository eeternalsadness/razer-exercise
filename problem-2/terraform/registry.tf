###################################
# S3
###################################

resource "aws_s3_bucket" "registry" {
  bucket        = var.bucket-name
  force_destroy = true
}

###################################
# EC2
###################################

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "registry" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "registry-ingress-local" {
  type              = "ingress"
  security_group_id = aws_security_group.registry.id

  from_port   = 5000
  to_port     = 5000
  protocol    = "tcp"
  cidr_blocks = [var.my-public-ip]
}

resource "aws_security_group_rule" "registry-ingress-ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.registry.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.my-public-ip]
}

resource "aws_security_group_rule" "registry-egress-http" {
  type              = "egress"
  security_group_id = aws_security_group.registry.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "registry-egress-https" {
  type              = "egress"
  security_group_id = aws_security_group.registry.id

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# NOTE: for testing and debugging only
#resource "aws_key_pair" "debugging" {
#  key_name   = "registry-ssh"
#  public_key = var.ssh-public-key
#}

resource "aws_instance" "registry" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance-type
  iam_instance_profile        = aws_iam_instance_profile.registry.name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.registry.id]
  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/templates/run-docker-registry.sh", {
    region      = var.region
    bucket_name = aws_s3_bucket.registry.id
  })

  # NOTE: for testing and debugging only
  #key_name                    = aws_key_pair.debugging.id

  tags = {
    Name = "registry"
  }
}

output "registry-public-ip-address" {
  description = "The public IP address that you can access the Docker registry with"
  value       = aws_instance.registry.public_ip
}
