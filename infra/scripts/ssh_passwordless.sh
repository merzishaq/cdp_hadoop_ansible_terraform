#!/bin/bash

# Define the username and key paths
USER="universaluser"
SSH_DIR="/home/$USER/.ssh"
KEY_SRC_DIR="../ssh_keys"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

# Create the .ssh directory if it doesn't exist and set proper permissions
mkdir -p "$SSH_DIR"
chmod 777 "$SSH_DIR"

# Ensure that authorized_keys file exists
touch "$AUTHORIZED_KEYS"
chmod 777 "$AUTHORIZED_KEYS"

# Copy SSH keys to the user's .ssh directory
cp "$KEY_SRC_DIR/id_rsa" "$SSH_DIR"
cp "$KEY_SRC_DIR/id_rsa.pub" "$SSH_DIR"

# Ensure the private key is properly secured
chmod 600 "$SSH_DIR/id_rsa"
chmod 644 "$SSH_DIR/id_rsa.pub"

# Set ownership of the .ssh directory and its contents
chown -R "$USER:$USER" "$SSH_DIR"

# Add the public key to the authorized_keys file
if ! grep -q -f "$SSH_DIR/id_rsa.pub" "$AUTHORIZED_KEYS"; then
    cat "$SSH_DIR/id_rsa.pub" >> "$AUTHORIZED_KEYS"
fi

# Optional: Copy SSH key to localhost for passwordless login (omit if not needed)
ssh-copy-id "$USER@localhost"
