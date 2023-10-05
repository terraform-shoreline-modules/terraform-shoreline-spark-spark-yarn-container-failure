resource "shoreline_notebook" "spark_yarn_container_failure" {
  name       = "spark_yarn_container_failure"
  data       = file("${path.module}/data/spark_yarn_container_failure.json")
  depends_on = [shoreline_action.invoke_get_cpu_mem_usage_thresholds,shoreline_action.invoke_update_yarn_config]
}

resource "shoreline_file" "get_cpu_mem_usage_thresholds" {
  name             = "get_cpu_mem_usage_thresholds"
  input_file       = "${path.module}/data/get_cpu_mem_usage_thresholds.sh"
  md5              = filemd5("${path.module}/data/get_cpu_mem_usage_thresholds.sh")
  description      = "Resource constraints: If the Spark YARN container is running on limited resources such as memory or CPU, it may fail due to insufficient resources."
  destination_path = "/agent/scripts/get_cpu_mem_usage_thresholds.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_yarn_config" {
  name             = "update_yarn_config"
  input_file       = "${path.module}/data/update_yarn_config.sh"
  md5              = filemd5("${path.module}/data/update_yarn_config.sh")
  description      = "Increase the resources allocated to the Spark YARN container, such as memory or CPU resources. This may prevent future failures caused by resource constraints."
  destination_path = "/agent/scripts/update_yarn_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_cpu_mem_usage_thresholds" {
  name        = "invoke_get_cpu_mem_usage_thresholds"
  description = "Resource constraints: If the Spark YARN container is running on limited resources such as memory or CPU, it may fail due to insufficient resources."
  command     = "`chmod +x /agent/scripts/get_cpu_mem_usage_thresholds.sh && /agent/scripts/get_cpu_mem_usage_thresholds.sh`"
  params      = ["CPU_THRESHOLD_VALUE","MEMORY_THRESHOLD_VALUE"]
  file_deps   = ["get_cpu_mem_usage_thresholds"]
  enabled     = true
  depends_on  = [shoreline_file.get_cpu_mem_usage_thresholds]
}

resource "shoreline_action" "invoke_update_yarn_config" {
  name        = "invoke_update_yarn_config"
  description = "Increase the resources allocated to the Spark YARN container, such as memory or CPU resources. This may prevent future failures caused by resource constraints."
  command     = "`chmod +x /agent/scripts/update_yarn_config.sh && /agent/scripts/update_yarn_config.sh`"
  params      = ["NUMBER_OF_CPUS_ALLOCATED_TO_THE_CONTAINER","MEMORY_ALLOCATED_TO_THE_CONTAINER_IN_GB"]
  file_deps   = ["update_yarn_config"]
  enabled     = true
  depends_on  = [shoreline_file.update_yarn_config]
}

