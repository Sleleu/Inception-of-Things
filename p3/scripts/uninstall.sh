#!/bin/bash

LIGHT_GREEN='\033[1;32m'
END='\033[0m'

# delete cluster
k3d cluster delete sleleuC
if [ $? -eq 0 ]; then
    echo -e "${LIGHT_GREEN}k3d cluster successfully deleted${END}"
else
    echo -e "${LIGHT_GREEN}k3d cluster not found${END}"
fi

# delete docker
docker system prune -a -f
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
if [ $? -eq 0 ]; then
    echo -e "${LIGHT_GREEN}docker successfully deleted${END}"
else
    echo -e "${LIGHT_GREEN}docker not found${END}"
fi

# delete k3d
if [ -f /usr/local/bin/k3d ]; then
    rm /usr/local/bin/k3d
    echo -e "${LIGHT_GREEN}k3d successfully deleted${END}"
else
    echo -e "${LIGHT_GREEN}k3d not installed${END}"
fi

# delete kubectl
if [ -f /usr/local/bin/kubectl ]; then
    rm /usr/local/bin/kubectl
    echo -e "${LIGHT_GREEN}kubectl successfully deleted${END}"
else
    echo -e "${LIGHT_GREEN}kubectl not installed${END}"
fi

# delete argocd
if [ -f /usr/local/bin/argocd ]; then
    rm /usr/local/bin/argocd
    echo -e "${LIGHT_GREEN}argocd successfully deleted${END}"
else
    echo -e "${LIGHT_GREEN}argocd not installed${END}"
fi
