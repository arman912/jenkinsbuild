variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "AMIS" {
  type = map
  default = {
    eu-west-1 = "ami-028188d9b49b32a80"
    eu-west-2 = "ami-04de2b60dd25fbb2e"
    eu-west-3 = "ami-0652eb0db9b20aeaf"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"

}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

