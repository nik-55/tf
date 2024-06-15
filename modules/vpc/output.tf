output "vpc_details" {
  value = {
    # key_pair_name     = aws_key_pair.remote_dev_key_pair.id
    security_group_id = aws_security_group.remote_dev_sg.id
    subnet_id_public  = aws_subnet.remote_dev_subnet_public.id
    # subnet_id_private = aws_subnet.remote_dev_subnet_private.id
    vpc_id = aws_vpc.remote_dev_vpc.id
  }
}