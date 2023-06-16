terraform {
  source = "git@github.com:marianosolberg/ejercicio.git//backend-services?ref=v0.0.2"
 #source = "/home/mariano/test/ejercicio/backend-services"
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

inputs = {
  name = "backend"
  vpc_cidr_block = "10.115.0.0/16"
  dns_parent_zone_name = "${local.stage}.ejercicio.cloud"
  az_exclude_names = ["${local.region}e","${local.region}f"]
}
