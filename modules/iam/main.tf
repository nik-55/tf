locals {
  s3_full_access_policy = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Name = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "s3_full_access_role_attachment" {
  role       = aws_iam_role.ec2_s3_role.id
  policy_arn = local.s3_full_access_policy
}
