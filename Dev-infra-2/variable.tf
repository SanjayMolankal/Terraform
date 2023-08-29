variable "instance_type" {
  type = string
 validation {
  condition  = can(regex("^t2.",var.instance_type))
  error_message = "The instance must be a t2 ec2 instance."
 }
}
variable "ami" {
  type = string
}
variable "public_key" {
  type = string
}
