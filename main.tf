terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "yarn_resourcemanager_failure_impacting_spark_jobs" {
  source    = "./modules/yarn_resourcemanager_failure_impacting_spark_jobs"

  providers = {
    shoreline = shoreline
  }
}