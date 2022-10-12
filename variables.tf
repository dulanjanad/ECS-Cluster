variable "aws_region" {
  type        = string
  description = "AWS Region to deploy resources"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "cidr" {
  type        = string
  description = "CIDR for VPC Creation"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
}