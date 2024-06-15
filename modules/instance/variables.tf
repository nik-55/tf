variable "user_data" {
  type = string
}

variable "vpc_details" {
  type = object({
    key_pair_name     = string
    security_group_id = string
    subnet_id_private = string
    subnet_id_public  = string
  })
}

variable "private" {
  type    = bool
  default = false
}

variable "role" {
  type     = string
  nullable = true
  default  = null
}

variable "profile_name" {
  type     = string
  nullable = true
  default  = null
}
