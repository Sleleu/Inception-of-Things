#!/bin/bash

LIGHT_GREEN='\033[1;32m'
END='\033[0m'

line="127.0.0.1 argocd-server.com"
if ! grep -q "$line" /etc/hosts; then
    echo "$line" >> /etc/hosts
    echo -e "${LIGHT_GREEN}Added HOST '$line'${END}"
else
    echo -e "${LIGHT_GREEN}HOST '$line' already exists${END}"
fi