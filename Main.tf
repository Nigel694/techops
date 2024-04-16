# Provider configuration
provider "aws" {
  region = "ap-southeast-2"
}

# Variables
variable "instance_name" {
  description = "Project"
  type        = string
  default     = "my-instance"
}

variable "instance_type" {
  description = "Ubuntu"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID of the instance"
  type        = string
  default     = "ami-09c8d5d747253fb7a"
}

# Resource: EC2 Instance
resource "aws_instance" "vm_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }

  user_data = file("${path.module}/user_data.sh")
}

# Output: Instance details
output "instance_details" {
  value = aws_instance.vm_instance
}