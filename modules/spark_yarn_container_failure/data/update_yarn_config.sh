

#!/bin/bash



# Set the variables

MEMORY=${MEMORY_ALLOCATED_TO_THE_CONTAINER_IN_GB}

CPU=${NUMBER_OF_CPUS_ALLOCATED_TO_THE_CONTAINER}



# Update the YARN configuration

yarn config -set yarn.nodemanager.resource.memory-mb $((MEMORY*1024))

yarn config -set yarn.nodemanager.resource.cpu-vcores $CPU



# Restart the YARN NodeManager service

systemctl restart hadoop-yarn-nodemanager