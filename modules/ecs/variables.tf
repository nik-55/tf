variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "target_group_arn_apache" {
  type = string
}

variable "ecs_ecr_role" {
  type = string
}