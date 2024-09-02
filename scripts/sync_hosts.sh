#!/bin/bash

# Chemin vers le fichier hosts
HOSTS_FILE="/etc/hosts"

# Créer un répertoire pour les fichiers hosts temporaires
TEMP_DIR="../tmp/hosts_sync"
mkdir -p $TEMP_DIR

# Copier le fichier hosts localement
cp $HOSTS_FILE $TEMP_DIR/hosts

# Synchroniser le fichier hosts avec toutes les autres machines
for machine in $(hostname -I | awk '{print $1}'); do
  if [ "$machine" != "$(hostname -I | awk '{print $1}')" ]; then
    scp $TEMP_DIR/hosts universaluser@$machine:/tmp/hosts
    ssh universaluser@$machine "sudo cp /tmp/hosts /etc/hosts && sudo chmod 644 /etc/hosts"
  fi
done

# Nettoyer
rm -rf $TEMP_DIR
