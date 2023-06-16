terraform {
  source = "git@github.com:marianosolberg/ejercicio.git//account-dns?ref=v0.0.2"
  #source = "/home/mariano/test/ejercicio/account-dns"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_id   = local.account_vars.locals.account_id
  region       = local.region_vars.locals.region
  namespace    = local.account_vars.locals.namespace
  stage        = local.account_vars.locals.stage
}

include {
  path = find_in_parent_folders()
}

inputs = {
  domain_name = "${local.stage}.ejercicio.cloud"
  account_id = local.account_id
  stage      = local.stage
}
