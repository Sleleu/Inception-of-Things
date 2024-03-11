#!/bin/bash

LIGHT_GREEN='\033[1;32m'
END='\033[0m'

# k3d cluster
k3d cluster create sleleuC

# setup namespaces
kubectl create namespace argocd
kubectl create namespace dev
sleep 5

# setup argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for argocd to be ready
# ingress here
kubectl wait --for=condition=Ready pod --all -n argocd --timeout=360s

# port forward
kubectl port-forward svc/argocd-server -n argocd 8080:80 > /dev/null 2>&1 &

# get password
export ARGOCD_PASSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "${LIGHT_GREEN}Argocd password: $ARGOCD_PASSWD${END}"

# login to argocd
argocd login localhost:8080 --insecure --username admin --password $ARGOCD_PASSWD

# add HOSTS
if ! grep -q "127.0.0.1 argocd-server.com" /etc/hosts; then
    echo "127.0.0.1 argocd-server.com" >> /etc/hosts
    echo -e "${LIGHT_GREEN}Added HOST '127.0.0.1 argocd-server.com'${END}"
else
    echo -e "${LIGHT_GREEN}'127.0.0.1 argocd-server.com' already exists${END}"
fi

# create the app
argocd app create --file "../app/appset.yaml" --sync-policy automated