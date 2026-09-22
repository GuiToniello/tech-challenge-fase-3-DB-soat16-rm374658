variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "techchallenge-oficina"
}

variable "environment" {
  type    = string
  default = "study"
}

variable "rds_db_name" {
  type    = string
  default = "oficina"
}

variable "rds_username" {
  type    = string
  default = "sa"
}

variable "rds_password" {
  type      = string
  sensitive = true
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}
