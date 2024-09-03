#!/bin/bash

# Output files for hosts and known_hosts
HOSTS_FILE="../tmp_hosts/my_hosts.txt"
KNOWN_HOSTS_FILE="../tmp_hosts/my_known_hosts.txt"
VAGRANT_TMP_HOSTS="/tmp"
VAGRANT_KNOWN_HOSTS="/tmp"

# Clear the output files if they already exist
> "$KNOWN_HOSTS_FILE"
> "$HOSTS_FILE"

# Get IP addresses and VM names for all running VMs
for vm in $(vagrant global-status --prune | awk '/running/ {print $1}'); do
    echo "Retrieving IP for VM $vm..."

    # Get the VM's IP address (only those matching '124.0.24.*')
    IP=$(vagrant ssh $vm -c "ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print \$2}' | cut -d'/' -f1" | grep '^124\.0\.24\.')

    # Get the VM's name
    VM_NAME=$(vagrant global-status --prune | grep $vm | awk '{print $2}')

    # Append the IP and VM name to the hosts file
    echo "$IP $VM_NAME" >> "$HOSTS_FILE"

    # Use ssh-keyscan to get the SSH public key for both IP and hostname, then append to known_hosts file
    keyscan_output_ip=$(ssh-keyscan -H $IP 2>/dev/null)
    echo "$keyscan_output_ip" >> "$KNOWN_HOSTS_FILE"
    keyscan_output_hostname=$(ssh-keyscan -H $VM_NAME 2>/dev/null)
    echo "$keyscan_output_hostname" >> "$KNOWN_HOSTS_FILE"

    # Sort and remove duplicate lines from the known_hosts file
    sort -u "$KNOWN_HOSTS_FILE" -o "$KNOWN_HOSTS_FILE"
done


# For each running VM, update /etc/hosts and known_hosts
for vm in $(vagrant global-status --prune | awk '/running/ {print $1}'); do
    echo "Updating /etc/hosts on VM with ID $vm..."

    # Ensure temporary directory exists and clear it before updating /etc/hosts
    vagrant ssh $vm -c "sudo mkdir -p $VAGRANT_TMP_HOSTS"
    vagrant ssh $vm -c "sudo rm -rf $VAGRANT_TMP_HOSTS/*"
    
    # Upload the hosts file to the VM
    vagrant upload -t $HOSTS_FILE $VAGRANT_TMP_HOSTS/$(basename $HOSTS_FILE) $vm

    # Append the content to /etc/hosts on the VM and clean up
    vagrant ssh $vm -c "sudo sh -c 'cat $VAGRANT_TMP_HOSTS/* >> /etc/hosts'"
    vagrant ssh $vm -c "sudo rm -rf $VAGRANT_TMP_HOSTS/*"

    # Ensure temporary directory for known_hosts exists and clear it before updating known_hosts
    vagrant ssh $vm -c "sudo mkdir -p $VAGRANT_KNOWN_HOSTS"
    vagrant ssh $vm -c "sudo rm -rf $VAGRANT_KNOWN_HOSTS/*"
    
    # Upload the known_hosts file to the VM
    vagrant upload -t $KNOWN_HOSTS_FILE $VAGRANT_KNOWN_HOSTS/$(basename $KNOWN_HOSTS_FILE) $vm

    # Append the content to the VM's known_hosts and clean up
    vagrant ssh $vm -c "sudo sh -c 'cat $VAGRANT_KNOWN_HOSTS/* >> ~/.ssh/known_hosts'"
    vagrant ssh $vm -c "sudo rm -rf $VAGRANT_KNOWN_HOSTS/*"
done

echo "IP addresses and hostnames have been added to /etc/hosts on all VMs."
