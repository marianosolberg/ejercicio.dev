terraform {
  source = "git::https://github.com/marianosolberg/ejercicio.git//wordpress?ref=v0.0.2"
  #source = "/home/mariano/test/ejercicio/wordpress"
}


locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_id   = local.account_vars.locals.account_id
  region       = local.region_vars.locals.region
  namespace    = local.account_vars.locals.namespace
  stage        = local.account_vars.locals.stage
  logs_retention_in_days = local.account_vars.locals.logs_retention_in_days
}

include {
  path = find_in_parent_folders()
}

dependency "backend" {
  config_path = "../backend"
}



inputs = {
  vpc_id                              = dependency.backend.outputs.vpc_id
  public_subnet_id                    = dependency.backend.outputs.vpc_public_subnet_ids
  parent_zone_id                      = dependency.backend.outputs.dns_zone_id
  name                                = "wordpress"
  region                              = local.region
  account_id                          = local.account_id
  re_run_playbook                     = formatdate("YYYYMMDDHHMMss", timestamp())
  ami                                 = "ami-0557a15b87f6559cf"
  ssm_association_schedule_expression = "cron(0 2 ? * * *)"
  instance_type                       = "t2.micro"
                                        
 ids_sg_alb                              = ["sg-0c940e00313580507"]                                     
  white_list_ips                      = [
                                          "0.0.0.0/0", # all ip
                                          "10.115.0.0/16" #cdir vpc
                                       ]

                                
}
