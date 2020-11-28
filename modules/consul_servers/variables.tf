# DB VARIABLES

variable "project_name" {
  description = "the project name"
  type        = string
}

variable "num_of_servers" {
  type        = number
  default     = 3
}

variable "servers_intance_type" {
  type        = string
  default     = "t2.micro"
}

variable "intances_private_key_name" {
  type        = string
}

variable "owner_name" {
  type        = string
}

variable "public_sub_id" {
  type = list(string)
}

variable "sg" {
  type = string
}

variable "iam" {
  type = string
}