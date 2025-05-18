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
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}

resource "aws_security_group" "registry" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # to internet for setup
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "cloud_init" "name" {

}

resource "aws_instance" "registry" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance-type
  iam_instance_profile        = aws_iam_instance_profile.registry.name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.registry.id]
  user_data_replace_on_change = true
  user_data                   = ""
}

output "registry-public-ip-address" {
  description = "The public IP address that you can access the Docker registry with"
  value       = aws_instance.registry.public_ip
}
