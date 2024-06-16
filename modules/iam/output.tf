# output "ec2_s3_role" {
#   value = aws_iam_role.ec2_s3_role.name
# }

output "ecs_ecr_role" {
  value = aws_iam_role.ecs_ecr_role.arn
}
