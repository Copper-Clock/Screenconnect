#!/bin/bash

if [[ -f ./docker-compose.yml ]]; then
    docker compose up -d connect-wifi-connect
fi
