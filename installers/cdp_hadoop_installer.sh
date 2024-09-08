#!/bin/bash

# Automated Hadoop cluster installation script using Cloudera

# Function to check if a command was successful
check_status() {
  if [ $? -ne 0 ]; then
    echo "Error during the execution of $1. Script is stopping."
    exit 1
  fi
}

cd ../ansible

echo "Starting the Hadoop cluster installation with Cloudera..."

# Step 1: Prepare the environment
echo "Running 1_prepare_env.yml..."
ansible-playbook ./1_prepare_env.yml
check_status "1_prepare_env.yml"

# Step 2: Install Cloudera dependencies
echo "Running 2_cloudera_dependencies.yml..."
ansible-playbook ./2_cloudera_dependencies.yml
check_status "2_cloudera_dependencies.yml"

# Step 3: Start Cloudera agents
echo "Running 3_cloudera_run_agents.yml..."
ansible-playbook ./3_cloudera_run_agents.yml
check_status "3_cloudera_run_agents.yml"

# Step 4: Install the database server
echo "Running 4_database_install_server.yml..."
ansible-playbook ./4_database_install_server.yml
check_status "4_database_install_server.yml"

# Step 5: Add the database connector to nodes
echo "Running 5_cloudera_nodes_add_connector.yml..."
ansible-playbook ./5_cloudera_nodes_add_connector.yml
check_status "5_cloudera_nodes_add_connector.yml"

# Step 6: Install Cloudera Manager server
echo "Running 6_cloudera_install_server.yml..."
ansible-playbook ./6_cloudera_install_server.yml
check_status "6_cloudera_install_server.yml"

# Step 7: Start Cloudera Manager server
echo "Running 7_cloudera_run_server.yml..."
ansible-playbook ./7_cloudera_run_server.yml
check_status "7_cloudera_run_server.yml"

# Step 8: Initial cluster creation (part 1)
echo "Running 8_cloudera_create_cluster_part1.yml..."
ansible-playbook ./8_cloudera_create_cluster_part1.yml
check_status "8_cloudera_create_cluster_part1.yml"

# Step 9: Restart Cloudera agents
echo "Running 9_cloudera_agents_restart.yml..."
ansible-playbook ./9_cloudera_agents_restart.yml
check_status "9_cloudera_agents_restart.yml"

# Step 10: Finalize cluster creation (part 2)
echo "Running 10_cloudera_create_cluster_part2.yml..."
ansible-playbook ./10_cloudera_create_cluster_part2.yml
check_status "10_cloudera_create_cluster_part2.yml"

# Step 11: Add Hadoop services (HDFS, YARN, Kafka, Hive, Hue, etc.)
echo "Running 11_cloudera_add_services.yml..."
ansible-playbook ./11_cloudera_add_services.yml
check_status "11_cloudera_add_services.yml"

echo "Hadoop cluster installation completed successfully!"
