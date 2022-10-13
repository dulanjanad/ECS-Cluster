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

variable "app_containerPort" {
  type        = number
  description = "Container Port to expose in application"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "engine" {
  type        = string
  description = "Database Engine"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
}

variable "family" {
  type        = string
  description = "Database family"
}

variable "major_engine_version" {
  type        = string
  description = "Major engine version"
}

variable "instance_class" {
  type        = string
  description = "Instance Class"
}

variable "port" {
  type        = number
  description = "Database port"
}

variable "db_username" {
  type        = string
  description = "Database username"
}