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
  default     = "my-test-bucket"
}

variable "instance-type" {
  description = "The instance type of the EC2 instance that hosts the registry"
  type        = string
  default     = "t2.micro"
}
