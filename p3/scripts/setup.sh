#!/bin/bash

# k3d cluster
k3d cluster create sleleuC

# setup namespaces
kubectl create namespace argocd
kubectl create namespace dev

# setup argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml