#!/bin/bash

LIGHT_GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
END='\033[0m'

# k3d cluster
k3d cluster create sleleuC -p 8888:80@loadbalancer

# setup namespaces
kubectl create namespace argocd
kubectl create namespace dev
sleep 3

# setup argocd
echo -e "${LIGHT_GREEN}creating argocd${END}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 3

# patch argocd-server
echo -e "${LIGHT_GREEN}patching argocd-server${END}"
kubectl patch deployment argocd-server -n argocd --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--insecure"}]'

# wait for argocd to be ready
echo -e "${LIGHT_GREEN}waiting for argocd pods to be ready${END}"
kubectl wait --for=condition=Ready pod --all -n argocd --timeout=360s

# ingress argocd and dev
kubectl apply  -n argocd -f "confs/ingress.yaml"
kubectl apply -n dev -f "confs/wil-ingress.yaml"

# get password
export ARGOCD_PASSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
sleep 3

# login to argocd
argocd login argocd-server.com:8888 --insecure --username admin --password $ARGOCD_PASSWD --plaintext --grpc-web

# create the app
argocd app create --file "confs/appset.yaml" --sync-policy automated
argocd app wait wil --sync --health

echo -e "${LIGHT_GREEN}waiting for dev pods to be ready${END}"
kubectl wait --for=condition=Ready pod --all -n dev --timeout=360s

echo -e "${LIGHT_GREEN}|------------------ ⚡ setup complete ⚡ ----------------|${END}"
echo -e "${LIGHT_GREEN}|     ${CYAN}argocd ${YELLOW}=> ${LIGHT_GREEN}http://argocd-server.com:8888            |${END}"
echo -e "${LIGHT_GREEN}|     ${CYAN}app    ${YELLOW}=> ${LIGHT_GREEN}http://localhost:8888                    |${END}"
echo -e "${LIGHT_GREEN}|                                                        |${END}"
echo -e "${LIGHT_GREEN}|     ${CYAN}Argocd password is ${YELLOW}=> ${LIGHT_GREEN}'$ARGOCD_PASSWD'           |${END}"
echo -e "${LIGHT_GREEN}|--------------------------------------------------------|${END}"