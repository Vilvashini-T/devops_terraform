variable "instance_type" {
  description = "EC2 instance type to use for the application server"
  default     = "t3.small"
}

variable "app_name" {
  description = "Name tag applied to all AWS resources for easy identification"
  default     = "student-notes-server"
}