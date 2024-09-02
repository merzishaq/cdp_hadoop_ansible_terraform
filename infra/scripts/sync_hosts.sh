#!/bin/bash

# Fichier temporaire pour stocker les informations des hôtes
HOSTS_FILE="/tmp/vm_hosts_info"

# Créer ou vider le fichier temporaire
> $HOSTS_FILE

# Récupérer les informations des hôtes des VMs
for VM_ID in $(vagrant global-status --prune | awk '{print $1}' | grep -v '^id'); do
  IP=$(vagrant ssh-config $VM_ID | grep HostName | awk '{print $2}')
  VM_NAME=$(vagrant global-status --prune | grep $VM_ID | awk '{print $2}')
  echo "$IP $VM_NAME" >> $HOSTS_FILE
done

# Copier les informations dans les fichiers /etc/hosts des VMs
for VM_ID in $(vagrant global-status --prune | awk '{print $1}' | grep -v '^id'); do
  vagrant ssh $VM_ID -c "sudo cp /tmp/vm_hosts_info /etc/hosts"
done

echo "Fichiers /etc/hosts mis à jour sur toutes les VMs."
