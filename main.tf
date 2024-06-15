module "vpc" {
  source     = "./modules/vpc"
  public_key = file("rsa.pub")
}

# module "iam" {
#   source = "./modules/iam"
# }

# module "instance_1" {
#   source = "./modules/instance"
#   user_data = templatefile("userdata.tpl", {
#     name = "instance_1",
#     port = 5000
#   })
#   vpc_details = module.vpc.vpc_details
#   private     = true
# }

# module "instance_2" {
#   source = "./modules/instance"
#   user_data = templatefile("userdata.tpl", {
#     name = "instance_2",
#     port = 5000
#   })
#   vpc_details = module.vpc.vpc_details
#   private     = true
#   # role         = module.iam.ec2_s3_role
#   # profile_name = "remote_dev_instance_2_profile"
#   # depends_on   = [module.iam]
# }

# module "instance_3" {
#   source = "./modules/instance"
#   user_data = templatefile("userdata.tpl", {
#     name = "instance_3",
#     port = 5000
#   })
#   vpc_details = module.vpc.vpc_details
# }

module "lb" {
  source = "./modules/lb"
  vpc_details = {
    vpc_id          = module.vpc.vpc_details.vpc_id
    subnets         = [module.vpc.vpc_details.subnet_id_public, module.vpc.vpc_details.subnet_id_private]
    security_groups = [module.vpc.vpc_details.security_group_id]
  }
  target_type = "ip"
  # instances = {
  #   "instance_1" : {
  #     id   = module.instance_1.instance_id,
  #     port = 5000
  #   },
  #   "instance_2" : {
  #     id   = module.instance_2.instance_id,
  #     port = 5000
  #   },
  #   "instance_3" : {
  #     id   = module.instance_3.instance_id,
  #     port = 5000
  #   }
  # }

  # depends_on = [module.instance_1, module.instance_2]
}

# module "s3" {
#   source = "./modules/s3"
# }

module "ecs" {
  source           = "./modules/ecs"
  subnets          = [module.vpc.vpc_details.subnet_id_private]
  security_groups  = [module.vpc.vpc_details.security_group_id]
  depends_on       = [module.lb]
  target_group_arn = module.lb.target_group_arn
  target_group_arn_apache = module.lb.target_group_arn_apache
}
