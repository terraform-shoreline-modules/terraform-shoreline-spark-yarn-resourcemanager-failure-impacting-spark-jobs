

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