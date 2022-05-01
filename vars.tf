variable "AWS_ACCESS_KEY" {
  default = "AKIAQRIZWSYOXGKILPDP"
}

variable "AWS_SECRET_KEY" {
  default = "MgqIlNTKJlf0VEhEVCGF1xmBdyR/q7epQQACswZN"
}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0f9fc25dd2506cf6d"
    #eu-west-2 = "ami-0244a5621d426859b"
    #eu-west-3 = "ami-096cb92bb3580c750"
  }
}

#variable "PATH_TO_PRIVATE_KEY" {
#   default = "mykey"
#}

#variable "key_path" {
#    default = "~/.ssh/id_rsa.pub"
#}

variable "INSTANCE_USERNAME" {
  type    = string
  default = "ubuntu"
}
