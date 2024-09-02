#!/bin/bash

# Fichiers de sortie
HOSTS_FILE="../tmp_hosts/my_hosts.txt"
KNOWN_HOSTS_FILE="../tmp_hosts/my_known_hosts.txt"

# Vider les fichiers de sortie s'ils existent déjà
> "$KNOWN_HOSTS_FILE"
> "$HOSTS_FILE"

# Obtenir les IPs et noms des machines
for vm in $(vagrant global-status --prune | awk '/running/ {print $1}'); do
    echo "Récupération de l'IP pour VM $vm..."
    
    # Obtenir l'adresse IP
    IP=$(vagrant ssh $vm -c "ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print \$2}' | cut -d'/' -f1" | grep '^124\.0\.24\.')
    
    # Obtenir le nom de la VM
    VM_NAME=$(vagrant global-status --prune | grep $vm | awk '{print $2}')
    
    # Ajouter les informations aux fichiers de sortie
    echo "$IP $VM_NAME" >> "$HOSTS_FILE"
    echo "$IP" >> "$KNOWN_HOSTS_FILE"
    echo "$VM_NAME" >> "$KNOWN_HOSTS_FILE"
done

# Copier le fichier de hosts sur chaque VM et mettre à jour /etc/hosts
for vm in $(vagrant global-status --prune | awk '/running/ {print $1}'); do
    echo "Mise à jour de /etc/hosts sur $vm..."
    
    # Copier le fichier vers la VM
    vagrant scp "$HOSTS_FILE" $vm:/tmp/my_hosts.txt
    
    # Mettre à jour /etc/hosts tout en conservant l'ancien contenu
    vagrant ssh $vm -c "sudo sh -c 'cat /tmp/my_hosts.txt >> /etc/hosts'"
    
    # Nettoyer le fichier temporaire sur la VM
    vagrant ssh $vm -c "rm /tmp/my_hosts.txt"
done

echo "Les adresses ont été écrites dans $HOSTS_FILE et ajoutées à /etc/hosts sur les VMs."
