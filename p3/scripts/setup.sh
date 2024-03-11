#!/bin/bash

LIGHT_GREEN='\033[1;32m'
END='\033[0m'

# k3d cluster
k3d cluster create sleleuC -p 8080:80@loadbalancer

# setup namespaces
kubectl create namespace argocd
kubectl create namespace dev
sleep 5

# setup argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch deployment argocd-server -n argocd --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--insecure"}]'

# wait for argocd to be ready
kubectl wait --for=condition=Ready pod --all -n argocd --timeout=360s

# ingress argocd
kubectl apply  -n argocd -f "../argocd/ingress.yaml"

# get password
export ARGOCD_PASSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "${LIGHT_GREEN}Argocd password: $ARGOCD_PASSWD${END}"
sleep 5

# login to argocd
argocd login localhost:8080 --insecure --username admin --password $ARGOCD_PASSWD --plaintext --grpc-web

# create the app
argocd app create --file "../app/appset.yaml" --sync-policy automated