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