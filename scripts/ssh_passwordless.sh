#!/bin/bash
mkdir -p /home/universaluser/.ssh
chmod 700 /home/universaluser/.ssh
cp ../ssh_keys/id_rsa.pub /home/universaluser/.ssh/authorized_keys
chmod 600 /home/universaluser/.ssh/authorized_keys
chown -R universaluser:universaluser /home/universaluser/.ssh
