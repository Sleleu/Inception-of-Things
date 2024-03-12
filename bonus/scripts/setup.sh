#!/bin/bash

kubectl create namespace gitlab

# Add the GitLab Helm repository to helm’s configuration:
helm repo add gitlab https://charts.gitlab.io/


helm install gitlab gitlab/gitlab \
  --set global.hosts.domain=gitlab-bonus.com \
  --set certmanager-issuer.email=me@example.com

# gitlab password
echo "gitlab password = $(kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode)"