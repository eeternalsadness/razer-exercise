variable "region" {
  description = "The AWS region to provision resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc-cidr-block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet-cidr-block" {
  description = "The CIDR block for the public subnet where the registry is hosted"
  type        = string
  default     = "10.0.0.0/24"
}

variable "bucket-name" {
  description = "The name of the S3 bucket used as the storage backend for the registry"
  type        = string
}

variable "instance-type" {
  description = "The instance type of the EC2 instance that hosts the registry"
  type        = string
  default     = "t2.micro"
}

variable "my-public-ip" {
  description = "Your public IP address to access the Docker registry. This is a quick workaround for testing only"
  type        = string
}

# NOTE: for testing and debugging only
#variable "ssh-public-key" {
#  description = "The content of the public SSH key to SSH to the registry for debugging"
#  type        = string
#}
