resource "aws_iam_instance_profile" "remote_dev_instance_profile" {
  name = var.profile_name
  role = var.role

  count = var.role == null ? 0 : 1
}

resource "aws_instance" "remote_dev_instance" {
  ami                         = data.aws_ami.remote_dev_ami.id
  instance_type               = "t2.micro"
  key_name                    = var.vpc_details.key_pair_name
  user_data                   = var.user_data
  associate_public_ip_address = !var.private

  vpc_security_group_ids = [var.vpc_details.security_group_id]
  subnet_id              = var.private ? var.vpc_details.subnet_id_private : var.vpc_details.subnet_id_public

  iam_instance_profile = var.role == null ? null : aws_iam_instance_profile.remote_dev_instance_profile[0].name

  tags = {
    Name = "dev"
  }
}
