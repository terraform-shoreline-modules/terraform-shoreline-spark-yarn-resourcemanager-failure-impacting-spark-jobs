

#!/bin/bash



# Check for overloaded YARN ResourceManager



# Set the threshold for the number of running applications

THRESHOLD=500



# Get the number of running applications from the YARN ResourceManager

NUM_APPS=$(curl -s -X GET http://${RESOURCE_MANAGER_HOST}:8088/ws/v1/cluster/apps | grep -oP '(?<="runningApplications":)[^,]*')



# Check if the number of running applications exceeds the threshold

if [ "$NUM_APPS" -gt "$THRESHOLD" ]; then

  echo "YARN ResourceManager may be overloaded with requests."

else

  echo "YARN ResourceManager is not overloaded with requests."

fi