terraform {
  source = "git@github.com:marianosolberg/ejercicio.git//aurora-postgres?ref=v0.0.2"
  #source = "/home/mariano/test/ejercicio/aurora-postgres"
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

dependency "wordpress" {
  config_path = "../wordpress"
}



inputs = {
  vpc_id = dependency.backend.outputs.vpc_id
  vpc_private_subnet_ids = dependency.backend.outputs.vpc_private_subnet_ids

  name                 = "test"
  attributes           = ["database", "serverless"]
  ssm_prefix           = "test-${local.stage}-backend-database-serverless"
  db_name              = "ejercicio"
  admin_username       = "test"
  enabled              = true
  engine               = "aurora-postgresql"
  cluster_family       = "aurora-postgresql14"
  engine_mode          = "provisioned"
  engine_version       = "14.3"
  cluster_size         = 1
  enable_http_endpoint = true
  deletion_protection  = true
  auto_minor_version_upgrade = true
  retention_period     = 14
  
  security_groups = [
    dependency.wordpress.outputs.security_group_id
  ]

  serverlessv2_scaling_configuration = {
    max_capacity = 1.0
    min_capacity = 0.5
  }
  
}
