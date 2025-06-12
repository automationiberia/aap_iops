#!/usr/bin/env bash

#VAULT_SERVER='http://vaultserverhost:8200'
#VAULT_TOKEN='root'
#SSH_KEY_USERNAME="user1"
#SSH_KEY_FILE="~/.ssh/id_rsa"

read -p "Enter the Vault Server: " VAULT_SERVER
read -s -p "Enter the Vault Token: " VAULT_TOKEN
read -p "Enter the SSH Username: " SSH_KEY_USERNAME
read -p "Enter the SSH private key file: " SSH_KEY_FILE

SSH_PRIVATE_KEY=$(cat ${SSH_KEY_FILE})

oc project vault
oc exec vault-0 -- vault login -address=${VAULT_SERVER} ${VAULT_TOKEN}
oc exec vault-0 -- vault kv put secret/aap/machine username="${SSH_KEY_USERNAME}" ssh_key_data="${SSH_PRIVATE_KEY}"

