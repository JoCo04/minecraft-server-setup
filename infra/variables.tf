variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "ami" {
  description = "AMI ID (Amazon Linux 2023)"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair (no extension)"
  type        = string
}

variable "public_key_path" {
  description = "Path to your public key file (e.g. ~/.ssh/minecraft_key.pub)"
  type        = string
}

