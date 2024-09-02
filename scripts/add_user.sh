#!/bin/bash

# Créer l'utilisateur 'universaluser' si il n'existe pas
if ! id "universaluser" &>/dev/null; then
  useradd -m -s /bin/bash universaluser
  echo "universaluser:universaluser" | chpasswd
fi

# Ajouter 'universaluser' au groupe sudo
usermod -aG sudo universaluser

# Créer un fichier sudoers pour permettre à 'universaluser' d'exécuter des commandes sudo sans mot de passe
echo "universaluser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/universaluser
chmod 440 /etc/sudoers.d/universaluser
