
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Spark YARN Container Failure
---

Spark YARN container failure is an incident type that occurs when a container running on the YARN (Yet Another Resource Negotiator) resource manager in a Spark cluster fails to complete its assigned task. This can be caused by a variety of factors such as resource constraints, hardware failures, or software bugs. When a container fails, it can cause delays or failures in the overall Spark job, leading to reduced performance or data loss.

### Parameters
```shell
export YARN_RESOURCEMANAGER_SERVICE="PLACEHOLDER"

export YARN_NODEMANAGER_SERVICE="PLACEHOLDER"

export APPLICATION_ID="PLACEHOLDER"

export MEMORY_ALLOCATED_TO_THE_CONTAINER_IN_GB="PLACEHOLDER"

export NUMBER_OF_CPUS_ALLOCATED_TO_THE_CONTAINER="PLACEHOLDER"

export CPU_THRESHOLD_VALUE="PLACEHOLDER"

export MEMORY_THRESHOLD_VALUE="PLACEHOLDER"
```

## Debug

### 1. Check if YARN ResourceManager is running
```shell
sudo systemctl status ${YARN_RESOURCEMANAGER_SERVICE}
```

### 2. Check if YARN NodeManager is running on the failed node
```shell
sudo systemctl status ${YARN_NODEMANAGER_SERVICE}
```

### 3. Check if the Spark application is running on the YARN cluster
```shell
yarn application -list
```

### 4. Check if the Spark application is using the correct YARN queue
```shell
yarn application -status ${APPLICATION_ID} | grep queue
```

### 5. Check if the Spark application logs show any errors
```shell
yarn logs -applicationId ${APPLICATION_ID} | grep ERROR
```

### 6. Check if there are any system-level errors on the failed node
```shell
sudo journalctl -u ${YARN_NODEMANAGER_SERVICE} -n 50 | grep ERROR
```

### Resource constraints: If the Spark YARN container is running on limited resources such as memory or CPU, it may fail due to insufficient resources.
```shell
bash

#!/bin/bash



# Get the current CPU and memory usage

cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2}')

memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100}')



# Set the threshold for CPU and memory usage

cpu_threshold=${CPU_THRESHOLD_VALUE} # e.g. 80

memory_threshold=${MEMORY_THRESHOLD_VALUE} # e.g. 80



# Check if CPU or memory usage exceeds the threshold

if (( $(echo "$cpu_usage > $cpu_threshold" | bc -l) )); then

  echo "CPU usage is too high (${cpu_usage}%)."

fi



if (( $(echo "$memory_usage > $memory_threshold" | bc -l) )); then

  echo "Memory usage is too high (${memory_usage}%)."

fi


```

## Repair

### Increase the resources allocated to the Spark YARN container, such as memory or CPU resources. This may prevent future failures caused by resource constraints.
```shell


#!/bin/bash



# Set the variables

MEMORY=${MEMORY_ALLOCATED_TO_THE_CONTAINER_IN_GB}

CPU=${NUMBER_OF_CPUS_ALLOCATED_TO_THE_CONTAINER}



# Update the YARN configuration

yarn config -set yarn.nodemanager.resource.memory-mb $((MEMORY*1024))

yarn config -set yarn.nodemanager.resource.cpu-vcores $CPU



# Restart the YARN NodeManager service

systemctl restart hadoop-yarn-nodemanager


```