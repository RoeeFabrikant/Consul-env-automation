
# VPC VARIABLES

terraform {
  required_version = ">= 0.12.0"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  description = "the project name"
  type        = string
}

variable "vpc_cidr" {
  description = "your vpc CIDR"
  type        = string
}

variable "public_subnet_cidr" {
  type        = list(string)
  default     = ["10.10.20.0/24", "10.10.21.0/24"]
}
