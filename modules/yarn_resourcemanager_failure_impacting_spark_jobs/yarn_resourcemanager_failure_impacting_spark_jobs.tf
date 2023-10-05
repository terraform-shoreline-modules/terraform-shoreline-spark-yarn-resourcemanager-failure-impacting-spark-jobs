resource "shoreline_notebook" "yarn_resourcemanager_failure_impacting_spark_jobs" {
  name       = "yarn_resourcemanager_failure_impacting_spark_jobs"
  data       = file("${path.module}/data/yarn_resourcemanager_failure_impacting_spark_jobs.json")
  depends_on = [shoreline_action.invoke_chk_yarn_resource_manager,shoreline_action.invoke_increase_nodes]
}

resource "shoreline_file" "chk_yarn_resource_manager" {
  name             = "chk_yarn_resource_manager"
  input_file       = "${path.module}/data/chk_yarn_resource_manager.sh"
  md5              = filemd5("${path.module}/data/chk_yarn_resource_manager.sh")
  description      = "The YARN ResourceManager may have been overloaded with requests, causing it to fail."
  destination_path = "/agent/scripts/chk_yarn_resource_manager.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_nodes" {
  name             = "increase_nodes"
  input_file       = "${path.module}/data/increase_nodes.sh"
  md5              = filemd5("${path.module}/data/increase_nodes.sh")
  description      = "Increase the number of YARN ResourceManager nodes in the cluster to provide redundancy and reduce the impact of a single node failure."
  destination_path = "/agent/scripts/increase_nodes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_chk_yarn_resource_manager" {
  name        = "invoke_chk_yarn_resource_manager"
  description = "The YARN ResourceManager may have been overloaded with requests, causing it to fail."
  command     = "`chmod +x /agent/scripts/chk_yarn_resource_manager.sh && /agent/scripts/chk_yarn_resource_manager.sh`"
  params      = ["RESOURCE_MANAGER_HOST"]
  file_deps   = ["chk_yarn_resource_manager"]
  enabled     = true
  depends_on  = [shoreline_file.chk_yarn_resource_manager]
}

resource "shoreline_action" "invoke_increase_nodes" {
  name        = "invoke_increase_nodes"
  description = "Increase the number of YARN ResourceManager nodes in the cluster to provide redundancy and reduce the impact of a single node failure."
  command     = "`chmod +x /agent/scripts/increase_nodes.sh && /agent/scripts/increase_nodes.sh`"
  params      = ["NUMBER_OF_NODES_TO_INCREASE_TO"]
  file_deps   = ["increase_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.increase_nodes]
}

