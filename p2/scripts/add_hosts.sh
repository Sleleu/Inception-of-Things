#!/bin/bash

for i in {1..3}; do
    line="192.168.56.110 app$i.com"

    if ! grep -q "$line" /etc/hosts; then
        echo "$line" >> /etc/hosts
        echo "Added HOST $line"
    else
        echo "$line already exists"
    fi
done