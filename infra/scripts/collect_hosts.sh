#!/bin/bash

# Fichier de sortie
OUTPUT_FILE="./my_hosts.txt"

# Vider le fichier de sortie s'il existe déjà
echo "" > $OUTPUT_FILE

# Obtenir les IPs des machines
for vm in $(vagrant global-status --prune | awk '/running/ {print $1}'); do
    echo "Récupération de l'IP pour VM $vm..."
    IP=$(vagrant ssh $vm -c "ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print \$2}' | cut -d'/' -f1" | grep '^124\.0\.24\.')
    VM_NAME=$(vagrant global-status --prune | grep $vm | awk '{print $2}')
    echo "$IP $VM_NAME" >> $OUTPUT_FILE
done

echo "Les adresses ont été écrites dans $OUTPUT_FILE."
