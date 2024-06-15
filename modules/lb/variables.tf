variable "vpc_details" {
  type = object({
    vpc_id          = string
    subnets         = list(string)
    security_groups = list(string)
  })
}

variable "instances" {
  type = map(object({
    id   = string
    port = number
  }))
  default = {}
}

variable "target_type" {
  type    = string
  default = "instance"
}