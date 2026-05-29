variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu AMI"
}