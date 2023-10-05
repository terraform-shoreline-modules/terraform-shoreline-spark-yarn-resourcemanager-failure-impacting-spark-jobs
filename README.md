
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# YARN ResourceManager Failure Impacting Spark Jobs.
---

This incident type involves the failure of the YARN ResourceManager, which can impact the performance of Spark jobs. The ResourceManager is responsible for managing resources in a Hadoop cluster, and when it fails, it can prevent Spark jobs from running properly. This incident requires investigation to determine the root cause of the failure, and recovery steps to restore the ResourceManager and prevent similar failures from occurring in the future.

### Parameters
```shell
export YARN_RESOURCEMANAGER="PLACEHOLDER"

export SPARK="PLACEHOLDER"

export PATH_TO_SPARK_LOGS="PLACEHOLDER"

export RESOURCE_MANAGER_HOST="PLACEHOLDER"

export NUMBER_OF_NODES_TO_INCREASE_TO="PLACEHOLDER"
```

## Debug

### Check the status of the YARN ResourceManager service
```shell
systemctl status ${YARN_RESOURCEMANAGER}
```

### Check the logs of the YARN ResourceManager service
```shell
journalctl -u ${YARN_RESOURCEMANAGER}
```

### Check the resource usage of the YARN ResourceManager service
```shell
top -p $(pidof ${YARN_RESOURCEMANAGER})
```

### Check if the Spark jobs are running
```shell
ps aux | grep ${SPARK}
```

### Check the logs of the Spark jobs
```shell
cat ${PATH_TO_SPARK_LOGS}
```

### Check the resource usage of the Spark jobs
```shell
top -p $(pidof ${SPARK})
```

### The YARN ResourceManager may have been overloaded with requests, causing it to fail.
```shell


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


```

## Repair

### Increase the number of YARN ResourceManager nodes in the cluster to provide redundancy and reduce the impact of a single node failure.
```shell


#!/bin/bash



# Set the number of nodes to increase to

new_nodes=${NUMBER_OF_NODES_TO_INCREASE_TO}



# Get the current number of ResourceManager nodes

current_nodes=$(yarn node -list | grep "ResourceManager" | wc -l)



# Check if the current number of nodes is less than the desired number of nodes

if [ $current_nodes -lt $new_nodes ]; then

  # Calculate the number of nodes to add

  nodes_to_add=$((new_nodes - current_nodes))

  

  # For each node to add, create a new ResourceManager node

  for i in $(seq 1 $nodes_to_add); do

    yarn rmadmin -refreshNodes

  done

  

  # Verify that the desired number of nodes has been added

  current_nodes=$(yarn node -list | grep "ResourceManager" | wc -l)

  

  if [ $current_nodes -lt $new_nodes ]; then

    echo "Error: Failed to add all required ResourceManager nodes."

    exit 1

  else

    echo "Successfully added $nodes_to_add ResourceManager nodes."

    exit 0

  fi

else

  echo "The current number of ResourceManager nodes is already equal to or greater than the desired number of nodes."

  exit 0

fi


```