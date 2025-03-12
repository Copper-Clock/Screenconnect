#!/bin/bash

if [[ -f ./docker-compose.yml ]]; then
    docker compose up -d screenconnect-wifi-connect
fi
