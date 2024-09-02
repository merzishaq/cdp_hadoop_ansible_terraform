#!/bin/bash

# Créer l'utilisateur 'universaluser' si il n'existe pas
if ! id "universaluser" &>/dev/null; then
  useradd -m -s /bin/bash universaluser
  echo "universaluser:universaluser" | chpasswd
  echo "Utilisateur 'universaluser' créé"
fi

# Ajouter 'universaluser' au groupe sudo
usermod -aG sudo universaluser

# Créer un fichier sudoers pour permettre à 'universaluser' d'exécuter des commandes sudo sans mot de passe
if [ ! -f /etc/sudoers.d/universaluser ]; then
  echo "universaluser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/universaluser
  chmod 440 /etc/sudoers.d/universaluser
  echo "Configuration sudo sans mot de passe pour 'universaluser'."
fi

# Configuration initiale pour SSH
SSH_DIR="/home/universaluser/.ssh"
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
touch $AUTHORIZED_KEYS
chmod 600 $AUTHORIZED_KEYS

# Vérification si la clé publique existe avant de copier
if [ -f "/home/universaluser/ssh_keys/id_rsa.pub" ]; then
  # Ajouter la clé publique au fichier authorized_keys s'il n'est pas déjà présent
  if ! grep -q -f "/home/universaluser/ssh_keys/id_rsa.pub" "$AUTHORIZED_KEYS"; then
    cat "/home/universaluser/ssh_keys/id_rsa.pub" >> "$AUTHORIZED_KEYS"
    echo "Clé publique ajoutée à authorized_keys."
    cp /home/universaluser/ssh_keys/id_rsa.pub $SSH_DIR
    chmod 644 $SSH_DIR/id_rsa.pub
  fi
else
  echo "Clé publique non trouvée dans /home/universaluser/ssh_keys/id_rsa.pub."
fi

# Vérification si la clé privée existe avant de copier
if [ -f "/home/universaluser/ssh_keys/id_rsa" ]; then
  cp /home/universaluser/ssh_keys/id_rsa $SSH_DIR
  chmod 600 $SSH_DIR/id_rsa
  echo "Clé privée copiée et permissions mises à jour."
else
  echo "Clé privée non trouvée dans /home/universaluser/ssh_keys/id_rsa."
fi

# Assigner le bon propriétaire
chown -R universaluser:universaluser $SSH_DIR

echo "Configuration terminée pour 'universaluser'."
