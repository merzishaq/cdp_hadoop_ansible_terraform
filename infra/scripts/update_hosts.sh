#!/bin/bash

# Définir les chemins
HOSTS_FILE="./tmp_hosts/hosts"
> $HOSTS_FILE

# Récupérer l'adresse IP et le nom d'hôte
IP=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)

# Écrire les informations dans le fichier temporaire
echo "$IP $HOSTNAME" >> $HOSTS_FILE
echo "ajout dans tmp hosts."

