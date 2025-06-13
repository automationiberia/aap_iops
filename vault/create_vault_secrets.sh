#!/usr/bin/env bash

INSTANCE_NAME=vault

oc new-project ${INSTANCE_NAME}
oc apply -f argocd-application-${INSTANCE_NAME}.yaml
oc adm policy add-scc-to-user anyuid -z ${INSTANCE_NAME}
oc adm policy add-scc-to-user anyuid -z ${INSTANCE_NAME}-agent-injector
sleep 5
ASSIGNED_CABUNDLE=$(oc get MutatingWebhookConfiguration -n openshift-gitops ${INSTANCE_NAME}-agent-injector-cfg -o yaml | yq eval '.webhooks[].clientConfig.caBundle')
oc get application -n openshift-gitops ${INSTANCE_NAME} -o yaml > /tmp/original
oc patch --type='merge' application -n openshift-gitops ${INSTANCE_NAME} -p '{"spec": {"source": {"helm": {"parameters": [{"name": "injector.certs.caBundle", "value": "${ASSIGNED_CABUNDLE}"}]}}}}'
oc get application -n openshift-gitops ${INSTANCE_NAME} -o yaml > /tmp/patched

#VAULT_SERVER='http://vaultserverhost:8200'
#VAULT_TOKEN='root'
#SSH_KEY_USERNAME="user1"
#SSH_KEY_FILE="~/.ssh/id_rsa"

read -p "Enter the Vault Server: " VAULT_SERVER
read -s -p "Enter the Vault Token: " VAULT_TOKEN
read -p "Enter the SSH Username: " SSH_KEY_USERNAME
read -p "Enter the SSH private key file: " SSH_KEY_FILE

SSH_PRIVATE_KEY=$(cat ${SSH_KEY_FILE})

oc exec ${INSTANCE_NAME}-0 -- vault login -address=${VAULT_SERVER} ${VAULT_TOKEN}
oc exec ${INSTANCE_NAME}-0 -- vault kv put secret/aap/machine username="${SSH_KEY_USERNAME}" ssh_key_data="${SSH_PRIVATE_KEY}"

