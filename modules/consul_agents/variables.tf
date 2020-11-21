terraform {
  required_version = ">= 0.12.0"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "num_of_agents" {
  type        = number
  default     = 2
}

variable "ec2_agents_intance_type" {
  type        = string
  default     = "t2.micro"
}

variable "intances_private_key_name" {
  type        = string
}

variable "owner_name" {
  type        = string
}

variable "project_name" {
  description = "the project name"
  type        = string
}

variable "public_sub_id" {
  type = list(string)
}

variable "sg" {
  type = string
}